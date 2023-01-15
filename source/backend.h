#ifndef __BACKEND_H__
#define __BACKEND_H__

#include <QObject>
#include <QVariant>
#include <QTimer>
#include <QElapsedTimer>
#include <QDebug>
#include <QList>
#include <QVector>

#include <mutex>
#include <sensors/sensors.h>

#include "radeon_drm.h"
#include "nvidia_nvml.h"

class StorageModel;

class Backend : public QObject {
    Q_OBJECT
    
    // CPU Properties
    Q_PROPERTY(qreal cpuUsage READ get_cpu_usage NOTIFY cpu_usage_changed)
    Q_PROPERTY(qreal cpuTemp READ get_cpu_temp NOTIFY cpu_temp_changed)
    
    Q_PROPERTY(qreal cpuFreq READ get_cpu_freq NOTIFY cpu_freq_changed)
    Q_PROPERTY(QString cpuFreqText READ get_cpu_freq_text NOTIFY cpu_freq_changed)
    Q_PROPERTY(qreal cpuMinFreq READ get_cpu_min_freq NOTIFY cpu_freq_changed)
    Q_PROPERTY(qreal cpuMaxFreq READ get_cpu_max_freq NOTIFY cpu_freq_changed)
    Q_PROPERTY(qreal cpuBaseFreq READ get_cpu_base_freq NOTIFY cpu_freq_changed)

    Q_PROPERTY(qreal cpuFan READ get_cpu_fan NOTIFY cpu_fan_changed)
    Q_PROPERTY(QString cpuFanText READ get_cpu_fan_text NOTIFY cpu_fan_changed)
    
    Q_PROPERTY(qint16 cpuNum READ get_cpu_num NOTIFY cpu_num_changed)

    Q_PROPERTY(QString cpuModel READ get_cpu_model NOTIFY cpu_info_changed)
    Q_PROPERTY(QString cpuCodeName READ get_cpu_code_name NOTIFY cpu_info_changed)
    Q_PROPERTY(QString cpuSocketType READ get_cpu_socket_type NOTIFY cpu_info_changed)
    Q_PROPERTY(QString cpuTDP READ get_cpu_tdp NOTIFY cpu_info_changed)

    //GPU Properties
    Q_PROPERTY(qreal gpuUsage READ get_gpu_usage NOTIFY gpu_usage_changed)
    Q_PROPERTY(qreal gpuTemp READ get_gpu_temp NOTIFY gpu_temp_changed)
    
    Q_PROPERTY(qreal gpuFreq READ get_gpu_freq NOTIFY gpu_freq_changed)
    Q_PROPERTY(qreal gpuFreqMax READ get_gpu_freq_max NOTIFY gpu_freq_changed)
    Q_PROPERTY(QString gpuFreqText READ get_gpu_freq_text NOTIFY gpu_freq_changed)
    
    Q_PROPERTY(qreal gpuFan READ get_gpu_fan NOTIFY gpu_fan_changed)
    Q_PROPERTY(qreal gpuFanMax READ get_gpu_fan_max NOTIFY gpu_fan_changed)
    Q_PROPERTY(QString gpuFanText READ get_gpu_fan_text NOTIFY gpu_fan_changed)

    Q_PROPERTY(QString gpuName READ get_gpu_name NOTIFY gpu_name_changed)

    Q_PROPERTY(qint16 gpuPower READ get_gpu_power NOTIFY gpu_power_changed)

    // RAM Properties
    Q_PROPERTY(qreal ramUsage READ get_ram_usage NOTIFY ram_usage_changed)

    // Storage Properties
    Q_PROPERTY(qreal storageUsage READ get_storage_usage NOTIFY storage_usage_changed)

    // Other Properties
    Q_PROPERTY(bool hasRadeon READ get_has_radeon NOTIFY has_radeon_changed)
    Q_PROPERTY(bool hasNvidia READ get_has_nvidia NOTIFY has_nvidia_changed)

    public:
        explicit Backend(QObject *parent = nullptr);
        virtual ~Backend();
        
    signals:
        // CPU Signals
        void cpu_usage_changed();
        void cpu_temp_changed();
        void cpu_freq_changed();
        void cpu_fan_changed();
        void cpu_num_changed();
        void cpu_info_changed();
        
        // GPU Signals 
        void gpu_usage_changed();
        void gpu_temp_changed();
        void gpu_freq_changed();
        void gpu_fan_changed();
        void gpu_name_changed();
        void gpu_power_changed();

        // RAM Signals 
        void ram_usage_changed();
        
        // Storage Signals
        void storage_usage_changed();

        // Other signals
        void has_radeon_changed();
        void has_nvidia_changed();

    public slots:
        // CPU Slots
        qreal get_cpu_usage() { return m_cpu_usage; }
        qreal get_cpu_temp() { return m_cpu_temp; }
        qreal get_cpu_freq() { return m_cpu_freq; }
        qreal get_cpu_min_freq() { return m_cpu_min_freq; }
        qreal get_cpu_max_freq() { return m_cpu_max_freq; }
        qreal get_cpu_base_freq() { return m_cpu_base_freq; }
        qreal get_cpu_fan() { return m_cpu_fan; }
        qint16 get_cpu_num() { return m_cpu_num; }
        
        QString get_cpu_model() { return m_cpu_model; }
        QString get_cpu_code_name() { return m_cpu_code_name; }
        QString get_cpu_socket_type() { return m_cpu_socket_type; }
        QString get_cpu_tdp() { return m_cpu_tdp; }

        QString get_cpu_freq_text() { return m_cpu_freq_text; }
        QString get_cpu_fan_text() { return m_cpu_fan_text; }
        
        // GPU Slots
        qreal get_gpu_usage() { return m_gpu_usage; }
        qreal get_gpu_temp() { return m_gpu_temp; }
        qreal get_gpu_freq() { return m_gpu_freq; }
        qreal get_gpu_freq_max() { return m_gpu_freq_max; }
        qreal get_gpu_fan() { return m_gpu_fan; }
        qreal get_gpu_fan_max() { return m_gpu_fan_max; }

        QString get_gpu_freq_text() { return m_gpu_freq_text; }
        QString get_gpu_fan_text() { return m_gpu_fan_text; }
        
        QString get_gpu_name() { return m_gpu_name; }

        qint16 get_gpu_power() { return m_gpu_power; }

        // RAM Slots
        qreal get_ram_usage() { return m_ram_usage; }

        // Storage Slots
        qreal get_storage_usage() { return m_storage_usage; }

        // Other Slots
        bool get_has_radeon() { return m_radeon_drm.is_initialized(); }
        bool get_has_nvidia() { return m_nvidia_nvml.is_initialized(); }

    private:
        // Internal member variables
        QTimer *m_mon_timer;
        
        bool m_initialized { false };
        bool m_drm_initialized { false };
        bool m_disable_temp { false };
        bool m_disable_fan { false };
        
        // CPU member variables
        qreal m_cpu_usage { 0 };
        qreal m_cpu_temp { 0 };
        qreal m_cpu_freq { 0 };
        qreal m_cpu_min_freq { 0 };
        qreal m_cpu_max_freq { 0 };
        qreal m_cpu_base_freq { 0 };
        qreal m_cpu_fan { 0 };
        qint16 m_cpu_num { 0 };
        
        QString m_cpu_model { "Unknown" };
        QString m_cpu_code_name { "Unknown" };
        QString m_cpu_socket_type { "Unknown" };
        QString m_cpu_tdp { "0" };

        QString m_cpu_freq_text { "" };
        QString m_cpu_fan_text { "" };
        
        // GPU member variables
        qreal m_gpu_usage { 0 };
        qreal m_gpu_temp { 0 };
        qreal m_gpu_freq { 0 };
        qreal m_gpu_freq_max { 0 };
        qreal m_gpu_fan { 0 };
        qreal m_gpu_fan_max { 0 };

        QString m_gpu_freq_text { "" };
        QString m_gpu_fan_text { "" };
        
        QString m_gpu_name { "Unknown" };

        qint16 m_gpu_power { 0 };

        // RAM member variables
        qreal m_ram_usage { 0 };
        
        // Storage member variables
        qreal m_storage_usage { 0 };

        RadeonDRM m_radeon_drm;
        NvidiaNVML m_nvidia_nvml;

        // Private Methods
        void sample();

        // CPU private methods
        void sample_cpu_usage();
        void sample_cpu_temp();
        void sample_cpu_freq();
        void sample_cpu_fan();
        void sample_cpu_info();
        
        // GPU private methods 
        void sample_gpu_usage();
        void sample_gpu_temp();
        void sample_gpu_freq();
        void sample_gpu_fan();
        void sample_gpu_power();
        
        // RAM private methods
        void sample_ram_usage();
        
        // Mount point private methods
        void sample_storage_usage();
        
        // Lib USB / Lighting
        //void detect_usb_devices();
        
        bool sensors_initialize();
        bool initialize();
};

#endif
