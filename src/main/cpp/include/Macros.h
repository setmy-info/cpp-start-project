#ifndef SET_MY_INFO_MACROS_H
#define SET_MY_INFO_MACROS_H

namespace set_my_info {

/**
 * const char *arguments[] = {"programName", "abc", "def=ghi", "jkl=mno=prs", 0};
 * size_t arraySize = ARRAY_SIZE(arguments);
 **/
#define ARRAY_SIZEOF(arr) (sizeof(arr) / sizeof((arr)[0]))

}

#endif //SET_MY_INFO_MACROS_H
