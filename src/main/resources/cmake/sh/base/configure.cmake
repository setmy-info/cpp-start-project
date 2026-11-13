# PLACEHOLDER-BEGIN #
MESSAGE("-- base configure.cmake")

#CONFIGURE_FILE("${MAIN_SH_SOURCES_PATH}/in/some.in"       "${BINARY_OUTPUT_PATH}/some")
#CONFIGURE_FILE("${MAIN_SH_SOURCES_PATH}/in/another.sh.in" "${LIBRARY_OUTPUT_PATH}/another.sh")

# Every etc/systemd/system/**/*.in becomes a unit or a drop-in, with @SMI_RUNTIME_VAR_PATH@,
# @CMAKE_INSTALL_PREFIX@ and the like in place, so no unit writes a path of the installation.
CONFIGURE_DIRECTORY("${MAIN_SH_SOURCES_PATH}/etc/systemd/system" "${ETC_SYSTEM_OUTPUT_PATH}")

# PLACEHOLDER-END #
