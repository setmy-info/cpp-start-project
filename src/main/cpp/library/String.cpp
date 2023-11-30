#include "String.h"

#include <string>
#include <vector>

namespace set_my_info::string::operations {

    std::string Trim(const std::string &str) {
        size_t first = str.find_first_not_of(" \t\n\r");
        size_t last = str.find_last_not_of(" \t\n\r");
        return (first != std::string::npos && last != std::string::npos) ? str.substr(first, last - first + 1) : "";
    }

    std::vector<std::string> SplitAndTrim(const std::string &text, const std::string &delimiter) {
        std::vector<std::string> result;
        size_t start = 0, end;
        while ((end = text.find(delimiter, start)) != std::string::npos) {
            std::string token = text.substr(start, end - start);
            result.push_back(Trim(token));
            start = end + delimiter.length();
        }
        std::string lastToken = text.substr(start);
        result.push_back(Trim(lastToken));
        return result;
    }
}
