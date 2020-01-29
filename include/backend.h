#ifndef __BACKEND_H__
#define __BACKEND_H__

#include <QObject>
#include <QVariant>
#include <QTimer>
#include <QElapsedTimer>
#include <QDebug>

#include <mutex>
#include <sensors/sensors.h>

class Backend : public QObject {
    Q_OBJECT
    
    //Q_PROPERTY(double best READ getBest WRITE setBest NOTIFY bestChanged)
    Q_PROPERTY(int cpuUsage READ get_cpu_usage NOTIFY cpu_usage_changed)
    Q_PROPERTY(qreal cpuTemp READ get_cpu_temp NOTIFY cpu_temp_changed)
    
    Q_PROPERTY(qreal cpuFreq READ get_cpu_freq NOTIFY cpu_freq_changed)
    Q_PROPERTY(QString cpuFreqText READ get_cpu_freq_text NOTIFY cpu_freq_changed)
    
    Q_PROPERTY(qreal cpuFan READ get_cpu_fan NOTIFY cpu_fan_changed)
    Q_PROPERTY(QString cpuFanText READ get_cpu_fan_text NOTIFY cpu_fan_changed)
    
    public:
        explicit Backend(QObject *parent = nullptr);
        virtual ~Backend();
        
    signals:
        void cpu_usage_changed();
        void cpu_temp_changed();
        void cpu_freq_changed();
        void cpu_fan_changed();
        
    public slots:
        qreal get_cpu_usage() { return m_cpu_usage; }
        qreal get_cpu_temp() { return m_cpu_temp; }
        qreal get_cpu_freq() { return m_cpu_freq; }
        
        qreal get_cpu_fan() { return m_cpu_fan; }
        
        QString get_cpu_freq_text() { return m_cpu_freq_text; }
        QString get_cpu_fan_text() { return m_cpu_fan_text; }
        
    private:
        QTimer *m_mon_timer;
        
        bool m_initialized { false };
        bool m_disable_temp { false };
        bool m_disable_fan { false };
        
        qreal m_cpu_usage { 0 };
        qreal m_cpu_temp { 0 };
        qreal m_cpu_freq { 0 };
        qreal m_cpu_fan { 0 };
        
        QString m_cpu_freq_text { "" };
        QString m_cpu_fan_text { "" };
        
        void sample();
        void sample_cpu_usage();
        void sample_cpu_temp();
        void sample_cpu_freq();
        void sample_cpu_fan();
        
        bool initialize();
};

#endif
