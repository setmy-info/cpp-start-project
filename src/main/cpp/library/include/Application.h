#ifndef SET_MY_INFO_APPLICATION_H
#define SET_MY_INFO_APPLICATION_H

#include "CommandLineParameters.h"

#include <string>
#include <vector>

namespace set_my_info {

    class Application {
        CommandLineParameters command_line_parameters_;
    public:
        void Args(const int argc, const char *argv[]);

        virtual int Main();
    };
}
#endif // SET_MY_INFO_APPLICATION_H
