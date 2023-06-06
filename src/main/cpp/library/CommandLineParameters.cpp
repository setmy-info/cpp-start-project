#include "CommandLineParameters.h"

#include <string>
#include <vector>
#include <unordered_map>
#include <sstream>

namespace SetMyInfo {

    using CommandLineParametersMap = std::unordered_map<std::string, std::vector<std::string>>;

    void CommandLineParameters::Args(const int argc, const char *argv[]) {
        this->commandName = argv[0];
        for (int i = 1; i < argc; i++) {
            std::string tmp = argv[i];
            this->parameters.push_back(tmp);
        }

        CommandLineParametersMap parameters;
        std::vector<CommandLineParametersMap> parametersList;

        for (const std::string parameter: this->parameters) {
            std::istringstream iss(parameter);
            std::string option;
            std::getline(iss, option, '=');

            std::string value;
            while (std::getline(iss, value, '=')) {
                parameters[option].push_back(value);
            }

            parameters[option].empty();
        }
    }
}
