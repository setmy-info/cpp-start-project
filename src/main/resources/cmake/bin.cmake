# PLACEHOLDER-BEGIN #
MESSAGE("-- bin.cmake")

INCLUDE_CMAKE_FILE(${MAIN_CMAKE_PATH}/sh/bin.cmake)
INCLUDE_CMAKE_FILE(${MAIN_CMAKE_PATH}/cpp/bin.cmake)

IF (WIN32)
    # TODO : Win32/Win64 things
ENDIF()

# PLACEHOLDER-END #
