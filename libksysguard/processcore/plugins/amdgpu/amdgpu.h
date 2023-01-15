/*
    SPDX-FileCopyrightText: 2022 Lenon Kitchens <lenon.kitchens@gmail.com>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#pragma once

#include <map>
#include <vector>

#include <processcore/process_attribute.h>
#include <processcore/process_data_provider.h>

struct AmdGpuFd {
    pid_t pid{0};
    uint64_t gfx{0};
    uint32_t vram{0};
    timespec ts{0, 0};
};

class AmdGpuPlugin : public KSysGuard::ProcessDataProvider
{
    Q_OBJECT
public:
    AmdGpuPlugin(QObject *parent, const QVariantList &args);
    void handleEnabledChanged(bool enabled) override;
    void update() override;

private:
    KSysGuard::ProcessAttribute *m_usage = nullptr;
    KSysGuard::ProcessAttribute *m_memory = nullptr;

    bool m_enabled{false};
    std::map<pid_t, AmdGpuFd> m_process_cache;

    void processPidDir(pid_t p, const std::string &path, const KSysGuard::Process *proc);
    bool processPidEntry(const std::string &path, AmdGpuFd &proc);
};
