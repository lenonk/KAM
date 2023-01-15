#include "source/common.h"
#include <thread>
#include <iostream>
#include <fstream>
#include <sstream>
#include <cmath>
#include <string>
#include <regex>

#include <QtSql/QtSql>

#include "common.h"
#include "backend.h"

enum CPUStates {
    S_USER = 0,
    S_NICE,
    S_SYSTEM,
    S_IDLE,
    S_IOWAIT,
    S_IRQ,
    S_SOFTIRQ,
    S_STEAL,
    S_GUEST,
    S_GUEST_NICE,
    NUM_CPU_STATES
};

const std::string ProcStat = "/proc/stat";
const std::string SysCpuFreq = "/sys/devices/system/cpu";

static int_fast64_t 
sum_active_time(int_fast64_t states[NUM_CPU_STATES]) {
    return  states[S_USER] +
            states[S_NICE] +
            states[S_SYSTEM] +
            states[S_IRQ] +
            states[S_SOFTIRQ] +
            states[S_STEAL] +
            states[S_GUEST] +
            states[S_GUEST_NICE];
}

static int_fast64_t 
sum_idle_time(int_fast64_t states[NUM_CPU_STATES]) {
    return states[S_IDLE] + states[S_IOWAIT];
}

static void
read_cpu_stats(int_fast64_t states[NUM_CPU_STATES]) {
    std::ifstream f_stat(ProcStat);
    
    if (!f_stat.is_open()) {
        std::cerr << "Failed to open" << ProcStat << ".  Aborting...\n";
        abort();
    }
    
    std::string line, trash;
    std::getline(f_stat, line);
    if (line.substr(0, 3) != "cpu") {
        std::cerr << "Unknown format in " << ProcStat << ".  Expected line to start with 'cpu'.\n";
        std::cerr << "Found: " << line;
        abort();
    }
    
    std::istringstream ss(line);
    
    // Read CPU label and throw away
    ss >> trash;
    
    for (int i = 0; i < NUM_CPU_STATES; i++)
        ss >> states[i];
};

void
Backend::sample_cpu_usage() {
    std::thread t ([&] {
        int_fast64_t s1[NUM_CPU_STATES];
        int_fast64_t s2[NUM_CPU_STATES];
    
        read_cpu_stats(s1);
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
        read_cpu_stats(s2);
        
        int_fast64_t a_time = sum_active_time(s2) - sum_active_time(s1);
        int_fast64_t i_time = sum_idle_time(s2) - sum_idle_time(s1);
        int_fast64_t t_time = a_time + i_time;
        
        float_t fcpu = static_cast<float_t>(100.f * a_time / t_time);
        m_cpu_usage = std::roundf(fcpu);
        
        emit cpu_usage_changed();
    });
    t.detach();
}

static double 
get_value(const sensors_chip_name *name, const sensors_subfeature *sub) {
    double val;

    if (sensors_get_value(name, sub->number, &val) != 0) {
        std::cerr << "Unable to retrieve value for " << sub->name << ".\n";
        val = -1;
    }
    return val;
}

void
Backend::sample_cpu_temp() {
    sensors_chip_name const *cn = nullptr;
    int c = 0;
    
    if (m_disable_temp)
        return;
    
    while ((cn = sensors_get_detected_chips(nullptr, &c)) != nullptr) {
        // A CPU that supports temperature sensors should be one of these
        if (!strcmp(cn->prefix, "coretemp") ||
            !strcmp(cn->prefix, "k10temp") ||
            !strcmp(cn->prefix, "k8temp") ||
            !strcmp(cn->prefix, "fam15h_power") ||
            !strcmp(cn->prefix, "via-cputemp"))
            break;
    }
    
    if (!cn) {
        std::cerr << "Unable to find supported chip for CPU temp.\n";
        m_disable_temp = true;
        return;
    }
    
    int32_t f = 0;
    const sensors_feature *feat = nullptr;
    while ((feat = sensors_get_features(cn, &f)) != nullptr) {
        if (feat->type == SENSORS_FEATURE_TEMP)
            break;
    }
            
    if (!feat) {
        std::cerr << "Chip does not support CPU temp.\n";
        m_disable_temp = true;
        return;
    }
    
    const sensors_subfeature *sf = nullptr;
    if ((sf = sensors_get_subfeature(cn, feat, SENSORS_SUBFEATURE_TEMP_INPUT)) != nullptr) {
        m_cpu_temp = std::roundf(get_value(cn, sf));
        emit cpu_temp_changed();
    }
};

void
Backend::sample_cpu_fan() {
    sensors_chip_name const *cn = nullptr;
    int c = 0;

    if (m_disable_fan)
        return;

    while ((cn = sensors_get_detected_chips(nullptr, &c)) != nullptr) {
        // A CPU that supports temperature sensors should be one of these
        if (cn->bus.type == SENSORS_BUS_TYPE_ISA) break;
    }

    if (!cn) {
        std::cerr << "Unable to find supported chip for CPU fan data.\n";
        m_disable_fan = true;
        return;
    }

    int32_t f = 0;
    const sensors_feature *feat = nullptr;
    while ((feat = sensors_get_features(cn, &f)) != nullptr) {
        if (feat->type == SENSORS_FEATURE_FAN && !strcmp(feat->name, "fan1"))
            break;
    }

    if (!feat) {
        std::cerr << "Chip does not support CPU fan data.\n";
        m_disable_fan = true;
        return;
    }

    const sensors_subfeature *sf = nullptr;
    if ((sf = sensors_get_subfeature(cn, feat, SENSORS_SUBFEATURE_FAN_INPUT)) != nullptr) {
        m_cpu_fan = std::roundf(get_value(cn, sf));
        m_cpu_fan_text = QString(std::to_string((int)m_cpu_fan).c_str());
    }

    int32_t fan_max = 0;
    if ((sf = sensors_get_subfeature(cn, feat, SENSORS_SUBFEATURE_FAN_MAX)) != nullptr) {
        fan_max = std::roundf(get_value(cn, sf));
    }

    fan_max = (fan_max > 0) ? fan_max : 2500;
    m_cpu_fan /= static_cast<float>(fan_max);
    emit cpu_fan_changed();
};

static int_fast32_t
read_freq_file(std::string s) {
    std::ifstream f_stat(s);
    
    if (!f_stat.is_open()) {
        std::cerr << "Failed to open " << s << ".  Aborting...\n";
        abort();
    }
    
    std::string line;
    std::getline(f_stat, line);
    if (!line.length()) {
        std::cerr << "No data found in " << s << std::endl;
        abort();
    }
    
    std::istringstream ss(line);
    
    int_fast32_t ret;
    ss >> ret;
    
    return ret;
}

#include <cpuid.h>

void
Backend::sample_cpu_freq() {
    uint8_t num_threads = std::thread::hardware_concurrency();
    
    for (int8_t i = 0; i < num_threads; i++) {
        float t_freq = read_freq_file(SysCpuFreq + "/cpu" + std::to_string(i) + "/cpufreq/scaling_cur_freq");
        if (t_freq <= m_cpu_freq)
            continue;
        
        m_cpu_freq = t_freq / 1000;
    }
    
    m_cpu_max_freq = read_freq_file(SysCpuFreq + "/cpu0" + "/cpufreq/cpuinfo_max_freq") / 1000 / 100 * 100; // Round down to nearest 100
    m_cpu_min_freq = read_freq_file(SysCpuFreq + "/cpu0" + "/cpufreq/cpuinfo_min_freq") / 1000 / 100 * 100;
    m_cpu_base_freq = read_freq_file(SysCpuFreq + "/cpu0" + "/cpufreq/scaling_max_freq") / 1000 / 100 * 100;

    m_cpu_freq_text = QString(std::to_string((int)(m_cpu_freq)).c_str());

    emit cpu_freq_changed();
}

static QString
find_cpu_model() {
    // TODO: Make this better
    char model[0x40];
    uint32_t info[4] = { 0,0,0,0 };

    __cpuid(0x80000000, info[0], info[1], info[2], info[3]);
    uint32_t nexids = info[0];

    memset(model, 0x0, sizeof(model));

    for (uint32_t i = 0x80000000; i <= nexids; i++) {
        __cpuid(i, info[0], info[1], info[2], info[3]);
        if (i == 0x80000002)
            memcpy(model, info, sizeof(info));
        if (i == 0x80000003)
            memcpy(model + 16, info, sizeof(info));
        if (i == 0x80000004)
            memcpy(model + 32, info, sizeof(info));
    }

    // This is disgusting and I hate it.  I am ashamed...
    std::string retval(model);
    std::regex rx("\\(R\\)");
    retval = std::regex_replace(retval, rx, "");
    rx.assign("\\(TM\\)");
    retval = std::regex_replace(retval, rx, "");
    rx.assign("Intel ");
    retval = std::regex_replace(retval, rx, "");
    rx.assign(" CPU @ \\d\\.\\d\\dGHz");
    retval = std::regex_replace(retval, rx, "");

    rx.assign("AMD ");
    retval = std::regex_replace(retval, rx, "");
    rx.assign(" \\d+-Core Processor");
    retval = std::regex_replace(retval, rx, "");

    return QString(retval.c_str());
}

void
Backend::sample_cpu_info() {
    m_cpu_model = find_cpu_model();
    m_cpu_model = m_cpu_model.trimmed();

    auto db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("processors.db");
    if (!db.open()) {
        kam_error("Unable to open processors DB");
        return;
    }

    QSqlQuery query;
    query.prepare("SELECT * from processors where model = (:model)");
    query.bindValue(":model", m_cpu_model);
    if (!query.exec()) {
        kam_error("Unable to open processors DB");
        return;
    }

    if (query.next()) {
        int32_t idx_code_name = query.record().indexOf("code_name");
        int32_t idx_socket_type = query.record().indexOf("socket_type");
        int32_t idx_tdp = query.record().indexOf("tdp");

        m_cpu_code_name = query.value(idx_code_name).toString();
        m_cpu_socket_type = query.value(idx_socket_type).toString();
        m_cpu_tdp = query.value(idx_tdp).toString();
    }

    emit cpu_info_changed();
}
