#ifndef __PROCESSMODEL_H__
#define __PROCESSMODEL_H__

#include <QAbstractListModel>
#include <QObject>
#include <QVector>
#include <QHash>
#include <QTimer>

#include <map>

#include <nvml/nvml.h>
#include <proc/procps.h>
#include <proc/readproc.h>

struct ProcessItem {
    QString process { "" };
    QString cpu { "" };
    QString gpu { "" };
    QString ram { "" };
    QString upload { "" };
    QString download { "" };
};

class ProcessList : public QObject {
    Q_OBJECT

    public:
        explicit ProcessList(QObject *parent = nullptr) : QObject(parent) {};

        QVector<ProcessItem> &items() { return m_items; }

    private:
        QVector<ProcessItem> m_items;
};

class ProcessModel : public QAbstractListModel {
    Q_OBJECT

public:
    explicit ProcessModel(QObject *parent = nullptr);
    virtual ~ProcessModel();

    enum {
        ProcessRole = Qt::UserRole,
        CpuRole,
        GpuRole,
        RamRole,
        UploadRole,
        DownloadRole
    };
    
    enum ProcessListMode {
        Compact,
        Full
    };

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    void make_process_item(ProcessItem &pi, proc_t *proc);
    uint32_t get_gpu_utilitzation(nvmlProcessUtilizationSample_t **procs);

    public slots:
        ProcessList *get_list() { return m_list; }
        
private:
    QTimer *m_timer;
    ProcessList *m_list;
    ProcessListMode m_mode = Compact;
    
    std::map<pid_t, proc_t> m_process_list;
    uint64_t m_prev_total_cpu_time { 0 };
    uint64_t m_current_total_cpu_time { 0 };
    uint64_t m_prev_work_cpu_time { 0 };
    uint64_t m_current_work_cpu_time { 0 };

    void sample_processes();
};

#endif // __PROCESSMODEL_H__
