#include "EnvironmentVariables.h"

#include <cstdlib>

#include <optional>
#include <string>

using std::string;
using std::optional;
using std::nullopt;
using std::getenv;

namespace set_my_info {

    EnvironmentVariables &EnvironmentVariables::GetInstance() {
        static EnvironmentVariables instance;
        return instance;
    }

    optional <string> EnvironmentVariables::GetEnv(const std::string &env_name) {
        return this->GetEnv(env_name.c_str());
    }

    optional <string> EnvironmentVariables::GetEnv(const char *env_name) {
        if (env_name == 0) {
            return nullopt;
        }
        const char *value = getenv(env_name);
        if (value == 0) {
            return nullopt;
        }
        return string(value);
    }
}
