#include <iostream>
#include <vector>

#include <boost/filesystem.hpp>
#include <boost/algorithm/string.hpp>

#include <proc/sysinfo.h>

#include "backend.h"

const std::string ProcMounts = "/proc/mounts";

#define GB / (1024 * 1024 * 1024)

void
Backend::sample_ram_usage() {
    meminfo();
    m_ram_usage = (int)((float)kb_main_used / (float)kb_main_total * 100); 
    
    emit ram_usage_changed();
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
Backend::sample_mount_usage() {
    std::vector<std::string> m_vec;
    read_mounts(m_vec);
    
    // TODO: This needs to become dynamic in the QML.
    m_mount_one = QString(m_vec[0].c_str());
    auto si = boost::filesystem::space(m_vec[0]);
    m_mount_one_capacity = si.capacity GB;
    m_mount_one_used = (si.capacity - si.free) GB;
    
    m_mount_two = QString(m_vec[1].c_str());
    si = boost::filesystem::space(m_vec[1]);
    m_mount_two_capacity = si.capacity GB;
    m_mount_two_used = (si.capacity - si.free) GB;
   
    emit mount_points_changed();
}
