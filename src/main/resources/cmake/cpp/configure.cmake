# PLACEHOLDER-BEGIN #
MESSAGE("-- cpp configure.cmake")

CONFIGURE_FILE("${MAIN_SH_SOURCES_PATH}/in/debug.in"         "${BINARY_OUTPUT_PATH}/debug")
CONFIGURE_FILE("${MAIN_SH_SOURCES_PATH}/in/example.in"       "${BINARY_OUTPUT_PATH}/example")

INCLUDE_CMAKE_FILE(${MAIN_CPP_CMAKE_PATH}/javah/configure.cmake)
INCLUDE_CMAKE_FILE(${MAIN_CPP_CMAKE_PATH}/library/configure.cmake)
INCLUDE_CMAKE_FILE(${MAIN_CPP_CMAKE_PATH}/main/configure.cmake)

# PLACEHOLDER-END #
