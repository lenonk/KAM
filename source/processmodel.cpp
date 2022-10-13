#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <thread>
#include <vector>
#include <algorithm>
#include <cmath>
#include <iomanip>
#include <filesystem>

#include <boost/algorithm/string.hpp>

#include <libgen.h>

#include "processmodel.h"

#define MB / (1024 * 1024)
#define GB / (1024 * 1024 * 1024)

#define BOOST_NO_EXCEPTIONS
#include <boost/throw_exception.hpp>
void boost::throw_exception(std::exception const &e) { }

namespace global {
    uint64_t pg_sz;
    int32_t TimerTick = 100;
    const int32_t CompactSizeLimit = 20;
    //nvmlDevice_t nv_device = nullptr;
    const std::string application_data_path = "/usr/share/applications";
}

struct AppData {
    std::string name { "" };
    std::string icon { "" };
};

std::map<std::string, AppData> process_map;

ProcessModel::ProcessModel(QObject *parent) : QAbstractListModel(parent) {
    m_list = new ProcessList();

    if (m_timer && m_timer->isActive()) {
        m_timer->stop();
        delete m_timer;
    }

    parse_application_data();

    m_timer = new QTimer(this);
    connect(m_timer, &QTimer::timeout, this, QOverload<>::of(&ProcessModel::sample_processes));
    m_timer->start(global::TimerTick);
    
    global::pg_sz = sysconf(_SC_PAGESIZE);
    
    //nvmlInit();
    //nvmlDeviceGetHandleByIndex(0, &global::nv_device);
}

ProcessModel::~ProcessModel() {
    m_timer->stop();

    delete m_timer;
    delete m_list;
    
    //nvmlShutdown();
}

void
ProcessModel::stop_timer() {
    if (!m_timer) return;

    m_timer->stop();
}

void
ProcessModel::parse_application_data() {
    std::ifstream f;
    std::string line = "";

    for (const auto &entry : std::filesystem::directory_iterator(global::application_data_path)) {
        f.open(entry.path());
        if (!f.is_open()) continue;

        std::string name, icon, exec;
        std::vector<std::string> args;
        while (std::getline(f, line)) {
            // Skip any line of the form [...]
            if (line[0] == '[') continue;

            boost::split(args, line, boost::is_any_of("="));
            if (name.empty() && boost::iequals(args[0], "Name")) {
                name = args[1];
            }
            else if (icon.empty() && boost::iequals(args[0], "Icon")) {
                icon = args[1];
            }
            else if (exec.empty() && boost::iequals(args[0], "Exec")) {
                exec = args[1].substr(0, args[1].find(" "));
                exec.erase(std::remove_if(exec.begin(), exec.end(),
                                          [](unsigned char x) { return x == '"'; }),
                           exec.end());
                auto si = exec.find_last_of('/');
                if (si != std::string::npos)
                    exec = exec.substr(si + 1);
            }
        }

        if (name.size()) {
            AppData appData { name, icon };
            process_map[exec] = appData;
        }

        f.close();
    }
}

int
ProcessModel::rowCount(const QModelIndex &parent) const {
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid() || !m_list)
        return 0;

    if (m_mode == Compact && m_list->items().size() >= global::CompactSizeLimit)
        return global::CompactSizeLimit;
        
    return m_list->items().size();
}

QVariant
ProcessModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || !m_list)
        return QVariant();

    const ProcessItem item = m_list->items().at(index.row());
    switch (role) {
        case ProcessRole:
            return QVariant(item.process);
        case CpuRole:
            return QVariant(item.cpu);
        case GpuRole:
            return QVariant(item.gpu);
        case RamRole:
            return QVariant(item.ram);
        case UploadRole:
            return QVariant(item.upload);
        case DownloadRole:
            return QVariant(item.download);
    }

    return QVariant();
} 

QHash<int, QByteArray>
ProcessModel::roleNames() const {
    QHash<int, QByteArray> names;
    names[ProcessRole] = "process";
    names[CpuRole] = "cpu";
    names[GpuRole] = "gpu";
    names[RamRole] = "ram";
    names[UploadRole] = "upload";
    names[DownloadRole] = "download";
    
    return names;
}

static uint64_t 
get_total_cpu_time(uint64_t &work_time)
{
    FILE* file = fopen("/proc/stat", "r");
    if (file == NULL) {
        perror("Could not open stat file");
        return 0;
    }

    char buffer[1024];
    uint64_t user = 0, nice = 0, system = 0, idle = 0;
    uint64_t iowait = 0, irq = 0, softirq = 0, steal = 0, guest = 0, guestnice = 0;

    char* ret = fgets(buffer, sizeof(buffer) - 1, file);
    if (ret == NULL) {
        perror("Could not read stat file");
        fclose(file);
        return 0;
    }
    fclose(file);

    sscanf(buffer,
            "cpu  %16lu %16lu %16lu %16lu %16lu %16lu %16lu %16lu %16lu %16lu",
            &user, &nice, &system, &idle, &iowait, &irq, &softirq, &steal, &guest, &guestnice);

    work_time = user + nice + system;

    return user + nice + system + idle + iowait + irq + softirq + steal;
}

static double 
get_process_cpu_time(const proc_t *before, const proc_t *after, 
                     const uint64_t &prev_total_time, const uint64_t &current_total_time) {
    double total_time = current_total_time - prev_total_time;
    uint64_t process_time = ((after->utime + after->stime) - (before->utime + before->stime));

    return (process_time / total_time) * 100.0;
}

bool
cpu_greater_than(const ProcessItem &p1, const ProcessItem &p2) {
    if (p1.cpu == p2.cpu)
        return p1.ram > p2.ram;

    return p1.cpu > p2.cpu;
}

void
ProcessModel::make_process_item(ProcessItem &pi, proc_t *proc) {
    std::stringstream t;
    t << std::fixed << std::setprecision(1);
    
    // Process Name
    pi.process = QString(proc->cmd);
    
    // CPU Time
    t << get_process_cpu_time(&m_process_list[proc->tid], proc, 
                              m_prev_total_cpu_time, m_current_total_cpu_time) << "%";
    pi.cpu = QString(t.str().c_str());
    t.str(std::string());
    
    // RAM Usage
    if ((proc->resident * global::pg_sz) MB > 1000)
        t << (proc->resident * global::pg_sz) GB << "GiB";
    else
        t << (proc->resident * global::pg_sz) MB << "MiB";
    
    pi.ram = QString(t.str().c_str());
    t.str(std::string());
}

/*uint32_t
ProcessModel::get_gpu_utilitzation(nvmlProcessUtilizationSample_t **procs) {
    static uint64_t last_checked = 0;
    
    uint32_t proc_count = 0;
    nvmlDeviceGetProcessUtilization(global::nv_device, nullptr, &proc_count, 0);
    
    *procs = new nvmlProcessUtilizationSample_t[proc_count];
    nvmlDeviceGetProcessUtilization(global::nv_device, *procs, &proc_count, last_checked);
    if (proc_count > 0) {
        last_checked = (*procs)[0].timeStamp;
    }
  
    return proc_count;
}*/

void
ProcessModel::sample_processes() {
    
    int32_t flags = PROC_FILLCOM | PROC_FILLMEM | PROC_FILLUSR | PROC_FILLSTAT;
    
    m_prev_work_cpu_time = m_current_work_cpu_time;
    m_prev_total_cpu_time = m_current_total_cpu_time;
    m_current_total_cpu_time = get_total_cpu_time(m_current_work_cpu_time);
    
    proc_t **ps_list = readproctab(flags, nullptr);
    if (m_process_list.size()) {
        beginResetModel();
        
        m_list->items().clear();
        //nvmlProcessUtilizationSample_t *nv_procs = nullptr;
        //uint32_t nv_proc_count = get_gpu_utilitzation(&nv_procs);
        
        for (int32_t i = 0; ps_list[i] != nullptr; i++) {
            ProcessItem pi;

            QString name = qgetenv("USER");
            if (name.isEmpty()) qgetenv("USERNAME");

            if (!name.isEmpty()) {// TODO: And configured for user process only
                if (ps_list[i]->euser != name)
                    continue;
            }

            if (m_process_list.find(ps_list[i]->tid) != m_process_list.end()) {
                if (ps_list[i]->cmd[0] == '\0') continue;
                
                make_process_item(pi, ps_list[i]);
                
                /*for (uint32_t j = 0; j < nv_proc_count; j++) {
                    if ((uint32_t)ps_list[i]->tid == nv_procs[j].pid) {
                        if (nv_procs[j].smUtil != 0)
                            pi.gpu = QString((std::to_string(nv_procs[j].smUtil) + "%").c_str());
                    }
                }*/
                
                if (ps_list[i]->cmdline && ps_list[i]->cmdline[0] != nullptr) {
                    std::vector<std::string> args;
                    boost::split(args, ps_list[i]->cmdline[0], boost::is_any_of(" "));
                    if (args.size() > 0) {
                        auto proc_name = args[0];

                        auto si = proc_name.find_last_of('/');
                        if (si != std::string::npos)
                            proc_name = proc_name.substr(si + 1);
                        if (process_map.find(proc_name) != process_map.end()) {
                            AppData data = process_map[proc_name];
                            pi.process = data.name.c_str();
                            pi.icon = data.icon.c_str();

                            m_list->items().append(pi);
                        }
                    }
                }
            }
        }
        
        //delete[] nv_procs;
        std::sort(m_list->items().begin(), m_list->items().end(), cpu_greater_than);
       
        endResetModel();
    }
    
    
    // Replace the old list with the new list
    m_process_list.clear();
    for (int32_t i = 0; ps_list[i] != nullptr; i++) {
        // This is not safe to some degree.  A deep copy would need to be
        // done to make it completely safe.  It may yet be something I have
        // to do.
        m_process_list[ps_list[i]->tid] = *ps_list[i];
        freeproc(ps_list[i]);
    }
    
    // Timer is set to 100 ms for startup so that the list is populated
    // quickly.  Change it to 5 seconds here so we don't chew up resources.
    if (global::TimerTick < 5000 && m_list->items().size()) {
        global::TimerTick = 5000;
        if (m_timer && m_timer->isActive()) {
            m_timer->stop();
            m_timer->start(global::TimerTick);
        }
    }
}
