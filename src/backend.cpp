#include <thread>
#include <random>
#include <iostream>

#include "backend.h"

void
Backend::sample() {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(0, 100);
    
    std::lock_guard<std::mutex> lock(m_mx);
    m_cpuUsage = dis(gen);
}
