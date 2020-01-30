#include <boost/throw_exception.hpp>

#include "backend.h"

#define BOOST_NO_EXCEPTIONS
void boost::throw_exception(std::exception const & e){
//do nothing
}

void
Backend::sample() {
    if (!initialize())
        abort();
    
    // CPU samples
    sample_cpu_temp();
    sample_cpu_usage();
    sample_cpu_freq();
    sample_cpu_fan();
    
    // GPU samples
    sample_gpu_temp();
    sample_gpu_usage();
    sample_gpu_freq();
    sample_gpu_fan();
    
    // RAM Samples
    sample_ram_usage();
}
