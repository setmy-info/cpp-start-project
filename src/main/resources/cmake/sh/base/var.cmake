# PLACEHOLDER-BEGIN #
MESSAGE("-- base var.cmake")

IF(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    INSTALL(DIRECTORY "${BUILD_PATH}/var/opt/${PROVIDER}" DESTINATION var/opt/${PROVIDER})
ENDIF()

# PLACEHOLDER-END #
