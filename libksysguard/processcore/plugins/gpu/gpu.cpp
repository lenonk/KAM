/*
    SPDX-FileCopyrightText: 2022 Lenon Kitchens <lenon.kitchens@gmail.com>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#include "gpu.h"

#include <algorithm>
#include <charconv>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>

#include <QDebug>
#include <QFile>
#include <QProcess>
#include <QStandardPaths>

#include <KLocalizedString>
#include <KPluginFactory>

#include <processcore/process.h>
#include <sys/stat.h>
#include <sys/sysmacros.h>
#include <unistd.h>

const fs::path procPath{"/proc"};
const fs::path fdinfoPath{"/fdinfo"};
const fs::path fdPath{"/fd"};

const QByteArray driver_prefix{"drm-driver"};
const QByteArray gfx_prefix{"drm-engine-gfx"};
const QByteArray mem_prefix{"drm-memory-vram"};
const QByteArray amd_drm_driver{"amdgpu"};

const int32_t drm_node_type = 226;

template<class T>
static inline bool to_digits(const std::string s, T &v)
{
    auto [ptr, ec]{std::from_chars(s.data(), s.data() + s.size(), v)};

    if (ec != std::errc()) {
        return false;
    }

    return true;
}

static inline float calc_gpu_usage(uint64_t curr, uint64_t prev, std::chrono::high_resolution_clock::duration diff)
{
    if (curr <= prev) {
        return 0.0F;
    }

    float perc = (static_cast<float>(curr - prev) / static_cast<float>(diff.count())) * 100.0F;

    return perc;
}

GpuPlugin::GpuPlugin(QObject *parent, const QVariantList &args)
    : ProcessDataProvider(parent, args)
{
    m_usage = new KSysGuard::ProcessAttribute(QStringLiteral("amdgpu_usage"), i18n("GPU Usage"), this);
    m_usage->setUnit(KSysGuard::UnitPercent);
    m_memory = new KSysGuard::ProcessAttribute(QStringLiteral("amdgpu_memory"), i18n("GPU Memory"), this);
    m_memory->setUnit(KSysGuard::UnitKiloByte);

    addProcessAttribute(m_usage);
    addProcessAttribute(m_memory);
}

void GpuPlugin::handleEnabledChanged(bool enabled)
{
    m_enabled = enabled;
}

bool GpuPlugin::fileRefersToDrmNode(const fs::path &path, const std::string &fname)
{
    std::string fd_path{path.string() + fdPath.string() + "/" + fname};

    struct stat sbuf;
    if (stat(fd_path.c_str(), &sbuf) != 0) {
        return false;
    }

    if ((sbuf.st_mode & S_IFCHR) == 0) {
        return false;
    }

    return (major(sbuf.st_rdev) == drm_node_type);
}

bool GpuPlugin::processPidEntry(const fs::path &path, GpuFd &proc)
{
    QFile f{path.string().c_str()};

    if (!f.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return false;
    }

    proc.gfx = 0;
    proc.vram = 0;

    // Had to use a do/while loop here because f.atEnd() was returning 1
    // until the first f.readLine()
    do {
        QByteArray line{f.readLine()};

        QList<QByteArray> tokens{line.split(':')};

        if (tokens.size() < 2) {
            continue;
        };

        if (line.startsWith(driver_prefix)) {
            if (tokens[1].trimmed() != amd_drm_driver) {
                break;
            };
        } else if (line.startsWith(gfx_prefix)) {
            if (!to_digits(tokens[1].trimmed().toStdString(), proc.gfx)) {
                continue;
            };
        } else if (line.startsWith(mem_prefix)) {
            if (!to_digits(tokens[1].trimmed().toStdString(), proc.vram)) {
                continue;
            };
        }
    } while (!f.atEnd());

    f.close();

    return (proc.gfx != 0) && (proc.vram != 0);
}

void GpuPlugin::processPidDir(const pid_t pid, const fs::path &path, KSysGuard::Process *proc)
{
    std::string fdinfo_dir{path.string() + fdinfoPath.string()};

    std::vector<GpuFd> gpu_fds;

    std::error_code ec;
    for (const auto &fdinfo : fs::directory_iterator(fdinfo_dir, ec)) {
        if (ec != std::errc()) {
            continue;
        }

        if (fileRefersToDrmNode(path, fdinfo.path().filename().string())) {
            GpuFd gpu_fd{pid};
            if (!processPidEntry(fdinfo.path(), gpu_fd)) {
                continue;
            }
            gpu_fds.push_back(gpu_fd);
        }
    }

    // Take the largest of all the values that we found.
    GpuFd fd_totals{pid};
    for (auto &fd : gpu_fds) {
        if (fd.gfx > fd_totals.gfx) {
            fd_totals.gfx = fd.gfx;
        }
        if (fd.vram > fd_totals.vram) {
            fd_totals.vram = fd.vram;
        }
    }

    // FIXME: It's possible that it's necessary to aggregate gfx engine usage from child processes.
    // This seems to work ok currently though.

    float percent = 0;
    if (m_process_history.find(pid) != m_process_history.end()) {
        auto prev = m_process_history[pid];
        percent = calc_gpu_usage(fd_totals.gfx, prev.gfx, fd_totals.ts - prev.ts);
    }

    m_process_history[pid] = fd_totals;
    m_memory->setData(proc, fd_totals.vram);
    m_usage->setData(proc, percent);
}

/*
    For each pid entry in proc, scan the fdinfo directory for entries containing both
    drm-driver: amdgpu and drm-engine-gfx: <999999999> ns.  When found, determine the
    elapsed ns since the last reading and compute a GPU usage percentage from there.
    Be care of multiple entries in fdinfo matching the criteria.
*/
void GpuPlugin::update()
{
    if (!m_enabled) {
        return;
    }

    std::error_code ec;
    for (const auto &entry : fs::directory_iterator(procPath, ec)) {
        if (ec != std::errc()) {
            continue;
        }

        QByteArray fname{entry.path().filename().c_str()};

        if (!std::all_of(fname.begin(), fname.end(), ::isdigit)) {
            continue;
        }

        pid_t pid{fname.toInt()};
        if (!pid) {
            continue;
        }

        KSysGuard::Process *proc = getProcess(pid);
        if (!proc) {
            continue;
        }

        processPidDir(pid, entry.path(), proc);
    }
}

K_PLUGIN_FACTORY_WITH_JSON(PluginFactory, "gpu.json", registerPlugin<GpuPlugin>();)

#include "gpu.moc"
