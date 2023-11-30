#include "CommandLineParameters.h"

#include <string>
#include <sstream>

namespace set_my_info {

    void CommandLineParameters::Args(const int argc, const char *argv[]) {
        this->command_name = argv[0];
        for (int i = 1; i < argc; i++) {
            std::string tmp = argv[i];
            this->parameters.push_back(tmp);
        }

        for (const auto& parameter: this->parameters) {
            std::istringstream iss(parameter);
            std::string option;
            std::getline(iss, option, '=');

            std::string value;
            while (std::getline(iss, value, '=')) {
                parameters_map[option].push_back(value);
            }

            parameters_map[option];
        }
    }
}
