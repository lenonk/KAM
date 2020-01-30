#ifndef __BACKEND_H__
#define __BACKEND_H__

#include <QObject>
#include <QVariant>
#include <QTimer>
#include <QElapsedTimer>
#include <QDebug>
#include <QList>

#include <mutex>
#include <sensors/sensors.h>

class Backend : public QObject {
    Q_OBJECT
    
    // CPU Properties
    Q_PROPERTY(int cpuUsage READ get_cpu_usage NOTIFY cpu_usage_changed)
    Q_PROPERTY(qreal cpuTemp READ get_cpu_temp NOTIFY cpu_temp_changed)
    
    Q_PROPERTY(qreal cpuFreq READ get_cpu_freq NOTIFY cpu_freq_changed)
    Q_PROPERTY(QString cpuFreqText READ get_cpu_freq_text NOTIFY cpu_freq_changed)
    
    Q_PROPERTY(qreal cpuFan READ get_cpu_fan NOTIFY cpu_fan_changed)
    Q_PROPERTY(QString cpuFanText READ get_cpu_fan_text NOTIFY cpu_fan_changed)
    
    // GPU Properties
    Q_PROPERTY(int gpuUsage READ get_gpu_usage NOTIFY gpu_usage_changed)
    Q_PROPERTY(qreal gpuTemp READ get_gpu_temp NOTIFY gpu_temp_changed)
    
    Q_PROPERTY(qreal gpuFreq READ get_gpu_freq NOTIFY gpu_freq_changed)
    Q_PROPERTY(QString gpuFreqText READ get_gpu_freq_text NOTIFY gpu_freq_changed)
    
    Q_PROPERTY(qreal gpuFan READ get_gpu_fan NOTIFY gpu_fan_changed)
    Q_PROPERTY(QString gpuFanText READ get_gpu_fan_text NOTIFY gpu_fan_changed)
    
    // RAM Properties
    Q_PROPERTY(qreal ramUsage READ get_ram_usage NOTIFY ram_usage_changed)
    
    // Mount point properties
    Q_PROPERTY(QString mountOne READ get_mount_one NOTIFY mount_points_changed)
    Q_PROPERTY(QString mountTwo READ get_mount_two NOTIFY mount_points_changed)
    
    Q_PROPERTY(int mountOneCapacity READ get_mount_one_capacity NOTIFY mount_points_changed)
    Q_PROPERTY(int mountTwoCapacity READ get_mount_two_capacity NOTIFY mount_points_changed)
    
    Q_PROPERTY(int mountOneUsed READ get_mount_one_used NOTIFY mount_points_changed)
    Q_PROPERTY(int mountTwoUsed READ get_mount_two_used NOTIFY mount_points_changed)
    
    public:
        explicit Backend(QObject *parent = nullptr);
        virtual ~Backend();
        
    signals:
        // CPU Signals
        void cpu_usage_changed();
        void cpu_temp_changed();
        void cpu_freq_changed();
        void cpu_fan_changed();
        
        // GPU Signals 
        void gpu_usage_changed();
        void gpu_temp_changed();
        void gpu_freq_changed();
        void gpu_fan_changed();
        
        // RAM Signals 
        void ram_usage_changed();
        
        // Mount point properties
        void mount_points_changed();
        
    public slots:
        // CPU Slots
        qreal get_cpu_usage() { return m_cpu_usage; }
        qreal get_cpu_temp() { return m_cpu_temp; }
        qreal get_cpu_freq() { return m_cpu_freq; }
        qreal get_cpu_fan() { return m_cpu_fan; }
        
        QString get_cpu_freq_text() { return m_cpu_freq_text; }
        QString get_cpu_fan_text() { return m_cpu_fan_text; }
        
        // GPU Slots
        qreal get_gpu_usage() { return m_gpu_usage; }
        qreal get_gpu_temp() { return m_gpu_temp; }
        qreal get_gpu_freq() { return m_gpu_freq; }
        qreal get_gpu_fan() { return m_gpu_fan; }
        
        QString get_gpu_freq_text() { return m_gpu_freq_text; }
        QString get_gpu_fan_text() { return m_gpu_fan_text; }
        
        // RAM Slots
        qreal get_ram_usage() { return m_ram_usage; }
        
        // Mount point slots
        QString get_mount_one() { return m_mount_one; }
        QString get_mount_two() { return m_mount_two; }
        
        int get_mount_one_used() { return m_mount_one_used; }
        int get_mount_two_used() { return m_mount_two_used; }
        
        int get_mount_one_capacity() { return m_mount_one_capacity; }
        int get_mount_two_capacity() { return m_mount_two_capacity; }
        
    private:
        // Internal member variables
        QTimer *m_mon_timer;
        
        bool m_initialized { false };
        bool m_disable_temp { false };
        bool m_disable_fan { false };
        
        // CPU member variables
        qreal m_cpu_usage { 0 };
        qreal m_cpu_temp { 0 };
        qreal m_cpu_freq { 0 };
        qreal m_cpu_fan { 0 };
        
        QString m_cpu_freq_text { "" };
        QString m_cpu_fan_text { "" };
        
        // GPU member variables
        qreal m_gpu_usage { 0 };
        qreal m_gpu_temp { 0 };
        qreal m_gpu_freq { 0 };
        qreal m_gpu_fan { 0 };
        
        QString m_gpu_freq_text { "" };
        QString m_gpu_fan_text { "" };
        
        // RAM member variables
        qreal m_ram_usage { 0 };
        
        // Mount private member variables
        QString m_mount_one { "" };
        QString m_mount_two { "" };
        
        int m_mount_one_capacity { 0 };
        int m_mount_two_capacity { 0 };
        
        int m_mount_one_used { 0 };
        int m_mount_two_used { 0 };
        
        void sample();
        
        // CPU private methods 
        void sample_cpu_usage();
        void sample_cpu_temp();
        void sample_cpu_freq();
        void sample_cpu_fan();
        
        // GPU private methods 
        void sample_gpu_usage();
        void sample_gpu_temp();
        void sample_gpu_freq();
        void sample_gpu_fan();
        
        
        // RAM private methods
        void sample_ram_usage();
        
        // Mount point private methods
        void sample_mount_usage();
        
        bool initialize();
};

#endif
