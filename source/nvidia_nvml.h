#ifndef NVIDIA_NVML_H
#define NVIDIA_NVML_H

#include <iostream>
#include <map>

enum sensor_type_t {
    SensorTypeGraphics  = 1 << 0,
    SensorTypeVideo     = 1 << 1,
    SensorTypePCIE      = 1 << 2,
    SensorTypeMemory    = 1 << 3,
    SensorTypeAmbient   = 1 << 4,
    SensorTypeTemp      = 1 << 5,
    SensorTypeFan       = 1 << 6,
    SensorTypeSClockMax = 1 << 7,
    SensorTypeMClockMax = 1 << 8,
    SensorTypeClock 	= 1 << 9,
};

static std::map<sensor_type_t, std::string> type_str {
    std::pair<sensor_type_t, std::string>(SensorTypeGraphics, "graphics"),
    std::pair<sensor_type_t, std::string>(SensorTypeVideo, "video"),
    std::pair<sensor_type_t, std::string>(SensorTypePCIE, "PCIe"),
    std::pair<sensor_type_t, std::string>(SensorTypeMemory, "memory"),
    std::pair<sensor_type_t, std::string>(SensorTypeAmbient, "ambient"),
    std::pair<sensor_type_t, std::string>(SensorTypeTemp, "temp"),
    std::pair<sensor_type_t, std::string>(SensorTypeFan, "fan rpm"),
    std::pair<sensor_type_t, std::string>(SensorTypeSClockMax, "nvclockmax"),
    std::pair<sensor_type_t, std::string>(SensorTypeMClockMax, "memclockmax"),
    std::pair<sensor_type_t, std::string>(SensorTypeClock, "nvclock"),
};

class NvidiaNVML
{
    public:
        NvidiaNVML() {};
        ~NvidiaNVML() {};

        bool initialize();
        void cleanup();

        bool is_initialized() { return m_initialized; };
        uint32_t get_sclk_max() { return sclk_max; }
        uint32_t get_mclk_max() { return mclk_max; }

        std::string &get_gpu_name() { return m_gpu_name; }

        uint32_t get_attribute(int32_t target, uint32_t att, uint32_t *out);
        uint32_t get_value(uint32_t attribute, sensor_type_t type, uint32_t *out);

    private:
        bool m_initialized { false };
        uint64_t sclk_max { 0 };
        uint64_t mclk_max { 0 };

        std::string m_gpu_name { "Unknown" };
};

#endif // NVIDIA_NVML_H
