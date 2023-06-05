#include "Application.h"

namespace SetMyInfo {

    int Application::Args(int argc, char *argv[]) {
        this->commandName = argv[0];
        for (int i = 1; i < argc; i++) {
            std::string tmp = argv[i];
            this->commandLineParameters.parameters.push_back(tmp);
        }
        return this->Main();
    }

    int Application::Main() {
        return 0;
    }
}
