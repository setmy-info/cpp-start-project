# Builds the RPMs of one spec, run by the build as cmake -DPARAMETERS=<file> -P rpm-build.cmake.
# The parameters file is written by targets.cmake when the project is configured.
#
# The rpmbuild top directory belongs to this spec alone, under target/, so specs of one module that
# share their Source0 can be built at the same time by make -j, and nothing is written to
# ~/rpmbuild of whoever runs the build.

INCLUDE("${PARAMETERS}")

SET(STAGE "${TOPDIR}/STAGE")
FILE(REMOVE_RECURSE "${STAGE}" "${TOPDIR}/RPMS" "${TOPDIR}/SOURCES")
FILE(MAKE_DIRECTORY "${STAGE}/${SETUP_DIRECTORY}" "${TOPDIR}/SOURCES")

# The module directory without its specs and templates, then the configured templates over it.
# FILE(COPY) keeps the permissions of the sources.
FILE(COPY "${MODULE_SOURCE_DIR}/" DESTINATION "${STAGE}/${SETUP_DIRECTORY}"
    PATTERN "*.spec" EXCLUDE
    PATTERN "*.in" EXCLUDE)
FILE(COPY "${MODULE_CONFIGURED_DIR}/" DESTINATION "${STAGE}/${SETUP_DIRECTORY}")

IF(SOURCE0 MATCHES "\\.(tar\\.xz)$")
    SET(TAR_FLAGS cJf)
ELSEIF(SOURCE0 MATCHES "\\.(tar\\.bz2)$")
    SET(TAR_FLAGS cjf)
ELSEIF(SOURCE0 MATCHES "\\.tar$")
    SET(TAR_FLAGS cf)
ELSE()
    SET(TAR_FLAGS czf)
ENDIF()
EXECUTE_PROCESS(
    COMMAND ${CMAKE_COMMAND} -E tar ${TAR_FLAGS} "${TOPDIR}/SOURCES/${SOURCE0}" "${SETUP_DIRECTORY}"
    WORKING_DIRECTORY "${STAGE}"
    RESULT_VARIABLE RESULT)
IF(NOT RESULT EQUAL 0)
    MESSAGE(FATAL_ERROR "Could not create ${SOURCE0}")
ENDIF()

SET(ARGUMENTS --define "_topdir ${TOPDIR}")
FOREACH(DEFINE IN LISTS RPM_DEFINES)
    LIST(APPEND ARGUMENTS --define "${DEFINE}")
ENDFOREACH()
EXECUTE_PROCESS(
    COMMAND "${RPMBUILD}" --quiet -bb ${ARGUMENTS} "${SPEC}"
    RESULT_VARIABLE RESULT)
IF(NOT RESULT EQUAL 0)
    MESSAGE(FATAL_ERROR "rpmbuild failed for ${SPEC}")
ENDIF()

FOREACH(RPM_FILE IN LISTS RPM_FILES)
    IF(NOT EXISTS "${TOPDIR}/RPMS/${RPM_FILE}")
        MESSAGE(FATAL_ERROR "rpmbuild did not write ${RPM_FILE}, which rpmspec announced for ${SPEC}")
    ENDIF()
    # No package of ours installs into /usr/share/doc: documentation belongs to src/site and is
    # installed with the main package. A %doc or %license line of a spec puts files there.
    EXECUTE_PROCESS(COMMAND rpm -qpl "${TOPDIR}/RPMS/${RPM_FILE}" OUTPUT_VARIABLE RPM_CONTENT)
    IF(RPM_CONTENT MATCHES "(^|\n)/usr/share/doc/")
        MESSAGE(FATAL_ERROR "${RPM_FILE} installs into /usr/share/doc: remove the %doc and %license lines of ${SPEC}")
    ENDIF()
    FILE(COPY "${TOPDIR}/RPMS/${RPM_FILE}" DESTINATION "${OUTPUT_DIR}")
    GET_FILENAME_COMPONENT(RPM_FILE_NAME "${RPM_FILE}" NAME)
    MESSAGE("Built ${OUTPUT_DIR}/${RPM_FILE_NAME}")
ENDFOREACH()
