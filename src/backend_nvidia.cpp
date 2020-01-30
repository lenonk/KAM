#include <qmetatype.h>
#include <qtextstream.h>

#include <iostream>
#include <map>
#include <vector>

#include <boost/algorithm/string.hpp>

#include <X11/Xlib.h>
#include <NVCtrl/NVCtrl.h>
#include <NVCtrl/NVCtrlLib.h>

#include "backend.h"

enum sensor_type_t {
	SensorTypeGraphics  = 1 << 0,
    SensorTypeVideo     = 1 << 1,
    SensorTypePCIE      = 1 << 2,
    SensorTypeMemory    = 1 << 3,
    SensorTypeAmbient   = 1 << 4,
    SensorTypeTemp      = 1 << 5,
    SensorTypeFan       = 1 << 6,
};

static std::map<sensor_type_t, std::string> type_str {
    std::pair<sensor_type_t, std::string>(SensorTypeGraphics, "graphics"),
    std::pair<sensor_type_t, std::string>(SensorTypeVideo, "video"),
    std::pair<sensor_type_t, std::string>(SensorTypePCIE, "PCIe"),
    std::pair<sensor_type_t, std::string>(SensorTypeMemory, "memory"),
    std::pair<sensor_type_t, std::string>(SensorTypeAmbient, "ambient"),
    std::pair<sensor_type_t, std::string>(SensorTypeTemp, "temp"),
    std::pair<sensor_type_t, std::string>(SensorTypeFan, "fan rpm")
};

static Display *display = nullptr;
static bool initialized = false;

bool
gpu_initialize() {
    int evt, err;
    
    if (initialized)
        return true;
    
    if ((display = XOpenDisplay(NULL)) == nullptr) {
        std::cerr << "Could not open X11 display.  Aborting...\n";
        abort();
    }
    
    if (XNVCTRLQueryExtension(display, &evt, &err)) {
        initialized = true;
        return true;
    }
    
    std::cerr << "Failed to retrieve NVIDIA information.  Aborting...\n";
    abort();
}

static float 
get_att(int target, int att) {
    bool res;
    int temp;

    res = XNVCTRLQueryTargetAttribute(display, target, 0, 0, att, &temp);

    if (res == true)
        return temp;

    return -1;
}

static float
get_value(uint32_t attribute, sensor_type_t type) {
    bool ret = false;
    char *atts = nullptr;
    
    ret = XNVCTRLQueryTargetStringAttribute(display, NV_CTRL_TARGET_TYPE_GPU, 0, 
                                             0, attribute, &atts);
    
    if (ret == true) {
        std::string s(atts);
        
        s.erase(std::remove(s.begin(), s.end(), ' '), s.end());
        
        std::vector<std::string> nv_attrs;
        boost::split(nv_attrs, s, boost::is_any_of(","));
        
        for (std::string &tok : nv_attrs) {
            std::vector<std::string> attr_pair;
            boost::split(attr_pair, tok, boost::is_any_of("="));
            
            if (attr_pair[0] == type_str[type]) {
                return std::stof(attr_pair[1]);
            }
        }
    }
    
    return -1;
}

void
Backend::sample_gpu_usage() {
    m_gpu_usage = get_value(NV_CTRL_STRING_GPU_UTILIZATION, SensorTypeGraphics);
    emit gpu_usage_changed();
}

void
Backend::sample_gpu_temp() {
    m_gpu_temp = get_att(NV_CTRL_TARGET_TYPE_GPU, NV_CTRL_GPU_CORE_TEMPERATURE);
    emit gpu_temp_changed();
}

void
Backend::sample_gpu_fan() {
    static int32_t highest_speed = 2000;
    m_gpu_fan = get_att(NV_CTRL_TARGET_TYPE_COOLER, NV_CTRL_THERMAL_COOLER_SPEED);
    
    if (m_gpu_fan > highest_speed) 
        highest_speed = m_gpu_fan;
    
    m_gpu_fan_text = QString(std::to_string((int)m_gpu_fan).c_str());
    m_gpu_fan /= highest_speed;
    
    emit gpu_fan_changed();
}

void
Backend::sample_gpu_freq() {
    static int32_t highest_freq = 1500;
    int32_t temp = get_att(NV_CTRL_TARGET_TYPE_GPU, NV_CTRL_GPU_CURRENT_CLOCK_FREQS);
    
    m_gpu_freq = temp >> 16; // GPU Clock in upper 16 bits
    
    if (m_gpu_freq > highest_freq) 
        highest_freq = m_gpu_freq;
    
    m_gpu_freq_text = QString(std::to_string((int)m_gpu_freq).c_str());
    m_gpu_freq /= highest_freq;
    
    emit gpu_freq_changed();
}

void 
gpu_cleanup() {
    if (display) {
        XCloseDisplay(display);
        display = NULL;
    }
}
