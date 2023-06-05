#ifndef SET_MY_INFO_APPLICATION_H
#define	SET_MY_INFO_APPLICATION_H

#include "EnvironmentVariables.h"
#include "CommandLineParameters.h"

#include <string>
#include <vector>

namespace SetMyInfo {

    class Application {
        EnvironmentVariables environmentVariables;
        CommandLineParameters commandLineParameters;
    public:
        std::string commandName;

        int Args(int argc, char *argv[]);
        virtual int Main();

    private:

    };
}
#endif // SET_MY_INFO_APPLICATION_H
