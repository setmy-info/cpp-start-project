#ifndef SET_MY_INFO_VERSION_H
#define SET_MY_INFO_VERSION_H

// The version of the project. It is not written here: CMakeLists.txt defines
// PROJECT_MODULE_VERSION_MAJOR, _MINOR, _PATCH, _TWEAK and _STRING for every compilation, from its
// PROJECT_VERSION_* settings, so the version exists in one place and no header is generated.

#ifndef PROJECT_MODULE_VERSION_STRING
#error "PROJECT_MODULE_VERSION_STRING is defined by the build, see CMakeLists.txt"
#endif

#endif // SET_MY_INFO_VERSION_H
