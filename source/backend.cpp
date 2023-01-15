#include <iostream>
#include <proc/sysinfo.h>
#include <fstream>
#include <filesystem>

#include <boost/throw_exception.hpp>

#include "common.h"
#include "backend.h"
//#include "storagemodel.h"

extern bool cpu_initialize();
extern bool gpu_initialize();
extern void cpu_cleanup();
extern void gpu_cleanup();

const int32_t TimerTick = 2000;

void boost::throw_exception(std::exception const & e){ }

std::vector<std::string> sensors_config_files {
    "/etc/sensors3.conf",
    "/etc/sensors.conf",
    "/usr/local/etc/sensors3.conf",
    "/usr/local/etc/sensors.conf"
};


Backend::Backend(QObject *parent) : QObject(parent) {
    //sample(); // TODO: Fix this, it's shitty code to call something that can fail from a constructor.

    m_cpu_num = sysconf(_SC_NPROCESSORS_ONLN);
    emit cpu_num_changed();

    m_mon_timer = new QTimer(this);
    connect(m_mon_timer, &QTimer::timeout, this, QOverload<>::of(&Backend::sample));
    m_mon_timer->start(TimerTick);
}

bool
Backend::sensors_initialize() {
    FILE *f = nullptr;

    if (m_initialized)
        return true;

    for (auto &file : sensors_config_files) {
        if ((f = fopen(file.c_str(), "r")) != nullptr) {
            break;
        }
    }

    if (!f) return false;

    if (sensors_init(f) != 0) {
        std::cerr << "Failed to initialize lm_sensors.  Do you have it installed \
            and have you run sensors-detect?\n";
        return false;
    }

    m_initialized = true;

    return true;
}

bool
Backend::initialize() {
    if (!sensors_initialize())
        return false;
    
    m_radeon_drm.initialize();
    emit has_radeon_changed();

    m_nvidia_nvml.initialize();
    emit has_nvidia_changed();

    sample_cpu_info();
    emit cpu_info_changed();

    return true;
}

Backend::~Backend() {
    m_mon_timer->stop();
    sensors_cleanup();

    if (m_nvidia_nvml.is_initialized())
        m_nvidia_nvml.cleanup();

    if (m_radeon_drm.is_initialized())
        m_radeon_drm.cleanup();
}

void
Backend::sample() {
    if (!m_initialized && !initialize())
        abort();
    
    if (m_radeon_drm.is_initialized()) {
        m_gpu_name = m_radeon_drm.get_gpu_name().c_str();
        emit gpu_name_changed();
    }
    else if (m_nvidia_nvml.is_initialized()) {
        m_gpu_name = m_nvidia_nvml.get_gpu_name().c_str();
        emit gpu_name_changed();
    }

    // CPU samples
    sample_cpu_temp();
    sample_cpu_usage();
    sample_cpu_freq();
    sample_cpu_fan();
    
    // GPU samples
    sample_gpu_temp();
    sample_gpu_usage();
    sample_gpu_freq();
    sample_gpu_fan();
    sample_gpu_power();

    // RAM Samples
    sample_ram_usage();

    // Storage Samples
    sample_storage_usage();
}

// RAM
void
Backend::sample_ram_usage() {
   meminfo();
   m_ram_usage = (int)((float)kb_main_used / (float)kb_main_total * 100);

   emit ram_usage_changed();
}

// Storage
#include <boost/algorithm/string.hpp>

const std::string ProcMounts = "/proc/mounts";
#define GB / (1024 * 1024 * 1024)

void
read_mounts(std::vector<std::string> &mounts) {
    std::ifstream f_stat(ProcMounts);

    if (!f_stat.is_open()) {
        kam_error("Failed to open" + ProcMounts + ". Aborting...", false);
        return;
    }

    std::string line;
    while (std::getline(f_stat, line)) {
        if (line.substr(0, 7) != "/dev/sd" &&
            line.substr(0, 7) != "/dev/nv"  &&
            line.substr(0, 7) != "/dev/md"  &&
            line.substr(0, 11) != "/dev/mapper") {
            continue;
        }

        std::vector<std::string> tokens;
        boost::split(tokens, line, boost::is_any_of(" "));

        if (tokens[1].find("efi") == std::string::npos)
            mounts.push_back(tokens[1]);
    }

    return;
}

void
Backend::sample_storage_usage() {
    std::vector<std::string> m_vec;
    read_mounts(m_vec);

    qreal total_storage = 0;
    qreal used_storage = 0;
    for (auto &m : m_vec) {
        auto si = std::filesystem::space(m);
        total_storage += si.capacity;
        used_storage += si.available;
    }

    m_storage_usage = (int)((qreal)used_storage / (qreal)total_storage * 100);
    emit storage_usage_changed();
}
