#include <boost/throw_exception.hpp>

#include "backend.h"
#include "storagemodel.h"

extern bool cpu_initialize();
extern bool gpu_initialize();
extern void cpu_cleanup();
extern void gpu_cleanup();

const int32_t TimerTick = 1000;

Backend::Backend(QObject *parent) : QObject(parent) {
    m_mon_timer = new QTimer(this);
    connect(m_mon_timer, &QTimer::timeout, this, QOverload<>::of(&Backend::sample));
    m_mon_timer->start(TimerTick);
}

bool
Backend::initialize() {
    if (!cpu_initialize())
        return false;
    
    if (!gpu_initialize())
        return false;
    
    return true;
}

Backend::~Backend() {
    m_mon_timer->stop();

    sensors_cleanup();
    cpu_cleanup();
    gpu_cleanup();
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
    sample_ram_usage();
}
