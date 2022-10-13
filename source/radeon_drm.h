#ifndef RADEON_DRM_H
#define RADEON_DRM_H

#include <cstdint>

#include <xf86drm.h>
#include <libdrm/amdgpu_drm.h>
#include <libdrm/amdgpu.h>

#define DRMGETDEVICE(fd, dev) drmGetDevice2(fd, 0, dev)
#define DRMGETDEVICES(dev, max) drmGetDevices2(0, dev, max)

static const int16_t VENDOR_AMD = 0x1002;

class RadeonDRM
{
    public:
        RadeonDRM(int16_t bus = -1) : m_bus(bus) {};
        ~RadeonDRM() {};

        uint64_t sclk_max { 0 };
        uint64_t mclk_max { 0 };

        // Public Methods
        bool initialize();
        bool find_drm();
        /*uint32_t radeon_get_sclk(uint32_t *out);
        uint32_t radeon_get_usage(uint32_t *out);*/
        uint32_t read_amdgpu_sensor(uint32_t sensor, uint32_t *out);

    private:
        bool m_initialized { false };

        int16_t m_bus { -1 };
        int16_t m_device_bus { 0 };
        uint32_t m_device_id { 0 };
        int32_t m_drm_fd { -1 };

        amdgpu_device_handle m_amdgpu_dev { nullptr };

        // Private methods
        bool init_drm(const char *path);
        void authenticate_drm();
};

#endif // RADEON_DRM_H
