#include <iostream>

#include <boost/throw_exception.hpp>

#include "backend.h"
//#include "storagemodel.h"

extern bool cpu_initialize();
extern bool gpu_initialize();
extern void cpu_cleanup();
extern void gpu_cleanup();

const int32_t TimerTick = 1000;

std::vector<std::string> sensors_config_files {
    "/etc/sensors3.conf",
    "/etc/sensors.conf",
    "/usr/local/etc/sensors3.conf",
    "/usr/local/etc/sensors.conf"
};


Backend::Backend(QObject *parent) : QObject(parent) {
    m_model = new ProcessModel(this);
    sample(); // TODO: Fix this, it's shitty code to call something that can fail from a constructor.

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

    return true;
}

Backend::~Backend() {
    m_mon_timer->stop();
    sensors_cleanup();
}

void
Backend::sample() {
    if (!initialize())
        abort();
    
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
    
    // RAM Samples
    //sample_ram_usage();
}
