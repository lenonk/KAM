#include <iostream>
#include <ostream>
#include <string>

#include "common.h"

void
kam_error(std::string err, bool die) {
    std::cerr << err << std::endl;

    if (die) abort();
}

