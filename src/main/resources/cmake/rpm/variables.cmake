# PLACEHOLDER-BEGIN #
MESSAGE("-- rpm variables.cmake")

# RPM packages built from hand written spec files, for configuration packages and anything else
# CPack does not fit: one package per machine role and runtime environment, scriptlets that
# replace files owned by other packages, %config(noreplace) and the like.
#
#   src/main/rpm/<module>/*.spec        a spec, used as it is
#   src/main/rpm/<module>/*.spec.in     a spec with @VARIABLE@ placeholders, configured first
#   src/main/rpm/<module>/...           everything else is the Source0 tarball of the module:
#                                       fedora/etc/..., README.md, ...; *.in files in it are
#                                       configured and lose the suffix
#
# A spec says where its packages are deployed in a comment line, see deploy.cmake:
#
#   # smi-deploy-targets: test live-fe
#
# The RPMs are written into the project directory, beside the CPack packages.

SET (MAIN_RPM_SOURCES_PATH          ${MAIN_SOURCES_PATH}/rpm)
SET (RPM_BUILD_PATH                 ${BUILD_TYPE_TARGET_PATH}/rpm)
SET (RPM_BUILD_SCRIPT               ${MAIN_CMAKE_PATH}/rpm/rpm-build.cmake)

FIND_PROGRAM(RPMBUILD_EXECUTABLE rpmbuild)
FIND_PROGRAM(RPMSPEC_EXECUTABLE  rpmspec)
FIND_PROGRAM(RPMLINT_EXECUTABLE  rpmlint)

IF(RPMBUILD_EXECUTABLE AND RPMSPEC_EXECUTABLE)
    SET (RPM_BUILD_ENABLED TRUE)
ELSE()
    SET (RPM_BUILD_ENABLED FALSE)
    MESSAGE("-- rpmbuild or rpmspec not found, the spec file packages are not built")
ENDIF()

# The project version as RPM allows it: no "-" in a Version, and "~" sorts before the release, so
# 1.0.0~SNAPSHOT is older than 1.0.0 to rpm and dnf, as 1.0.0-SNAPSHOT is to maven.
STRING(REPLACE "-" "~" RPM_VERSION "${PROJECT_VERSION}")

# Macros every spec can use, so a spec needs no .in to know the project version or the paths.
SET (RPM_DEFINES
    "smi_version ${RPM_VERSION}"
    "smi_provider ${PROVIDER}"
    "smi_prefix ${CMAKE_INSTALL_PREFIX}"
    "smi_var ${SMI_RUNTIME_VAR_PATH}")

MESSAGE("-- MAIN_RPM_SOURCES_PATH: ${MAIN_RPM_SOURCES_PATH}")
MESSAGE("-- RPM_BUILD_PATH: ${RPM_BUILD_PATH}")

# PLACEHOLDER-END #
