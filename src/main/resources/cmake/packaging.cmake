# PLACEHOLDER-BEGIN #
MESSAGE("-- packaging.cmake")

# Binary packages or non-binary (scripts, Java, Python) packages.
SET (MACHINE_BINARY_PROJECT TRUE)

IF(MACHINE_BINARY_PROJECT)
    SET(ARCH_TYPE_SUFFIX "${CMAKE_SYSTEM_PROCESSOR}")
    # Debian names of the processors, so the deb is right on a build machine without dpkg, where
    # CPack could not ask dpkg --print-architecture.
    IF(CMAKE_SYSTEM_PROCESSOR MATCHES "^(x86_64|AMD64|amd64)$")
        SET(DEBIAN_ARCH_TYPE_SUFFIX "amd64")
    ELSEIF(CMAKE_SYSTEM_PROCESSOR MATCHES "^(aarch64|arm64|ARM64)$")
        SET(DEBIAN_ARCH_TYPE_SUFFIX "arm64")
    ELSEIF(CMAKE_SYSTEM_PROCESSOR MATCHES "^i[3-6]86$")
        SET(DEBIAN_ARCH_TYPE_SUFFIX "i386")
    ELSE()
        # Unknown here: CPack asks dpkg --print-architecture.
        SET(DEBIAN_ARCH_TYPE_SUFFIX "")
    ENDIF()
ELSE ()
    SET(ARCH_TYPE_SUFFIX "noarch")
    # https://www.debian.org/doc/debian-policy/ch-controlfields.html#architecture
    SET(DEBIAN_ARCH_TYPE_SUFFIX "all")
ENDIF()

# rpmbuild rewrites "#!/usr/bin/env <interpreter>" shebangs of packaged scripts. Scripts of this
# project keep the interpreter they were written for.
SET(CPACK_RPM_SPEC_MORE_DEFINE "%undefine __brp_mangle_shebangs")

# https://cmake.org/cmake/help/latest/manual/cpack-generators.7.html
SET(CPACK_PACKAGE_NAME                    "${PROJECT_NAME}")
SET(CPACK_PACKAGE_VENDOR                  "${PROJECT_VENDOR}")
SET(CPACK_PACKAGE_DESCRIPTION             "${PROJECT_DESCRIPTION}")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY     "${PROJECT_DESCRIPTION_SUMMARY}")
SET(CPACK_PACKAGE_VERSION                 "${PROJECT_VERSION}")
SET(CPACK_PACKAGE_FILE_NAME               "${CPACK_PACKAGE_NAME}-${PROJECT_VERSION}.${ARCH_TYPE_SUFFIX}")
SET(CPACK_PACKAGE_VERSION_MAJOR           "${PROJECT_VERSION_MAJOR}")
SET(CPACK_PACKAGE_VERSION_MINOR           "${PROJECT_VERSION_MINOR}")
SET(CPACK_PACKAGE_VERSION_PATCH           "${PROJECT_VERSION_PATCH}")
SET(CPACK_PACKAGE_INSTALL_DIRECTORY       "CPack Component Example")
SET(CPACK_PACKAGING_INSTALL_PREFIX        ${CMAKE_INSTALL_PREFIX})
SET(CPACK_PACKAGE_RELOCATABLE             TRUE)

# https://cmake.org/cmake/help/latest/cpack_gen/rpm.html
SET(CPACK_RPM_PACKAGE_NAME                ${PROJECT_NAME})
SET(CPACK_RPM_PACKAGE_DESCRIPTION         "${PROJECT_DESCRIPTION}")
SET(CPACK_RPM_PACKAGE_LICENSE             "MIT")
SET(CPACK_RPM_PACKAGE_DEBUG               true)
SET(CPACK_RPM_PRE_INSTALL_SCRIPT_FILE     "${RPM_INSTALL_SCRIPTS_PATH}/pre.install.sh")
SET(CPACK_RPM_PRE_UNINSTALL_SCRIPT_FILE   "${RPM_INSTALL_SCRIPTS_PATH}/pre.uninstall.sh")
SET(CPACK_RPM_POST_INSTALL_SCRIPT_FILE    "${RPM_INSTALL_SCRIPTS_PATH}/post.install.sh")
SET(CPACK_RPM_POST_UNINSTALL_SCRIPT_FILE  "${RPM_INSTALL_SCRIPTS_PATH}/post.uninstall.sh")
SET(CPACK_RPM_PACKAGE_SUMMARY             "Summary")
SET(CPACK_RPM_CHANGELOG_FILE              ${CHANGE_LOG_FILE_NAME})
SET(CPACK_RPM_PACKAGE_ARCHITECTURE        ${ARCH_TYPE_SUFFIX})
# SET(CPACK_RPM_PACKAGE_REQUIRES            "some-else >= 1.0.0")

# https://cmake.org/cmake/help/latest/cpack_gen/deb.html
# http://www.debian.org/doc/debian-policy/ch-controlfields.html
# https://wiki.ubuntu.com/PackagingGuide/Basic?action=show&redirect=HowToBuildDebianPackagesFromScratch/
SET(CPACK_DEBIAN_PACKAGE_NAME             "${PROJECT_NAME}")
SET(CPACK_DEBIAN_PACKAGE_DESCRIPTION      "${PROJECT_DESCRIPTION}")
SET(CPACK_DEBIAN_PACKAGE_VERSION          "${CPACK_PACKAGE_VERSION}")
SET(CPACK_DEBIAN_PACKAGE_MAINTAINER       "${PROJECT_MAINTAINER}")
SET(CPACK_DEBIAN_PACKAGE_PRIORITY         "optional")
SET(CPACK_DEBIAN_PACKAGE_SECTION          "libs")
SET(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA    "${DEB_INSTALL_SCRIPTS_PATH}/preinst" "${DEB_INSTALL_SCRIPTS_PATH}/prerm" "${DEB_INSTALL_SCRIPTS_PATH}/postinst" "${DEB_INSTALL_SCRIPTS_PATH}/postrm")
# Maintainer scripts get the 0755 dpkg requires, whatever mode the checkout gave them.
SET(CPACK_DEBIAN_PACKAGE_CONTROL_STRICT_PERMISSION TRUE)
IF(DEBIAN_ARCH_TYPE_SUFFIX)
    SET(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "${DEBIAN_ARCH_TYPE_SUFFIX}")
ENDIF()
#SET(CPACK_DEBIAN_PACKAGE_DEPENDS          "some-else (>= 1.0.0)")

# https://cmake.org/cmake/help/latest/cpack_gen/freebsd.html
SET(CPACK_FREEBSD_PACKAGE_NAME            "${PROJECT_NAME}")
SET(CPACK_FREEBSD_PACKAGE_COMMENT         "${PROJECT_DESCRIPTION_SUMMARY}")
SET(CPACK_FREEBSD_PACKAGE_DESCRIPTION     "${PROJECT_DESCRIPTION}")
SET(CPACK_FREEBSD_PACKAGE_WWW             "${PROJECT_WWW}")
SET(CPACK_FREEBSD_PACKAGE_LICENSE         "${PROJECT_LICENSE}")
SET(CPACK_FREEBSD_PACKAGE_LICENSE_LOGIC   "single")
SET(CPACK_FREEBSD_PACKAGE_MAINTAINER      ${PROJECT_MAINTAINER})
SET(CPACK_FREEBSD_PACKAGE_ORIGIN          "misc/${PROJECT_NAME}")
SET(CPACK_FREEBSD_PACKAGE_CATEGORIES      "libs")
SET(CPACK_FREEBSD_PACKAGE_DEPS            "")

# https://cmake.org/cmake/help/latest/cpack_gen/nsis.html
SET(CPACK_NSIS_DISPLAY_NAME               "NSIS Display name")
SET(CPACK_NSIS_PACKAGE_NAME               "NSIS Package name")
SET(CPACK_NSIS_INSTALLED_ICON_NAME        "${APP_LOW_NAME}.ico")
SET(CPACK_NSIS_HELP_LINK                  ${APP_URL})
SET(CPACK_NSIS_URL_INFO_ABOUT             ${APP_URL})
SET(CPACK_NSIS_CONTACT                    ${APP_EMAIL})

# https://cmake.org/cmake/help/latest/cpack_gen/dmg.html
SET(CPACK_DMG_VOLUME_NAME                 "${PROJECT_NAME} Installer")
SET(CPACK_DMG_FORMAT                      "UDBZ")

IF (WIN32)
    SET(CPACK_GENERATOR                       "${DEFAULT_PACKAGES};NSIS")
ENDIF()
IF(DISTRIBUTION STREQUAL "RedHat")
    SET(CPACK_GENERATOR                       "${DEFAULT_PACKAGES};RPM")
ENDIF()
IF(DISTRIBUTION STREQUAL "Debian")
    SET(CPACK_GENERATOR                       "${DEFAULT_PACKAGES};DEB")
ENDIF()
IF(DISTRIBUTION STREQUAL "FreeBSD")
    # What is proper value for that?
    #SET(CPACK_GENERATOR                       "${DEFAULT_PACKAGES};FREEBSD")
    SET(CPACK_GENERATOR                       "${DEFAULT_PACKAGES}")
ENDIF()
IF(DISTRIBUTION STREQUAL "MacOS")
    SET(CPACK_GENERATOR                       "${DEFAULT_PACKAGES};DragNDrop")
ENDIF()

# PLACEHOLDER-PRE-PACK#

# include(CPack) reuses CPACK_GENERATOR for the source package configuration and leaves it holding
# the source generators, so what the binary packages are built with is kept here for deploy.cmake.
SET(PACKAGE_GENERATORS "${CPACK_GENERATOR}")

include(CPack)

# PLACEHOLDER-END #
