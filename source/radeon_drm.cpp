#include <cstring>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/ioctl.h>


#include "common.h"
#include "radeon_drm.h"

bool
RadeonDRM::initialize() {
    if (m_initialized) return true;

    m_initialized = find_drm();

    return m_initialized;
}

void
RadeonDRM::cleanup() {
    amdgpu_device_deinitialize(m_amdgpu_dev);
    m_initialized = false;
}

uint32_t
RadeonDRM::read_amdgpu_sensor(uint32_t sensor, void *out, size_t size) {
    return amdgpu_query_sensor_info(m_amdgpu_dev, sensor, size, out);
}

void
RadeonDRM::authenticate_drm() {
    drm_magic_t magic;

    if (drmGetMagic(m_drm_fd, &magic) == 0) return;

    if (drmAuthMagic(m_drm_fd, magic) == 0) {
        if (drmDropMaster(m_drm_fd)) {
            kam_error("Failed to drop DRM master");
        }
    }

    return;
}

bool
RadeonDRM::init_drm(const char *path) {
    m_drm_fd = open(path, O_RDWR);

    if (m_drm_fd < 0) {
        kam_error(std::string("Failed to open") + path);
        return false;
    }

    drmVersionPtr ver = drmGetVersion(m_drm_fd);

    if (!ver) {
        close(m_drm_fd);
        kam_error("Failed to query DRM driver version");
        return false;
    }

    authenticate_drm();

    uint32_t drm_major, drm_minor;
    if (!strcmp(ver->name, "amdgpu")) {
        if (amdgpu_device_initialize(m_drm_fd, &drm_major, &drm_minor, &m_amdgpu_dev)) {
            kam_error("Failed to initialize amdgpu");
            return false;
        }

        struct amdgpu_gpu_info gpu;

        amdgpu_query_gpu_info(m_amdgpu_dev, &gpu);
        sclk_max = gpu.max_engine_clk / 1000;
        mclk_max = gpu.max_memory_clk / 1000;

        m_gpu_name = amdgpu_get_marketing_name(m_amdgpu_dev);
    }
    else {
        kam_error(std::string("Unsupported GPU driver: ") + ver->name);
        m_drm_fd = -1;
    }

    drmFreeVersion(ver);
    return true;
}

bool
RadeonDRM::find_drm() {
    drmDevicePtr *devs = nullptr;
    int32_t count;

    if (m_drm_fd >= 0)
        close(m_drm_fd);

    count = DRMGETDEVICES(NULL, 0);

    if (count <= 0) {
       kam_error("An error occurred or no DRM devices were found", true);
       return false;
    }

    if (!(devs = (drmDevicePtr *)calloc(count, sizeof(drmDevicePtr)))) {
        kam_error("Failed to allocate memory for DRM devices", true);
       return false;
    }

    if ((count = DRMGETDEVICES(devs, count)) < 0) {
        kam_error("Failed to enumerate DRM devices", true);
        free(devs);
       return false;
    }

    int32_t i;
    for (i = 0; i < count; i++) {
        if (devs[i]->bustype != DRM_BUS_PCI ||						// Not a PCI bus or...
            devs[i]->deviceinfo.pci->vendor_id != VENDOR_AMD ||		// Not an AMD device or...
            (m_bus >= 0 && m_bus != devs[i]->businfo.pci->bus))		// Doesn't match the bus that was passed in
            continue;

        int32_t j;
        for (j = DRM_NODE_MAX - 1; j >= 0; j--) {
            if (!(1 << j & devs[i]->available_nodes))
                continue;
            if (!(init_drm(devs[i]->nodes[j])))
                continue;

            m_device_bus = devs[i]->businfo.pci->bus;
            m_device_id = devs[i]->deviceinfo.pci->device_id;
            break;
        }
    }

    drmFreeDevices(devs, count);
    free(devs);

    return (m_drm_fd >= 0);
}

