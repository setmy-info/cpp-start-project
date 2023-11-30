#ifndef SET_MY_INFO_ENVIRONMENT_VARIABLES_H
#define SET_MY_INFO_ENVIRONMENT_VARIABLES_H

#include <optional>
#include <string>
#include <vector>

namespace set_my_info {

    class EnvironmentVariables {
    public:
        static EnvironmentVariables &GetInstance();

        std::optional<std::string> GetEnv(const std::string &env_name);

        std::optional<std::string> GetEnv(const char *env_name);

    private:
        EnvironmentVariables() = default;

        ~EnvironmentVariables() = default;

        // Restricted copy and setting in singletone pattern
        EnvironmentVariables(const EnvironmentVariables &) = delete;

        // Restricted setting in singletone pattern
        EnvironmentVariables &operator=(const EnvironmentVariables &) = delete;
    };

}
#endif //SET_MY_INFO_ENVIRONMENT_VARIABLES_H
