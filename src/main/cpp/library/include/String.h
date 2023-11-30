#ifndef SET_MY_INFO_STRING_H
#define SET_MY_INFO_STRING_H

#include <string>
#include <vector>

namespace set_my_info::string::operations {

    const std::string k_comma_string = ",";
    const std::string k_empty_string = "";

    std::string Trim(const std::string &str);

    std::vector<std::string> SplitAndTrim(const std::string &text, const std::string &delimiter = k_comma_string);
}

#endif //SET_MY_INFO_STRING_H
