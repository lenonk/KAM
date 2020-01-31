#include <iostream>

#include <boost/filesystem.hpp>
#include <boost/algorithm/string.hpp>

#include "storagemodel.h"

const std::string ProcMounts = "/proc/mounts";

#define GB / (1024 * 1024 * 1024)

const int32_t TimerTick = 1000;

StorageModel::StorageModel(QObject *parent) : QAbstractListModel(parent) {
    m_list = new StorageList();

    m_timer = new QTimer(this);
    connect(m_timer, &QTimer::timeout, this, QOverload<>::of(&StorageModel::sample_mount_usage));
    m_timer->start(TimerTick);
}

StorageModel::~StorageModel() {
    m_timer->stop();

    delete m_list;
}

int
StorageModel::rowCount(const QModelIndex &parent) const {
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid() || !m_list)
        return 0;

    return m_list->items().size();
}

QVariant
StorageModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || !m_list)
        return QVariant();

    const StorageItem item = m_list->items().at(index.row());
    switch (role) {
        case NameRole:
            return QVariant(item.name);
        case CapacityRole:
            return QVariant(item.capacity);
        case UsedRole:
            return QVariant(item.used);
    }

    return QVariant();
}

QHash<int, QByteArray>
StorageModel::roleNames() const {
    QHash<int, QByteArray> names;
    names[NameRole] = "name";
    names[UsedRole] = "used";
    names[CapacityRole] = "capacity";
    
    return names;
}

static void
read_mounts(std::vector<std::string> &mounts) {
    std::ifstream f_stat(ProcMounts);

    if (!f_stat.is_open()) {
        std::cerr << "Failed to open" << ProcMounts << ".  Aborting...\n";
        abort();
    }

    std::string line;
    while (std::getline(f_stat, line)) {
        if (line.substr(0, 7) != "/dev/sd" &&
            line.substr(0, 7) != "/dev/nv" &&
            line.substr(0, 7) != "/dev/md") {
            continue;
        }

        std::vector<std::string> tokens;
        boost::split(tokens, line, boost::is_any_of(" "));

        if (tokens[1].find("efi") == std::string::npos)
            mounts.push_back(tokens[1]);
    }
}

void
StorageModel::sample_mount_usage() {
    std::vector<std::string> m_vec;
    read_mounts(m_vec);

    beginResetModel();
    
    m_list->items().clear();
    StorageItem stor_item;
    for (auto &mp : m_vec) {
        stor_item.name = QString(mp.c_str());
        auto si = boost::filesystem::space(mp);
        stor_item.used = (si.capacity - si.free) GB;
        stor_item.capacity = si.capacity GB;

        m_list->items().append(stor_item);
    }
    
    endResetModel();
}
