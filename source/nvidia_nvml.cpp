#include <vector>

#include <boost/algorithm/string.hpp>

#include <X11/Xlib.h>

#include <NVCtrl/NVCtrl.h>
#include <NVCtrl/NVCtrlLib.h>

#include "common.h"
#include "nvidia_nvml.h"

// Stupid to have this as a global, but it's part of a workaround for conflicting
// definition of Status in Xlib.h and QT headers
namespace global {
    Display *display { nullptr };
}

bool
NvidiaNVML::initialize() {
    int32_t evt, err;

    if (m_initialized)
        return true;

    if ((global::display = XOpenDisplay(NULL)) == nullptr) {
        kam_error("Could not open X11 display.  Aborting...", false);
        return false;
    }

    if (!XNVCTRLQueryExtension(global::display, &evt, &err)) {
        kam_error("No NVIDIA GPU detected.  Skipping NVIDIA initialization.", false);
        return false;
    }

    uint32_t out { 0 };
    if (get_value(NV_CTRL_STRING_GPU_CURRENT_CLOCK_FREQS, SensorTypeSClockMax, &out) != 0)
        kam_error("Failed to retrieve NVIDIA max shader clock.", false);
    else
        sclk_max = out;

    if (get_value(NV_CTRL_STRING_GPU_CURRENT_CLOCK_FREQS, SensorTypeMClockMax, &out) != 0)
        kam_error("Failed to retrieve NVIDIA max mem clock.", false);
    else
        mclk_max = out;

    char *name;
    auto ret = XNVCTRLQueryTargetStringAttribute(global::display, NV_CTRL_TARGET_TYPE_GPU, 0, 0, NV_CTRL_STRING_PRODUCT_NAME, &name);
    if (ret == false)
        kam_error("Unknown NVIDIA product name");
    else
        m_gpu_name = name;

    m_initialized = true;
    return true;
}

uint32_t
NvidiaNVML::get_attribute(int32_t target, uint32_t att, uint32_t *out) {
    if (XNVCTRLQueryTargetAttribute(global::display, target, 0, 0, att, reinterpret_cast<int32_t *>(out)))
        return 0;

    return -1;
}

uint32_t
NvidiaNVML::get_value(uint32_t attribute, sensor_type_t type, uint32_t *out) {
    char *atts = nullptr;

    auto ret = XNVCTRLQueryTargetStringAttribute(global::display, NV_CTRL_TARGET_TYPE_GPU, 0,
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
                *out = std::stol(attr_pair[1]);
                return 0;
            }
        }
    }

    return -1;
}

void
NvidiaNVML::cleanup() {
    if (m_initialized && global::display) {
        XCloseDisplay(global::display);
        global::display = nullptr;
    }
}
