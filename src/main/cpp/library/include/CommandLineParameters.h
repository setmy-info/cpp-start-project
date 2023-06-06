#ifndef SET_MY_INFO_COMMANDLINE_PARAMETERS_H
#define SET_MY_INFO_COMMANDLINE_PARAMETERS_H

#include <string>
#include <vector>
#include <unordered_map>

namespace SetMyInfo {

    class CommandLineParameters {
    public:
        std::string commandName;
        std::vector<std::string> parameters;

        void Args(const int argc, const char *argv[]);
    };
}
#endif //SET_MY_INFO_COMMANDLINE_PARAMETERS_H
