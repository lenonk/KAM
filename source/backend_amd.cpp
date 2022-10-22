#include <iostream>
#include <cmath>
#include <string>

#include "backend.h"
#include "common.h"

void
Backend::sample_gpu_usage() {
    uint32_t out = 0;

    if (m_radeon_drm.read_amdgpu_sensor(AMDGPU_INFO_SENSOR_GPU_LOAD, &out) != 0) {
        kam_error("Failed to read GPU usage from DRM");
        perror(nullptr);
        return;
    }

    m_gpu_usage = (qreal)out;
    emit gpu_usage_changed();
}

void
Backend::sample_gpu_freq() {
    uint32_t out = 0;

    if (m_radeon_drm.read_amdgpu_sensor(AMDGPU_INFO_SENSOR_GFX_SCLK, &out) != 0) {
        kam_error("Failed to read GPU frequency from DRM");
        perror(nullptr);
        return;
    }

    // Sometimes out is 0 for some odd reason, which should never happen
    // Corectrl shows the same data for AMD.  Maybe it will be fixed in the future.
    // Just short circuit this if that happens
    if (out != 0) {
        m_gpu_freq = (qreal)out / (qreal)m_radeon_drm.sclk_max;
        m_gpu_freq_text = QString(std::to_string(out).c_str());
        emit gpu_freq_changed();
    }
}

void
Backend::sample_gpu_temp() {
    uint32_t out = 0;

    if (m_radeon_drm.read_amdgpu_sensor(AMDGPU_INFO_SENSOR_GPU_TEMP, &out) != 0) {
        kam_error("Failed to read GPU temp from DRM");
        perror(nullptr);
        return;
    }

    m_gpu_temp = std::roundf(out / 1000);
    emit gpu_temp_changed();
};

// I'm not sure why there doesn't seem to be an ioctl for fan data, but
// it is what it is.  Use lm-sensors instead
static double
sensors_get_value(const sensors_chip_name *name, const sensors_subfeature *sub) {
    double val;

    if (sensors_get_value(name, sub->number, &val) != 0) {
        std::cerr << "Unable to retrieve value for " << sub->name << ".\n";
        val = -1;
    }
    return val;
}

void
Backend::sample_gpu_fan() {
    sensors_chip_name const *cn = nullptr;
    int c = 0;

    // TODO: Make this it's own variable so as not to disable the CPU fan as well
    if (m_disable_fan)
        return;

    while ((cn = sensors_get_detected_chips(nullptr, &c)) != nullptr) {
        // A GPU that supports fan data sensors should be one of these
        if (!strcmp(cn->prefix, "amdgpu"))
            break;
    }

    if (!cn) {
        std::cerr << "Unable to find supported chip for GPU fan data.\n";
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
        std::cerr << "Chip does not support GPU fan data.\n";
        m_disable_fan = true;
        return;
    }

    const sensors_subfeature *sf = nullptr;
    if ((sf = sensors_get_subfeature(cn, feat, SENSORS_SUBFEATURE_FAN_INPUT)) != nullptr) {
        m_gpu_fan = std::roundf(sensors_get_value(cn, sf));
        m_gpu_fan_text = QString(std::to_string((int)m_gpu_fan).c_str());
    }

    int32_t fan_max = 0;
    if ((sf = sensors_get_subfeature(cn, feat, SENSORS_SUBFEATURE_FAN_MAX)) != nullptr) {
        fan_max = std::roundf(sensors_get_value(cn, sf));
    }

    fan_max = (fan_max > 0) ? fan_max : 2500;
    m_gpu_fan /= static_cast<float>(fan_max);
    emit gpu_fan_changed();
};
