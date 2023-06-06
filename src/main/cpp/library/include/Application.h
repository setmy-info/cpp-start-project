#ifndef SET_MY_INFO_APPLICATION_H
#define    SET_MY_INFO_APPLICATION_H

#include "EnvironmentVariables.h"
#include "CommandLineParameters.h"

#include <string>
#include <vector>

namespace SetMyInfo {

    class Application {
        EnvironmentVariables environmentVariables;
        CommandLineParameters commandLineParameters;
    public:
        void Args(const int argc, const char *argv[]);

        virtual int Main();
    };
}
#endif // SET_MY_INFO_APPLICATION_H
