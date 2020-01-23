#ifndef __BACKEND_H__
#define __BACKEND_H__
#include <QObject>
#include <QVariant>
#include <QTimer>
#include <QElapsedTimer>
#include <QDebug>

#include <mutex>

class Backend : public QObject {
    Q_OBJECT
    
    //Q_PROPERTY(double best READ getBest WRITE setBest NOTIFY bestChanged)
    Q_PROPERTY(int cpuUsage READ getCpuUsage NOTIFY cpuChanged)
    
    public:
        explicit Backend(QObject *parent = nullptr) : QObject(parent) { 
            m_monTimer = new QTimer(this);
            connect(m_monTimer, &QTimer::timeout, this, QOverload<>::of(&Backend::sample));
            m_monTimer->start(500);
        }
        
        ~Backend() {
            delete m_monTimer;
        }
    signals:
        void cpuChanged();
        
    public slots:
        void sample();
        int getCpuUsage() { 
            std::lock_guard<std::mutex> lock(m_mx);
            return m_cpuUsage; 
            
        }
        
    private:
        
        int m_cpuUsage = 0;
        std::mutex m_mx;
        QTimer *m_monTimer;
        
};

#endif
