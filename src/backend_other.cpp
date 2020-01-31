#include <iostream>
#include <vector>

#include <proc/sysinfo.h>

#include "backend.h"

void
Backend::sample_ram_usage() {
    meminfo();
    m_ram_usage = (int)((float)kb_main_used / (float)kb_main_total * 100); 
    
    emit ram_usage_changed();
}



