#include "Text.h"

#include <string>
#include <vector>
#include <algorithm>
#include <stdexcept>
#include <sstream>
#include <limits>

using namespace std;

namespace set_my_info::text::operations {

    string ToString(const char *str) {
        if (str == 0) {
            return "";
        }
        string result = str;
        return result;
    }

    string ToLowerCase(const string &text) {
        std::string result;
        result.reserve(text.size());
        for (char c: text) {
            result += std::tolower(c);
        }
        return result;
    }

    string ToUpperCase(const string &text) {
        std::string result;
        result.reserve(text.size());
        for (char c: text) {
            result += std::toupper(c);
        }
        return result;
    }

    string RemoveAllWhitespace(const string &text) {
        string result;
        result.reserve(text.size());
        for (char ch: text) {
            if (!isspace(ch)) {
                result.push_back(ch);
            }
        }
        return result;
    }

    string Trim(const string &str) {
        size_t first = str.find_first_not_of(" \t\n\r");
        size_t last = str.find_last_not_of(" \t\n\r");
        return (first != string::npos && last != string::npos) ? str.substr(first, last - first + 1) : "";
    }

    vector <string> SplitAndTrim(const string &text, const string &delimiter) {
        vector<string> result;
        size_t start = 0, end;
        while ((end = text.find(delimiter, start)) != string::npos) {
            string token = text.substr(start, end - start);
            result.push_back(Trim(token));
            start = end + delimiter.length();
        }
        string lastToken = text.substr(start);
        result.push_back(Trim(lastToken));
        return result;
    }

    vector <string> TrimList(const vector <string> &stringsList) {
        vector<string> trimmedList;
        trimmedList.reserve(stringsList.size());
        transform(stringsList.begin(), stringsList.end(), back_inserter(trimmedList), Trim);
        return trimmedList;
    }

    bool ToBoolean(const string &text, bool defaultValue) {
        if (text.empty()) {
            return defaultValue;
        }
        const string lowerText = ToLowerCase(text);
        if (lowerText == "false" || lowerText == "no") {
            return false;
        } else if (lowerText == "true" || lowerText == "yes") {
            return true;
        } else {
            throw invalid_argument("Invalid boolean value");
        }
    }

    short ToShort(const std::string &text, short defaultValue) {
        return ToSignedShort(text, defaultValue);
    }

    signed short ToSignedShort(const string &text, signed short defaultValue) {
        if (text.empty()) {
            return defaultValue;
        }
        const string modifiedText = RemoveAllWhitespace(text);
        if (modifiedText.empty()) {
            return defaultValue;
        }
        istringstream iss(modifiedText);
        signed short result;
        iss >> result;
        if (iss.fail() || !iss.eof()) {
            throw invalid_argument("Invalid short value");
        }
        return result;
    }

    unsigned short ToUnsignedShort(const string &text, unsigned short defaultValue) {
        if (text.empty()) {
            return defaultValue;
        }
        const string modifiedText = RemoveAllWhitespace(text);
        if (modifiedText.empty()) {
            return defaultValue;
        }
        size_t pos;
        unsigned long result = std::stoul(modifiedText, &pos);
        if (pos != modifiedText.length()) {
            throw std::invalid_argument("Invalid unsigned short value");
        }
        if (result > std::numeric_limits<unsigned short>::max()) {
            throw std::out_of_range("Value out of range for unsigned short");
        }
        return static_cast<unsigned short>(result);
    }
}
