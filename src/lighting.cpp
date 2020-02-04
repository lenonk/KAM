#include <iostream>
#include <ios>

#include <libusb-1.0/libusb.h>

#include "backend.h"

using namespace std;

void 
printdev(libusb_device *dev) {
    libusb_device_descriptor desc;

    int r = libusb_get_device_descriptor(dev, &desc);
    if (r < 0) {
        cout<<"failed to get device descriptor"<<endl;
        return;
    }
    
    cout<<"Number of possible configurations: "<<(int)desc.bNumConfigurations<<"\n";
    cout<<"Device Class: "<<(int)desc.bDeviceClass<<"\n";
    cout<<"VendorID: "<< hex << desc.idVendor<<"\n";
    cout<<"ProductID: "<< hex << desc.idProduct<<endl;
    
    libusb_config_descriptor *config;
    libusb_get_config_descriptor(dev, 0, &config);

    cout<<"Interfaces: "<<(int)config->bNumInterfaces<<"\n";

    const libusb_interface *inter;
    const libusb_interface_descriptor *interdesc;
    const libusb_endpoint_descriptor *epdesc;

    for(int i=0; i<(int)config->bNumInterfaces; i++) {
        inter = &config->interface[i];
        cout<<"Number of alternate settings: "<<inter->num_altsetting<<"\n";

        for(int j=0; j<inter->num_altsetting; j++) {
            interdesc = &inter->altsetting[j];
            cout<<"Interface Number: "<<(int)interdesc->bInterfaceNumber<<"\n";
            cout<<"Number of endpoints: "<<(int)interdesc->bNumEndpoints<<"\n";
            for(int k=0; k<(int)interdesc->bNumEndpoints; k++) {
                epdesc = &interdesc->endpoint[k];
                cout<<"Descriptor Type: "<<(int)epdesc->bDescriptorType<<"\n";
                cout<<"EP Address: "<<(int)epdesc->bEndpointAddress<<"\n";
            }
        }
    }
    cout<<endl<<endl<<endl;

    libusb_free_config_descriptor(config);
}

void
Backend::detect_usb_devices() {
    libusb_device **devs = nullptr;
    libusb_context *ctx = nullptr;
    
    if (libusb_init(&ctx) < 0) {
        std::cerr << "libusb init error\n";
        return;
    }
    
    int32_t cnt = 0;
    if ((cnt = libusb_get_device_list(ctx, &devs)) < 0) {
        std::cerr << "get device list error\n";
        return;
    }
    
    for (int32_t i = 0; i < cnt; i++) {
        printdev(devs[i]);
    }
    
    libusb_free_device_list(devs, 1);
    libusb_exit(ctx);
}
