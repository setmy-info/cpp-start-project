#ifndef SET_MY_INFO_COMMANDLINE_PARAMETERS_H
#define SET_MY_INFO_COMMANDLINE_PARAMETERS_H

#include <string>
#include <vector>
#include <unordered_map>

namespace set_my_info {

    using CommandLineParametersMap = std::unordered_map<std::string, std::vector<std::string>>;

    class CommandLineParameters {
    public:
        std::string command_name_;
        std::vector<std::string> parameters_;
        CommandLineParametersMap parameters_map_;

        void Args(const int argc, const char *argv[]);
    };
}
#endif //SET_MY_INFO_COMMANDLINE_PARAMETERS_H
