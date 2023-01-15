#ifndef PROCESSORS_H
#define PROCESSORS_H

#include <map>
#include <string>

struct Processor {
    std::string code_name { "" };
    std::string socket { "" };
    uint32_t tdp {0};
};

std::map<std::string, Processor> ProcessorInfo {
    // ************************* Intel **************************//
    // ********************** Raptor Lake ***********************//
    // i9
    std::pair<std::string, Processor>("13900K", {"Raptor Lake", "LGA1700", 125}),
    std::pair<std::string, Processor>("13900KF", {"Raptor Lake", "LGA1700", 125}),
    // i7
    std::pair<std::string, Processor>("13700K", {"Raptor Lake", "LGA1700", 125}),
    std::pair<std::string, Processor>("13700KF", {"Raptor Lake", "LGA1700", 125}),
    //i5
    std::pair<std::string, Processor>("13600K", {"Raptor Lake", "LGA1700", 125}),
    std::pair<std::string, Processor>("13600KF", {"Raptor Lake", "LGA1700", 125}),

    // ********************** Alder Lake ***********************//
    // i9
    std::pair<std::string, Processor>("12900K", {"Alder Lake", "LGA1700", 125}),
    std::pair<std::string, Processor>("12900KF", {"Alder Lake", "LGA1700", 125}),
    std::pair<std::string, Processor>("12900KS", {"Alder Lake", "LGA1700", 150}),
    std::pair<std::string, Processor>("12900", {"Alder Lake", "LGA1700", 65}),
    std::pair<std::string, Processor>("12900F", {"Alder Lake", "LGA1700", 65}),
    std::pair<std::string, Processor>("12900T", {"Alder Lake", "LGA1700", 35}),
    // Mobile i9
    std::pair<std::string, Processor>("12900HK", {"Alder Lake", "LGA1700", 45}),
    std::pair<std::string, Processor>("12900H", {"Alder Lake", "LGA1700", 45}),
    //i7
    std::pair<std::string, Processor>("12700K", {"Alder Lake", "LGA1700", 125}),
    std::pair<std::string, Processor>("12700KF", {"Alder Lake", "LGA1700", 125}),
    std::pair<std::string, Processor>("12700", {"Alder Lake", "LGA1700", 65}),
    std::pair<std::string, Processor>("12700F", {"Alder Lake", "LGA1700", 65}),
    std::pair<std::string, Processor>("12700T", {"Alder Lake", "LGA1700", 35}),
    // Mobile i7
    std::pair<std::string, Processor>("12800H", {"Alder Lake", "FCBGA1744", 45}),
    std::pair<std::string, Processor>("12700H", {"Alder Lake", "FCBGA1744", 45}),
    std::pair<std::string, Processor>("12650H", {"Alder Lake", "FCBGA1744", 45}),
    std::pair<std::string, Processor>("1280P", {"Alder Lake", "FCBGA1744", 28}),
    std::pair<std::string, Processor>("1270P", {"Alder Lake", "BGA1700", 28}),
    std::pair<std::string, Processor>("1265U", {"Alder Lake", "FCBGA1744", 15}),
    std::pair<std::string, Processor>("1260U", {"Alder Lake", "BGA1700", 9}),
    std::pair<std::string, Processor>("1260P", {"Alder Lake", "FCBGA1744", 28}),
    std::pair<std::string, Processor>("1255U", {"Alder Lake", "BGA1700", 15}),
    std::pair<std::string, Processor>("1250U", {"Alder Lake", "BGA1700", 9}),

    //i5
    std::pair<std::string, Processor>("12600K", {"Alder Lake", "LGA1700", 125}),
    std::pair<std::string, Processor>("12600KF", {"Alder Lake", "LGA1700", 125}),
    std::pair<std::string, Processor>("12600", {"Alder Lake", "LGA1700", 65}),
    std::pair<std::string, Processor>("12600T", {"Alder Lake", "LGA1700", 35}),
    std::pair<std::string, Processor>("12500", {"Alder Lake", "LGA1700", 65}),
    std::pair<std::string, Processor>("12600T", {"Alder Lake", "LGA1700", 35}),
    std::pair<std::string, Processor>("12400", {"Alder Lake", "LGA1700", 65}),
    std::pair<std::string, Processor>("12600F", {"Alder Lake", "LGA1700", 65}),
    std::pair<std::string, Processor>("12600T", {"Alder Lake", "LGA1700", 35}),
    //i3
    std::pair<std::string, Processor>("12300", {"Alder Lake", "LGA1700", 60}),
    std::pair<std::string, Processor>("12300T", {"Alder Lake", "LGA1700", 35}),
    std::pair<std::string, Processor>("12100", {"Alder Lake", "LGA1700", 60}),
    std::pair<std::string, Processor>("12100F", {"Alder Lake", "LGA1700", 60}),
    std::pair<std::string, Processor>("12100T", {"Alder Lake", "LGA1700", 35}),

    // ************************** AMD ***************************//
    // ************************ Vermeer *************************//
    // Ryzen 5
    std::pair<std::string, Processor>("Ryzen 5 5500", {"Vermeer", "AM4", 65}),
    std::pair<std::string, Processor>("Ryzen 5 5600", {"Vermeer", "AM4", 65}),
    std::pair<std::string, Processor>("Ryzen 5 5600X", {"Vermeer", "AM4", 65}),
    // Ryzen 7
    std::pair<std::string, Processor>("Ryzen 7 5700X", {"Vermeer", "AM4", 65}),
    std::pair<std::string, Processor>("Ryzen 7 5800", {"Vermeer", "AM4", 65}),
    std::pair<std::string, Processor>("Ryzen 7 5800X", {"Vermeer", "AM4", 105}),
    std::pair<std::string, Processor>("Ryzen 7 5800X3D", {"Vermeer", "AM4", 105}),
    // Ryzen 9
    std::pair<std::string, Processor>("Ryzen 9 5900", {"Vermeer", "AM4", 65}),
    std::pair<std::string, Processor>("Ryzen 9 5900X", {"Vermeer", "AM4", 105}),
    std::pair<std::string, Processor>("Ryzen 9 5950X", {"Vermeer", "AM4", 105}),
    // Threadripper
    std::pair<std::string, Processor>("Ryzen Threadripper PRO 5945WX", {"Chagall", "sWRX8", 280}),
    std::pair<std::string, Processor>("Ryzen Threadripper PRO 5955WX", {"Chagall", "sWRX8", 280}),
    std::pair<std::string, Processor>("Ryzen Threadripper PRO 5965WX", {"Chagall", "sWRX8", 280}),
    std::pair<std::string, Processor>("Ryzen Threadripper PRO 5975WX", {"Chagall", "sWRX8", 280}),
    std::pair<std::string, Processor>("Ryzen Threadripper PRO 5995WX", {"Chagall", "sWRX8", 280}),
};
#endif // PROCESSORS_H
