# PLACEHOLDER-BEGIN #
MESSAGE("-- rpm targets.cmake")

# What every module of src/main/rpm builds. It is read from the specs themselves when the project
# is configured, so each RPM is an output of the build: make all builds what changed, make clean
# removes the RPMs, and deploy.cmake knows every file name without building anything.
#
# Per package, for deploy.cmake:
#   RPM_PACKAGE_NAMES              every package, in dependency order: a package after the ones
#                                  of this project it requires
#   RPM_PACKAGE_FILE_<name>        the RPM in the project directory
#   RPM_PACKAGE_TARGETS_<name>     where it is deployed
SET (RPM_PACKAGE_NAMES "")
SET (RPM_MODULE_TARGETS "")

ADD_CUSTOM_TARGET(buildRpms)

# Values of a spec header line "# <key>: a b, c" as a list, empty when the spec has none.
function(READ_SPEC_HEADER RESULT SPEC_FILE KEY)
    FILE(STRINGS "${SPEC_FILE}" _LINES REGEX "^#[ \t]*${KEY}:")
    SET(_VALUES "")
    IF(_LINES)
        LIST(GET _LINES 0 _LINE)
        STRING(REGEX REPLACE "^#[ \t]*${KEY}:[ \t]*" "" _LINE "${_LINE}")
        STRING(REGEX REPLACE "[ \t,]+" ";" _VALUES "${_LINE}")
        LIST(REMOVE_ITEM _VALUES "")
    ENDIF()
    SET(${RESULT} "${_VALUES}" PARENT_SCOPE)
endfunction()

# Adds the packages of one spec: configures it when it is a .spec.in, asks rpmspec what it builds
# and adds the command that builds it.
function(ADD_RPM_SPEC MODULE MODULE_SOURCE_DIR MODULE_BUILD_DIR SPEC_SOURCE MODULE_INPUTS)
    GET_FILENAME_COMPONENT(_SPEC_FILE_NAME "${SPEC_SOURCE}" NAME)
    STRING(REGEX REPLACE "\\.in$" "" _SPEC_FILE_NAME "${_SPEC_FILE_NAME}")
    STRING(REGEX REPLACE "\\.spec$" "" _SPEC_NAME "${_SPEC_FILE_NAME}")
    IF(SPEC_SOURCE MATCHES "\\.in$")
        SET(_SPEC "${MODULE_BUILD_DIR}/${_SPEC_FILE_NAME}")
        CONFIGURE_FILE("${SPEC_SOURCE}" "${_SPEC}" @ONLY)
    ELSE()
        SET(_SPEC "${SPEC_SOURCE}")
    ENDIF()

    SET(_RPM_ARGUMENTS "")
    FOREACH(_DEFINE IN LISTS RPM_DEFINES)
        LIST(APPEND _RPM_ARGUMENTS --define "${_DEFINE}")
    ENDFOREACH()

    # One line per binary package: name, its file below RPMS, what it requires.
    EXECUTE_PROCESS(
        COMMAND ${RPMSPEC_EXECUTABLE} ${_RPM_ARGUMENTS} -q
            --qf "%{name}|%{arch}/%{name}-%{version}-%{release}.%{arch}.rpm|[%{requirename} ]\n" "${_SPEC}"
        OUTPUT_VARIABLE _PACKAGES ERROR_VARIABLE _ERROR RESULT_VARIABLE _RESULT
        OUTPUT_STRIP_TRAILING_WHITESPACE)
    IF(NOT _RESULT EQUAL 0)
        MESSAGE(FATAL_ERROR "rpmspec cannot read ${_SPEC}:\n${_ERROR}")
    ENDIF()
    EXECUTE_PROCESS(
        COMMAND ${RPMSPEC_EXECUTABLE} ${_RPM_ARGUMENTS} -P "${_SPEC}"
        OUTPUT_VARIABLE _PARSED RESULT_VARIABLE _RESULT)
    STRING(REGEX MATCH "(^|\n)Source0?:[ \t]*([^\n]+)" _SOURCE0 "${_PARSED}")
    IF(NOT _SOURCE0)
        MESSAGE(FATAL_ERROR "${_SPEC} has no Source0, the tarball of the module directory")
    ENDIF()
    STRING(STRIP "${CMAKE_MATCH_2}" _SOURCE0)
    GET_FILENAME_COMPONENT(_SOURCE0 "${_SOURCE0}" NAME)
    # The directory the tarball unpacks to, %autosetup -n %{srcname}-%{version} in our specs.
    STRING(REGEX REPLACE "\\.(tar\\.gz|tgz|tar\\.xz|tar\\.bz2|tar)$" "" _SETUP_DIRECTORY "${_SOURCE0}")

    READ_SPEC_HEADER(_TARGETS "${SPEC_SOURCE}" "smi-deploy-targets")
    IF(NOT _TARGETS)
        SET(_TARGETS ${SMI_ENVIRONMENTS})
    ENDIF()
    FOREACH(_TARGET IN LISTS _TARGETS)
        STRING(REGEX MATCH "^[a-z0-9]+" _ENVIRONMENT "${_TARGET}")
        IF(NOT _TARGET MATCHES "^[a-z0-9]+(-[a-z0-9]+)*$" OR NOT _ENVIRONMENT IN_LIST SMI_ENVIRONMENTS)
            MESSAGE(FATAL_ERROR "${SPEC_SOURCE}: deploy target '${_TARGET}' is not <environment>[-<role>] "
                "with an environment of SMI_ENVIRONMENTS: ${SMI_ENVIRONMENTS}")
        ENDIF()
    ENDFOREACH()

    SET(_TOPDIR "${RPM_BUILD_PATH}/rpmbuild/${_SPEC_NAME}")
    SET(_OUTPUTS "")
    SET(_RPM_FILES "")
    STRING(REPLACE "\n" ";" _PACKAGES "${_PACKAGES}")
    FOREACH(_PACKAGE IN LISTS _PACKAGES)
        STRING(REPLACE "|" ";" _FIELDS "${_PACKAGE}")
        LIST(GET _FIELDS 0 _NAME)
        LIST(GET _FIELDS 1 _RPM_FILE)
        LIST(LENGTH _FIELDS _FIELD_COUNT)
        SET(_REQUIRES "")
        IF(_FIELD_COUNT GREATER 2)
            LIST(GET _FIELDS 2 _REQUIRES)
            STRING(REGEX REPLACE "[ \t]+" ";" _REQUIRES "${_REQUIRES}")
            LIST(REMOVE_ITEM _REQUIRES "")
        ENDIF()
        IF(_NAME IN_LIST RPM_PACKAGE_NAMES)
            MESSAGE(FATAL_ERROR "Package ${_NAME} of ${SPEC_SOURCE} is built by another spec too")
        ENDIF()
        GET_FILENAME_COMPONENT(_FILE_NAME "${_RPM_FILE}" NAME)
        LIST(APPEND _OUTPUTS "${PROJECT_PATH}/${_FILE_NAME}")
        LIST(APPEND _RPM_FILES "${_RPM_FILE}")
        LIST(APPEND RPM_PACKAGE_NAMES "${_NAME}")
        SET(RPM_PACKAGE_FILE_${_NAME}     "${PROJECT_PATH}/${_FILE_NAME}" PARENT_SCOPE)
        SET(RPM_PACKAGE_TARGETS_${_NAME}  "${_TARGETS}"                   PARENT_SCOPE)
        SET(RPM_PACKAGE_REQUIRES_${_NAME} "${_REQUIRES}"                  PARENT_SCOPE)
        MESSAGE("-- rpm ${MODULE}: ${_FILE_NAME} -> ${_TARGETS}")
    ENDFOREACH()
    SET(RPM_PACKAGE_NAMES "${RPM_PACKAGE_NAMES}" PARENT_SCOPE)

    # Parameters of rpm-build.cmake in a file, which keeps paths and the defines out of the quoting
    # of a command line.
    SET(_PARAMETERS "${MODULE_BUILD_DIR}/${_SPEC_NAME}.parameters.cmake")
    FILE(WRITE "${_PARAMETERS}"
        "SET(RPMBUILD [==[${RPMBUILD_EXECUTABLE}]==])\n"
        "SET(SPEC [==[${_SPEC}]==])\n"
        "SET(MODULE_SOURCE_DIR [==[${MODULE_SOURCE_DIR}]==])\n"
        "SET(MODULE_CONFIGURED_DIR [==[${MODULE_BUILD_DIR}/configured]==])\n"
        "SET(TOPDIR [==[${_TOPDIR}]==])\n"
        "SET(SOURCE0 [==[${_SOURCE0}]==])\n"
        "SET(SETUP_DIRECTORY [==[${_SETUP_DIRECTORY}]==])\n"
        "SET(RPM_FILES [==[${_RPM_FILES}]==])\n"
        "SET(OUTPUT_DIR [==[${PROJECT_PATH}]==])\n"
        "SET(RPM_DEFINES [==[${RPM_DEFINES}]==])\n")

    ADD_CUSTOM_COMMAND(
        OUTPUT ${_OUTPUTS}
        COMMAND ${CMAKE_COMMAND} -DPARAMETERS=${_PARAMETERS} -P ${RPM_BUILD_SCRIPT}
        DEPENDS "${_SPEC}" ${MODULE_INPUTS} ${_PARAMETERS} ${RPM_BUILD_SCRIPT}
        COMMENT "Building RPM ${_SPEC_FILE_NAME}"
        VERBATIM)
    SET(_SPEC_OUTPUTS ${_OUTPUTS} PARENT_SCOPE)
endfunction()

IF(RPM_BUILD_ENABLED)
    GET_SUBDIRECTORIES(RPM_MODULES "${MAIN_RPM_SOURCES_PATH}")
    FOREACH(RPM_MODULE IN LISTS RPM_MODULES)
        SET(RPM_MODULE_SOURCE_DIR "${MAIN_RPM_SOURCES_PATH}/${RPM_MODULE}")
        SET(RPM_MODULE_BUILD_DIR  "${RPM_BUILD_PATH}/${RPM_MODULE}")
        FILE(MAKE_DIRECTORY "${RPM_MODULE_BUILD_DIR}/configured")

        FILE(GLOB RPM_MODULE_SPECS CONFIGURE_DEPENDS
            "${RPM_MODULE_SOURCE_DIR}/*.spec" "${RPM_MODULE_SOURCE_DIR}/*.spec.in")
        LIST(SORT RPM_MODULE_SPECS)
        IF(NOT RPM_MODULE_SPECS)
            MESSAGE("-- rpm ${RPM_MODULE}: no spec, nothing to build")
            CONTINUE()
        ENDIF()

        # The tarball content: every file but the specs, the *.in files configured.
        FILE(GLOB_RECURSE RPM_MODULE_FILES LIST_DIRECTORIES false CONFIGURE_DEPENDS "${RPM_MODULE_SOURCE_DIR}/*")
        LIST(FILTER RPM_MODULE_FILES EXCLUDE REGEX "\\.spec(\\.in)?$")
        SET(RPM_MODULE_INPUTS "")
        FOREACH(RPM_MODULE_FILE IN LISTS RPM_MODULE_FILES)
            IF(RPM_MODULE_FILE MATCHES "\\.in$")
                FILE(RELATIVE_PATH RPM_MODULE_RELATIVE "${RPM_MODULE_SOURCE_DIR}" "${RPM_MODULE_FILE}")
                STRING(REGEX REPLACE "\\.in$" "" RPM_MODULE_RELATIVE "${RPM_MODULE_RELATIVE}")
                CONFIGURE_FILE("${RPM_MODULE_FILE}" "${RPM_MODULE_BUILD_DIR}/configured/${RPM_MODULE_RELATIVE}" @ONLY)
                LIST(APPEND RPM_MODULE_INPUTS "${RPM_MODULE_BUILD_DIR}/configured/${RPM_MODULE_RELATIVE}")
            ELSE()
                LIST(APPEND RPM_MODULE_INPUTS "${RPM_MODULE_FILE}")
            ENDIF()
        ENDFOREACH()

        SET(RPM_MODULE_OUTPUTS "")
        FOREACH(RPM_MODULE_SPEC IN LISTS RPM_MODULE_SPECS)
            ADD_RPM_SPEC("${RPM_MODULE}" "${RPM_MODULE_SOURCE_DIR}" "${RPM_MODULE_BUILD_DIR}"
                "${RPM_MODULE_SPEC}" "${RPM_MODULE_INPUTS}")
            LIST(APPEND RPM_MODULE_OUTPUTS ${_SPEC_OUTPUTS})
        ENDFOREACH()

        ADD_CUSTOM_TARGET(rpm-${RPM_MODULE} DEPENDS ${RPM_MODULE_OUTPUTS})
        LIST(APPEND RPM_MODULE_TARGETS rpm-${RPM_MODULE})
    ENDFOREACH()

    # Dependency order: a package after every package of this project it requires, otherwise in
    # the order found. smi-incoming-deploy installs what is in its directory when the first file
    # arrives, so what is handed over first must install without the rest.
    SET(RPM_UNORDERED ${RPM_PACKAGE_NAMES})
    SET(RPM_PACKAGE_NAMES "")
    WHILE(RPM_UNORDERED)
        SET(RPM_PROGRESS FALSE)
        FOREACH(RPM_NAME IN LISTS RPM_UNORDERED)
            SET(RPM_READY TRUE)
            FOREACH(RPM_REQUIRE IN LISTS RPM_PACKAGE_REQUIRES_${RPM_NAME})
                IF(RPM_REQUIRE IN_LIST RPM_UNORDERED AND NOT RPM_REQUIRE STREQUAL RPM_NAME)
                    SET(RPM_READY FALSE)
                ENDIF()
            ENDFOREACH()
            IF(RPM_READY)
                LIST(APPEND RPM_PACKAGE_NAMES "${RPM_NAME}")
                LIST(REMOVE_ITEM RPM_UNORDERED "${RPM_NAME}")
                SET(RPM_PROGRESS TRUE)
                BREAK()
            ENDIF()
        ENDFOREACH()
        IF(NOT RPM_PROGRESS)
            MESSAGE(WARNING "Packages that require each other, kept in the order found: ${RPM_UNORDERED}")
            LIST(APPEND RPM_PACKAGE_NAMES ${RPM_UNORDERED})
            SET(RPM_UNORDERED "")
        ENDIF()
    ENDWHILE()
    MESSAGE("-- RPM_PACKAGE_NAMES: ${RPM_PACKAGE_NAMES}")

    IF(RPMLINT_EXECUTABLE)
        SET(RPM_LINT_FILES "")
        FOREACH(RPM_NAME IN LISTS RPM_PACKAGE_NAMES)
            LIST(APPEND RPM_LINT_FILES "${RPM_PACKAGE_FILE_${RPM_NAME}}")
        ENDFOREACH()
        ADD_CUSTOM_TARGET(rpmlint COMMAND ${RPMLINT_EXECUTABLE} ${RPM_LINT_FILES} VERBATIM)
    ENDIF()
ENDIF()

# PLACEHOLDER-END #
