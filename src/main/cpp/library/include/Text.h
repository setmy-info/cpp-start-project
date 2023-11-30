#ifndef SET_MY_INFO_TEXT_H
#define SET_MY_INFO_TEXT_H

#include <string>
#include <vector>

namespace set_my_info::text::operations {

    const std::string k_comma_string = ",";
    const std::string k_empty_string = "";

    std::string ToString(const char *str);

    std::string ToLowerCase(const std::string &str);

    std::string ToUpperCase(const std::string &str);

    std::string RemoveAllWhitespace(const std::string &text);

    std::string Trim(const std::string &str);

    std::vector<std::string> SplitAndTrim(const std::string &text, const std::string &delimiter = k_comma_string);

    std::vector<std::string> TrimList(const std::vector<std::string> &stringsList);

    bool ToBoolean(const std::string &text, bool defaultValue = false);

    short ToShort(const std::string &text, short defaultValue = 0);

    signed short ToSignedShort(const std::string &text, signed short defaultValue = 0);

    unsigned short ToUnsignedShort(const std::string &text, unsigned short defaultValue = 0);
}

#endif //SET_MY_INFO_TEXT_H
