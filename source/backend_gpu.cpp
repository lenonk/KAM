#include <iostream>
#include <cmath>
#include <string>

#include <NVCtrl/NVCtrl.h>

#include "backend.h"
#include "common.h"

void
Backend::sample_gpu_usage() {
    uint32_t out = 0;

    if (m_radeon_drm.is_initialized()) {
        if (m_radeon_drm.read_amdgpu_sensor(AMDGPU_INFO_SENSOR_GPU_LOAD, &out, sizeof(out)) != 0) {
            kam_error("Failed to read GPU usage from DRM");
            perror(nullptr);
            return;
        }
    }
    else if(m_nvidia_nvml.is_initialized()) {
        if (m_nvidia_nvml.get_value(NV_CTRL_STRING_GPU_UTILIZATION, SensorTypeGraphics, &out) != 0) {
            kam_error("Failed to read GPU usage from NVML");
            return;
        }
    }
    else {
        kam_error("Failed to read GPU usage.  Unknown graphics adapter");
        return;
    }

    m_gpu_usage = (qreal)out;
    emit gpu_usage_changed();
}

void
Backend::sample_gpu_freq() {
    uint32_t out = 0;

    if (m_radeon_drm.is_initialized()) {
        if (m_radeon_drm.read_amdgpu_sensor(AMDGPU_INFO_SENSOR_GFX_SCLK, &out, sizeof(out)) != 0) {
            kam_error("Failed to read GPU frequency from DRM");
            perror(nullptr);
            return;
        }

        if (out != 0) {
            m_gpu_freq = (qreal)out / (qreal)m_radeon_drm.get_sclk_max();
            m_gpu_freq_text = QString(std::to_string(out).c_str());
        }

        m_gpu_freq_max = m_radeon_drm.get_sclk_max();
    }
    else if (m_nvidia_nvml.is_initialized()) {
        if (m_nvidia_nvml.get_value(NV_CTRL_STRING_GPU_UTILIZATION, SensorTypeClock, &out) != 0) {
            kam_error("Failed to read GPU current clock from NVML");
            return;
        }

        if (out != 0) {
            m_gpu_freq = (qreal)out / (qreal)m_nvidia_nvml.get_sclk_max();
            m_gpu_freq_text = QString(std::to_string(out).c_str());
        }

        m_gpu_freq_max = m_nvidia_nvml.get_sclk_max();
    }
    else {
        kam_error("Failed to read GPU clocks.  Unknown graphics adapter");
        return;
    }

    emit gpu_freq_changed();
}

void
Backend::sample_gpu_temp() {
    uint32_t out = 0;

    if (m_radeon_drm.is_initialized()) {
        if (m_radeon_drm.read_amdgpu_sensor(AMDGPU_INFO_SENSOR_GPU_TEMP, &out, sizeof(out)) != 0) {
            kam_error("Failed to read GPU temp from DRM");
            perror(nullptr);
            return;
        }
    }
    else if (m_nvidia_nvml.is_initialized()) {
        if (m_nvidia_nvml.get_attribute(NV_CTRL_TARGET_TYPE_GPU, NV_CTRL_GPU_CORE_TEMPERATURE, &out) != 0) {
            kam_error("Failed to read GPU temp from NVML");
            return;
        }
    }
    else {
        kam_error("Failed to read GPU temp.  Unknown graphics adapter");
        return;
    }

    m_gpu_temp = std::roundf(out / 1000);

    emit gpu_temp_changed();
};

// I'm not sure why there doesn't seem to be an ioctl for amdgpu fan data, but
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
    // TODO: Make this it's own variable so as not to disable the CPU fan as well
    if (m_disable_fan)
        return;

    if (m_radeon_drm.is_initialized()) {
        sensors_chip_name const *cn = nullptr;
        int c = 0;

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

        if ((sf = sensors_get_subfeature(cn, feat, SENSORS_SUBFEATURE_FAN_MAX)) != nullptr) {
            m_gpu_fan_max = std::roundf(sensors_get_value(cn, sf));
        }

        m_gpu_fan_max = (m_gpu_fan_max > 0) ? m_gpu_fan_max : 3000;

        emit gpu_fan_changed();
    }
    else if (m_nvidia_nvml.is_initialized()) {
        uint32_t out { 0 };

        if (m_nvidia_nvml.get_value(NV_CTRL_STRING_GPU_CURRENT_CLOCK_FREQS, SensorTypeClock, &out) != 0) {
            kam_error("Failed to retrieve NVIDIA clock.  Aborting...", false);
            return;
        }

        m_gpu_fan_max = (m_gpu_fan_max > 0) ? m_gpu_fan_max : 3500;

        emit gpu_fan_changed();
    }
    else {
        kam_error("Failed to read GPU fan data.  Unknown graphics adapter");
        return;
    }
}

void
Backend::sample_gpu_power() {
     uint32_t out = 0;

    if (m_radeon_drm.is_initialized()) {
        if (m_radeon_drm.read_amdgpu_sensor(AMDGPU_INFO_SENSOR_GPU_AVG_POWER, &out, sizeof(out)) != 0) {
            kam_error("Failed to read GPU temp from DRM");
            perror(nullptr);
            return;
        }
    }
    else if (m_nvidia_nvml.is_initialized()) {
        // TODO: Figure this out for Nvidia
        /*if (m_nvidia_nvml.get_attribute(NV_CTRL_TARGET_TYPE_GPU, NV_CTRL_GPU_CORE_TEMPERATURE, &out) != 0) {
            kam_error("Failed to read GPU temp from NVML");
            return;
        }*/
    }
    else {
        kam_error("Failed to read GPU power.  Unknown graphics adapter");
        return;
    }

    m_gpu_power = static_cast<qint16>(out);

    emit gpu_power_changed();
}
