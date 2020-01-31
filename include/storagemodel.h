#ifndef STORAGEMODEL_H
#define STORAGEMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include <QVector>
#include <QHash>
#include <QTimer>

struct StorageItem {
    QString name = "";
    int used = 0;
    int capacity = 0;
};

class StorageList : public QObject {
    Q_OBJECT

    public:
        explicit StorageList(QObject *parent = nullptr) : QObject(parent) {};

        QVector<StorageItem> &items() { return m_items; }

    private:
        QVector<StorageItem> m_items;
};

class StorageModel : public QAbstractListModel {
    Q_OBJECT

public:
    explicit StorageModel(QObject *parent = nullptr);
    virtual ~StorageModel();

    enum {
        NameRole = Qt::UserRole,
        UsedRole,
        CapacityRole
    };

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    signals:
        void storage_changed();

    public slots:
        StorageList *get_list() { return m_list; }
        
private:
    QTimer *m_timer;
    StorageList *m_list;

    void sample_mount_usage();
};

#endif // STORAGEMODEL_H
