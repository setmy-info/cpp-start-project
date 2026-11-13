# PLACEHOLDER-BEGIN #
MESSAGE("-- deploy.cmake")

# Upload of the built packages to the machines of a runtime environment and the hand over to the
# deployment service there, setmy-info-deploy.path and smi-incoming-deploy of setmy-info-scripts,
# which installs them. The scp, the ssh and the atomic hand over are smi-deploy of the same
# package; this file only says which package goes where.
#
# A deploy target is an environment of SMI_ENVIRONMENTS, or an environment and a machine role when
# an environment has machines with different packages: test, live, live-fe, live-be. A spec says
# its targets in a header line, without one its packages go to every environment:
#
#   # smi-deploy-targets: test live-fe
#
# The main package, the one CPack builds, goes to SMI_PACKAGE_DEPLOY_TARGETS.
#
# The machines are not in this repository. They come from the environment of whoever runs make,
# the CI job, and a value set when the project was configured is only the default:
#
#   SMI_DEPLOY_<TARGET>_HOSTS     [user@]host[:port], several separated by spaces or commas;
#                                 <TARGET> upper case, - as _: SMI_DEPLOY_LIVE_FE_HOSTS
#   SMI_DEPLOY_<TARGET>_USER, _PORT, _REMOTE_DIR, _INCOMING_DIR   the same for one target,
#                                 otherwise smi-deploy takes SMI_DEPLOY_USER and the others
#   SMI_DEPLOY_STAGE=draft        hand over to the draft directory, incoming/draft
#
# Targets, for every deploy target and for every environment, which runs all of its targets:
#
#   make upload-<target>      copies the packages to the upload directory of the machines
#   make handover-<target>    moves them from there to the directory the deployment service
#                             watches, which installs them: the promotion of an uploaded package
#   make deploy-<target>      both
#
# Nothing is built by these targets: what reaches a machine is what was built and tested before,
# and a missing package is an error. Packages go in dependency order.

SET (DEPLOY_SCRIPT "${MAIN_SH_SOURCES_PATH}/build/deploy.sh")
SET (SMI_PACKAGE_DEPLOY_TARGETS "${SMI_ENVIRONMENTS}" CACHE STRING "Deploy targets of the main package")

SET (DEPLOY_TARGETS "")

# ADD_DEPLOY_PACKAGE(<package file> <target>...)
macro(ADD_DEPLOY_PACKAGE SMI_DEPLOY_PACKAGE)
    FOREACH(_SMI_DEPLOY_TARGET ${ARGN})
        IF(NOT _SMI_DEPLOY_TARGET IN_LIST DEPLOY_TARGETS)
            LIST(APPEND DEPLOY_TARGETS "${_SMI_DEPLOY_TARGET}")
            SET(DEPLOY_PACKAGES_${_SMI_DEPLOY_TARGET} "")
        ENDIF()
        LIST(APPEND DEPLOY_PACKAGES_${_SMI_DEPLOY_TARGET} "${SMI_DEPLOY_PACKAGE}")
    ENDFOREACH()
endmacro()

# The main package first: the spec packages may require it, it requires none of them. Built from
# the parts packaging.cmake builds CPACK_PACKAGE_FILE_NAME from, as include(CPack) has left that
# variable holding the source package name.
IF("RPM" IN_LIST PACKAGE_GENERATORS)
    ADD_DEPLOY_PACKAGE("${PROJECT_PATH}/${PROJECT_NAME}-${PROJECT_VERSION}.${ARCH_TYPE_SUFFIX}.rpm"
        ${SMI_PACKAGE_DEPLOY_TARGETS})
ENDIF()
FOREACH(_DEPLOY_NAME IN LISTS RPM_PACKAGE_NAMES)
    ADD_DEPLOY_PACKAGE("${RPM_PACKAGE_FILE_${_DEPLOY_NAME}}" ${RPM_PACKAGE_TARGETS_${_DEPLOY_NAME}})
ENDFOREACH()
LIST(SORT DEPLOY_TARGETS)

# The command of one action for one target, appended to the list named by RESULT.
function(APPEND_DEPLOY_COMMAND RESULT ACTION TARGET)
    STRING(TOUPPER "${TARGET}" _NAME)
    STRING(REPLACE "-" "_" _NAME "${_NAME}")
    SET(_COMMANDS ${${RESULT}})
    LIST(APPEND _COMMANDS COMMAND sh ${DEPLOY_SCRIPT} ${ACTION} ${TARGET}
        "--hosts=${SMI_DEPLOY_${_NAME}_HOSTS}" "--var=${SMI_RUNTIME_VAR_PATH}"
        ${DEPLOY_PACKAGES_${TARGET}})
    SET(${RESULT} ${_COMMANDS} PARENT_SCOPE)
endfunction()

SET (DEPLOY_HELP_COMMANDS "")
STRING(REPLACE ";" " " DEPLOY_ENVIRONMENTS_TEXT "${SMI_ENVIRONMENTS}")
FOREACH(_DEPLOY_ACTION upload handover deploy)
    # One target per deploy target with a role. A target without a role is the environment
    # itself and is part of the environment target below.
    FOREACH(_DEPLOY_TARGET IN LISTS DEPLOY_TARGETS)
        IF(NOT _DEPLOY_TARGET IN_LIST SMI_ENVIRONMENTS)
            SET(_DEPLOY_COMMANDS "")
            APPEND_DEPLOY_COMMAND(_DEPLOY_COMMANDS ${_DEPLOY_ACTION} ${_DEPLOY_TARGET})
            ADD_CUSTOM_TARGET(${_DEPLOY_ACTION}-${_DEPLOY_TARGET} ${_DEPLOY_COMMANDS} VERBATIM)
        ENDIF()
    ENDFOREACH()

    # One target per environment, which runs its targets one after the other: the environment
    # itself first, then its roles. Every environment has one, so a CI stage of an environment
    # without packages succeeds and says so.
    FOREACH(_DEPLOY_ENVIRONMENT IN LISTS SMI_ENVIRONMENTS)
        SET(_DEPLOY_COMMANDS "")
        IF(_DEPLOY_ENVIRONMENT IN_LIST DEPLOY_TARGETS)
            APPEND_DEPLOY_COMMAND(_DEPLOY_COMMANDS ${_DEPLOY_ACTION} ${_DEPLOY_ENVIRONMENT})
        ENDIF()
        FOREACH(_DEPLOY_TARGET IN LISTS DEPLOY_TARGETS)
            IF(_DEPLOY_TARGET MATCHES "^${_DEPLOY_ENVIRONMENT}-")
                APPEND_DEPLOY_COMMAND(_DEPLOY_COMMANDS ${_DEPLOY_ACTION} ${_DEPLOY_TARGET})
            ENDIF()
        ENDFOREACH()
        IF(NOT _DEPLOY_COMMANDS)
            SET(_DEPLOY_COMMANDS COMMAND ${CMAKE_COMMAND} -E echo "Nothing to ${_DEPLOY_ACTION} to ${_DEPLOY_ENVIRONMENT}")
        ENDIF()
        ADD_CUSTOM_TARGET(${_DEPLOY_ACTION}-${_DEPLOY_ENVIRONMENT} ${_DEPLOY_COMMANDS} VERBATIM)
    ENDFOREACH()
ENDFOREACH()

FOREACH(_DEPLOY_TARGET IN LISTS DEPLOY_TARGETS)
    STRING(TOUPPER "${_DEPLOY_TARGET}" _DEPLOY_NAME)
    STRING(REPLACE "-" "_" _DEPLOY_NAME "${_DEPLOY_NAME}")
    LIST(APPEND DEPLOY_HELP_COMMANDS
        COMMAND ${CMAKE_COMMAND} -E echo "  ${_DEPLOY_TARGET}: hosts SMI_DEPLOY_${_DEPLOY_NAME}_HOSTS")
    FOREACH(_DEPLOY_PACKAGE IN LISTS DEPLOY_PACKAGES_${_DEPLOY_TARGET})
        GET_FILENAME_COMPONENT(_DEPLOY_PACKAGE_NAME "${_DEPLOY_PACKAGE}" NAME)
        LIST(APPEND DEPLOY_HELP_COMMANDS COMMAND ${CMAKE_COMMAND} -E echo "      ${_DEPLOY_PACKAGE_NAME}")
    ENDFOREACH()
    MESSAGE("-- deploy ${_DEPLOY_TARGET}: ${DEPLOY_PACKAGES_${_DEPLOY_TARGET}}")
ENDFOREACH()

ADD_CUSTOM_TARGET(deploy-help
    COMMAND ${CMAKE_COMMAND} -E echo "make upload-<target>    upload the packages of a target to its machines"
    COMMAND ${CMAKE_COMMAND} -E echo "make handover-<target>  hand the uploaded packages to the deployment service, which installs them"
    COMMAND ${CMAKE_COMMAND} -E echo "make deploy-<target>    both"
    COMMAND ${CMAKE_COMMAND} -E echo "<target> is an environment, ${DEPLOY_ENVIRONMENTS_TEXT}, which runs all of its targets, or one of:"
    ${DEPLOY_HELP_COMMANDS}
    COMMAND ${CMAKE_COMMAND} -E echo "SMI_DEPLOY_STAGE=draft hands over to the draft directory of the machines"
    COMMAND ${CMAKE_COMMAND} -E echo "On a machine: journalctl -u setmy-info-deploy.service"
    VERBATIM)

# PLACEHOLDER-END #
