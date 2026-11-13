# PLACEHOLDER-BEGIN #
MESSAGE("-- base configure.cmake")

# Scripts with @VARIABLE@ placeholders, @SCRIPTS_INSTALL_PREFIX@ the most common one: every
# src/main/sh/in/<name>.sh.in becomes lib/<name>.sh, every other <name>.in becomes bin/<name>.
# @ONLY, as a shell script has ${VARIABLES} of its own.
FILE(GLOB SH_TEMPLATES CONFIGURE_DEPENDS "${MAIN_SH_SOURCES_PATH}/in/*.in")
FOREACH(SH_TEMPLATE IN LISTS SH_TEMPLATES)
    GET_FILENAME_COMPONENT(SH_TEMPLATE_NAME "${SH_TEMPLATE}" NAME)
    STRING(REGEX REPLACE "\\.in$" "" SH_TEMPLATE_NAME "${SH_TEMPLATE_NAME}")
    IF(SH_TEMPLATE_NAME MATCHES "\\.sh$")
        CONFIGURE_FILE("${SH_TEMPLATE}" "${LIBRARY_OUTPUT_PATH}/${SH_TEMPLATE_NAME}" @ONLY
            FILE_PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ)
    ELSE()
        CONFIGURE_FILE("${SH_TEMPLATE}" "${BINARY_OUTPUT_PATH}/${SH_TEMPLATE_NAME}" @ONLY
            FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
    ENDIF()
ENDFOREACH()

# Every etc/systemd/system/**/*.in becomes a unit or a drop-in, with @SMI_RUNTIME_VAR_PATH@,
# @CMAKE_INSTALL_PREFIX@ and the like in place, so no unit writes a path of the installation.
CONFIGURE_DIRECTORY("${MAIN_SH_SOURCES_PATH}/etc/systemd/system" "${ETC_SYSTEM_OUTPUT_PATH}")

# PLACEHOLDER-END #
