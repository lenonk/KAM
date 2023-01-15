/*
    SPDX-FileCopyrightText: 2022 Lenon Kitchens <lenon.kitchens@gmail.com>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#include "amdgpu.h"

#include <algorithm>
#include <charconv>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>

#include <QDebug>
#include <QProcess>
#include <QStandardPaths>

#include <KLocalizedString>
#include <KPluginFactory>

#include <processcore/process.h>
#include <unistd.h>

const std::string procPath{"/proc"};
const std::string fdinfoPath{"/fdinfo"};
const std::string driver_prefix{"drm-driver"};
const std::string gfx_prefix{"drm-engine-gfx"};
const std::string mem_prefix{"drm-memory-vram"};

using namespace KSysGuard;
namespace fs = std::filesystem;

static inline void ltrim(std::string &s)
{
    s.erase(s.begin(), std::find_if(s.begin(), s.end(), [](unsigned char ch) {
                return !std::isspace(ch);
            }));
}

static inline void rtrim(std::string &s)
{
    s.erase(std::find_if(s.rbegin(),
                         s.rend(),
                         [](unsigned char ch) {
                             return !std::isspace(ch);
                         })
                .base(),
            s.end());
}

static inline void trim(std::string &s)
{
    ltrim(s);
    rtrim(s);
}

static inline void tokenize(const std::string &s, std::vector<std::string> &t)
{
    std::stringstream ss(s);
    std::string temp;

    t.clear();
    while (getline(ss, temp, ':')) {
        trim(temp);
        t.push_back(temp);
    }
}

static inline int64_t difftime_u64(const timespec &curr, const timespec &prev)
{
    return static_cast<int64_t>(curr.tv_sec - prev.tv_sec) * 1e9 + static_cast<int64_t>(curr.tv_nsec) - static_cast<int64_t>(prev.tv_nsec);
}

static inline float calc_gpu_usage(uint64_t curr, uint64_t prev, uint64_t diff)
{
    if (curr <= prev)
        return UINT64_C(0);

    float perc = (static_cast<float>(curr - prev) / static_cast<float>(diff)) * 100.0;

    return perc;
}

template<class T>
bool to_digits(std::string s, T &v)
{
    auto [ptr, ec]{std::from_chars(s.data(), s.data() + s.size(), v)};

    if (ec != std::errc())
        return false;

    return true;
}

AmdGpuPlugin::AmdGpuPlugin(QObject *parent, const QVariantList &args)
    : ProcessDataProvider(parent, args)
{
    m_usage = new ProcessAttribute(QStringLiteral("amdgpu_usage"), i18n("GPU Usage"), this);
    m_usage->setUnit(KSysGuard::UnitPercent);
    m_memory = new ProcessAttribute(QStringLiteral("amdgpu_memory"), i18n("GPU Memory"), this);
    m_memory->setUnit(KSysGuard::UnitKiloByte);

    addProcessAttribute(m_usage);
    addProcessAttribute(m_memory);
}

void AmdGpuPlugin::handleEnabledChanged(bool enabled)
{
    m_enabled = enabled;
}

bool AmdGpuPlugin::processPidEntry(const std::string &path, AmdGpuFd &proc)
{
    std::fstream f(path, std::fstream::in);
    if (!f.is_open())
        return false;

    std::string line;
    std::vector<std::string> tokens;

    proc.gfx = 0;
    proc.vram = 0;

    while (getline(f, line)) {
        if (!line.compare(0, driver_prefix.size(), driver_prefix)) {
            tokenize(line, tokens);
            if (tokens[1] != "amdgpu")
                break;
        } else if (!line.compare(0, gfx_prefix.size(), gfx_prefix)) {
            tokenize(line, tokens);
            if (!to_digits(tokens[1], proc.gfx))
                break;
        } else if (!line.compare(0, mem_prefix.size(), mem_prefix)) {
            tokenize(line, tokens);
            if (!to_digits(tokens[1], proc.vram))
                break;
        }
    }

    f.close();

    return (proc.gfx != 0) && (proc.vram != 0);
}

void AmdGpuPlugin::processPidDir(pid_t pid, const std::string &path, const KSysGuard::Process *proc)
{
    std::string fdinfo_dir{path + fdinfoPath};

    std::vector<AmdGpuFd> gpu_fds;

    std::error_code ec;
    for (const auto &fdinfo : fs::directory_iterator(fdinfo_dir, ec)) {
        if (ec != std::errc())
            continue;

        AmdGpuFd gpu_fd{pid, 0, 0};
        if (!processPidEntry(fdinfo.path(), gpu_fd))
            continue;
        gpu_fds.push_back(gpu_fd);
    }

    // Take the largest of all the values that we found.
    AmdGpuFd fd_totals{pid, 0, 0};
    for (auto &fd : gpu_fds) {
        if (fd.gfx > fd_totals.gfx)
            fd_totals.gfx = fd.gfx;
        if (fd.vram > fd_totals.vram)
            fd_totals.vram = fd.vram;
    }

    // FIXME: It's possible that it's necessary to aggregate gfx engine usage from child processes.
    // This seems to work ok currently though.

    timespec_get(&fd_totals.ts, TIME_UTC);

    float percent = 0;
    if (m_process_cache.find(pid) != m_process_cache.end()) {
        auto prev = m_process_cache[pid];
        percent = calc_gpu_usage(fd_totals.gfx, prev.gfx, difftime_u64(fd_totals.ts, prev.ts));
    }

    m_process_cache[pid] = fd_totals;
    m_memory->setData(const_cast<KSysGuard::Process *>(proc), fd_totals.vram);
    m_usage->setData(const_cast<KSysGuard::Process *>(proc), percent);
}

/*
    For each pid entry in proc, scan the fdinfo directory for entries containing both
    drm-driver: amdgpu and drm-engine-gfx: <999999999> ns.  When found, determine the
    elapsed ns since the last reading and compute a GPU usage percentage from there.
    Be care of multiple entries in fdinfo matching the criteria.
*/
void AmdGpuPlugin::update()
{
    if (!m_enabled)
        return;

    std::error_code ec;
    for (const auto &entry : fs::directory_iterator(procPath, ec)) {
        if (ec != std::errc())
            continue;

        std::string fname{entry.path().filename()};

        if (!std::all_of(fname.begin(), fname.end(), ::isdigit))
            continue;

        pid_t pid;
        if (!to_digits(fname, pid))
            continue;

        KSysGuard::Process *proc = getProcess(pid);
        if (!proc)
            continue;

        processPidDir(pid, entry.path(), proc);
    }
}

K_PLUGIN_FACTORY_WITH_JSON(PluginFactory, "amdgpu.json", registerPlugin<AmdGpuPlugin>();)

#include "amdgpu.moc"
