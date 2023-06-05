#ifndef SET_MY_INFO_ENVIRONMENT_VARIABLES_H
#define SET_MY_INFO_ENVIRONMENT_VARIABLES_H

#include <optional>
#include <string>
#include <vector>

namespace SetMyInfo {

    class EnvironmentVariables {
    public:
        static EnvironmentVariables& getInstance();
        std::optional<std::string> GetEnv(const std::string &env_name);
        std::optional<std::string> GetEnv(const char *env_name);
    };

}
#endif //SET_MY_INFO_ENVIRONMENT_VARIABLES_H
