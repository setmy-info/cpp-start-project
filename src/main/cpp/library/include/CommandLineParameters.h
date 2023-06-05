#ifndef SET_MY_INFO_COMMANDLINE_PARAMETERS_H
#define SET_MY_INFO_COMMANDLINE_PARAMETERS_H

#include <string>
#include <vector>

namespace SetMyInfo {

    class CommandLineParameters {
    public:
        CommandLineParameters();
        virtual ~CommandLineParameters();
        void Init();
    };

}
#endif //SET_MY_INFO_COMMANDLINE_PARAMETERS_H
