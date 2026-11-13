cmake_minimum_required (VERSION 4.4)

# PLACEHOLDER-BEGIN #

PROJECT (cpp-start-project)

SET (PROJECT_VERSION_MAJOR              1)
SET (PROJECT_VERSION_MINOR              0)
SET (PROJECT_VERSION_PATCH              0)
SET (PROJECT_VERSION_TWEAK              0)

SET (PROJECT_DESCRIPTION_SUMMARY        "setmy.info C++ starter project")
SET (PROJECT_DESCRIPTION                "setmy.info C++ starter project Installation Example")
SET (PROJECT_VENDOR                     "Hear And See Systems LLC")
SET (PROJECT_MAINTAINER                 "Imre Tabur <imre.tabur@mail.ee>")
SET (PROJECT_WWW                        "https://setmy.info")
SET (PROJECT_LICENSE                    "MIT")

# The whole build is this file. The cycle is the traditional one: ./configure [release], make all,
# make test, make package, make install. The sources are in the maven directory structure and are
# used as they are: nothing is generated from a template, nothing is copied with placeholders
# filled in. The modules of a language are directories, found when the project is configured, so
# a new module is a new directory; only the C++ targets are named here.
#
#   src/main/cpp/<module>          C++, the targets of section 6
#   src/main/sh/bin, lib, etc      shell scripts, libraries, configuration
#   src/main/<language>/bin, lib   cmd, groovy, python, cl, erlang
#   src/main/elixir                Elixir with Mix, mix.exs in the project root
#   src/main/man/<module>/manN     man pages
#   src/main/config/<package>      configuration packages, an RPM each
#   src/site/markdown, resources   documentation
#   src/test/...                   tests of the same languages

enable_testing()

# ---------------------------------------------------------------------------------------------
# 1. Environment
# ---------------------------------------------------------------------------------------------

SET (PROVIDER "setmy.info")

IF (CMAKE_SYSTEM_PROCESSOR MATCHES "i386|i586|i686")
    SET (ARCH "32")
ELSE ()
    SET (ARCH "64")
ENDIF ()

IF(EXISTS "/etc/debian_version")
    SET (DISTRIBUTION "Debian")
ENDIF()
IF(EXISTS "/etc/redhat-release")
    SET (DISTRIBUTION "RedHat")
ENDIF()
IF(EXISTS "/bin/freebsd-version")
    SET (DISTRIBUTION "FreeBSD")
ENDIF()
IF(APPLE)
    SET (DISTRIBUTION "MacOS")
ENDIF()

IF(PROJECT_IS_SNAPSHOT)
    SET (PROJECT_VERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}-SNAPSHOT)
ELSE()
    SET (PROJECT_VERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH})
ENDIF()

# The runtime environments, in the order of the delivery pipeline. A deploy target is one of them,
# or one of them with a machine role: live-fe, live-be. See section 12.
SET (SMI_ENVIRONMENTS "local;dev;test;prelive;live" CACHE STRING "Runtime environments")

# Every environment variable named SMI_* becomes a variable of the same name, unless one is set
# with -D, so the machines of an environment that the CI job sets reach section 12.
EXECUTE_PROCESS(COMMAND ${CMAKE_COMMAND} -E environment OUTPUT_VARIABLE SMI_ENVIRONMENT)
STRING(REGEX MATCHALL "(^|\n)SMI_[A-Za-z0-9_]+=" SMI_ENVIRONMENT_NAMES "${SMI_ENVIRONMENT}")
FOREACH(SMI_ENVIRONMENT_NAME IN LISTS SMI_ENVIRONMENT_NAMES)
    STRING(REGEX REPLACE "^\n?(SMI_[A-Za-z0-9_]+)=$" "\\1" SMI_ENVIRONMENT_NAME "${SMI_ENVIRONMENT_NAME}")
    IF(NOT DEFINED ${SMI_ENVIRONMENT_NAME})
        SET (${SMI_ENVIRONMENT_NAME} "$ENV{${SMI_ENVIRONMENT_NAME}}")
    ENDIF()
ENDFOREACH()

# ---------------------------------------------------------------------------------------------
# 2. Paths
# ---------------------------------------------------------------------------------------------

SET (PROJECT_PATH                   ${PROJECT_BINARY_DIR})
SET (TARGET_PATH                    ${PROJECT_PATH}/target)
SET (BUILD_TYPE_TARGET_PATH         ${TARGET_PATH}/${CMAKE_BUILD_TYPE})
# The build tree has the layout of the installation, bin, lib, man, etc and doc, so a script finds
# what it needs relative to itself in both.
SET (BUILD_PATH                     ${BUILD_TYPE_TARGET_PATH}/build)
SET (BINARY_OUTPUT_PATH             ${BUILD_PATH}/bin)
SET (LIBRARY_OUTPUT_PATH            ${BUILD_PATH}/lib)
SET (EXECUTABLE_OUTPUT_PATH         ${BINARY_OUTPUT_PATH})
SET (MAN_OUTPUT_PATH                ${BUILD_PATH}/man)
SET (DOC_OUTPUT_PATH                ${BUILD_PATH}/doc)
SET (ETC_OUTPUT_PATH                ${BUILD_PATH}/etc)
SET (INCLUDE_OUTPUT_PATH            ${BUILD_PATH}/include)
# The var directory on the installed machine, created by the install scripts, never packaged.
SET (SMI_RUNTIME_VAR_PATH           /var/opt/${PROVIDER})

SET (SOURCES_PATH                   ${PROJECT_SOURCE_DIR}/src)
SET (MAIN_SOURCES_PATH              ${SOURCES_PATH}/main)
SET (TEST_SOURCES_PATH              ${SOURCES_PATH}/test)
SET (SITE_SOURCES_PATH              ${SOURCES_PATH}/site)
SET (MAIN_CPP_SOURCES_PATH          ${MAIN_SOURCES_PATH}/cpp)
SET (MAIN_INCLUDES_PATH             ${MAIN_CPP_SOURCES_PATH}/include)
SET (MAIN_SH_SOURCES_PATH           ${MAIN_SOURCES_PATH}/sh)
SET (MAIN_ELIXIR_SOURCES_PATH       ${MAIN_SOURCES_PATH}/elixir)
SET (MAIN_JAVA_SOURCES_PATH         ${MAIN_SOURCES_PATH}/java)
SET (MAIN_MAN_SOURCES_PATH          ${MAIN_SOURCES_PATH}/man)
SET (MAIN_CONFIG_SOURCES_PATH       ${MAIN_SOURCES_PATH}/config)
SET (TEST_CPP_SOURCES_PATH          ${TEST_SOURCES_PATH}/cpp)
SET (TEST_ELIXIR_SOURCES_PATH       ${TEST_SOURCES_PATH}/elixir)
SET (RPM_INSTALL_SCRIPTS_PATH       ${MAIN_SH_SOURCES_PATH}/rpm)
SET (DEB_INSTALL_SCRIPTS_PATH       ${MAIN_SH_SOURCES_PATH}/deb)
SET (CHANGE_LOG_FILE_NAME           ${PROJECT_SOURCE_DIR}/changelog)
SET (DEFAULT_PACKAGES               "TGZ;STGZ;7Z;TBZ2;TXZ;TZ;ZIP")

SET (CMAKE_CONFIGURATION_TYPES Debug Release CACHE STRING "Configurations" FORCE)

IF(CMAKE_SYSTEM_NAME STREQUAL "FreeBSD")
    SET (CMAKE_INSTALL_PREFIX "/usr/local")
    SET (CPACK_ENABLE_FREEBSD_PKG ON CACHE BOOL "Enable pkg(8) generator in CPack")
ELSE()
    SET (CMAKE_INSTALL_PREFIX "/opt/${PROVIDER}")
ENDIF()
# What the install rules of the main package install; a configuration package has its own.
SET (CMAKE_INSTALL_DEFAULT_COMPONENT_NAME main)

MESSAGE("-- DISTRIBUTION:         ${DISTRIBUTION}")
MESSAGE("-- PROJECT_VERSION:      ${PROJECT_VERSION}")
MESSAGE("-- CMAKE_BUILD_TYPE:     ${CMAKE_BUILD_TYPE}")
MESSAGE("-- CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")
MESSAGE("-- BUILD_PATH:           ${BUILD_PATH}")
# Kept for the options of ./configure: scripts find their paths at runtime, relative to themselves.
MESSAGE("-- CONFIGURE_MODE:       ${CONFIGURE_MODE}")

# ---------------------------------------------------------------------------------------------
# 3. Helpers
# ---------------------------------------------------------------------------------------------

# GET_SUBDIRECTORIES(<result> <directory>): the directories directly under <directory>, "base"
# first when there is one, the rest in alphabetical order.
function(GET_SUBDIRECTORIES RESULT DIRECTORY)
    SET(_SUBDIRECTORIES "")
    IF(IS_DIRECTORY "${DIRECTORY}")
        FILE(GLOB _CHILDREN LIST_DIRECTORIES true RELATIVE "${DIRECTORY}" CONFIGURE_DEPENDS "${DIRECTORY}/*")
        LIST(SORT _CHILDREN)
        FOREACH(_CHILD IN LISTS _CHILDREN)
            IF(IS_DIRECTORY "${DIRECTORY}/${_CHILD}")
                LIST(APPEND _SUBDIRECTORIES "${_CHILD}")
            ENDIF()
        ENDFOREACH()
        IF("base" IN_LIST _SUBDIRECTORIES)
            LIST(REMOVE_ITEM _SUBDIRECTORIES "base")
            LIST(PREPEND _SUBDIRECTORIES "base")
        ENDIF()
    ENDIF()
    SET(${RESULT} "${_SUBDIRECTORIES}" PARENT_SCOPE)
endfunction()

# ADD_COPY_TARGET(<target> <destination> <glob>...): a build step, part of make all, that copies
# the files matching the globs into <destination>, and does nothing without one. A file added or
# removed is noticed by the next build.
function(ADD_COPY_TARGET TARGET_NAME DESTINATION)
    SET(_FILES "")
    IF(ARGN)
        FILE(GLOB _FILES LIST_DIRECTORIES false CONFIGURE_DEPENDS ${ARGN})
        LIST(FILTER _FILES EXCLUDE REGEX "/\\.empty$")
    ENDIF()
    IF(_FILES)
        ADD_CUSTOM_TARGET(${TARGET_NAME}
            COMMAND ${CMAKE_COMMAND} -E make_directory "${DESTINATION}"
            COMMAND ${CMAKE_COMMAND} -E copy ${_FILES} "${DESTINATION}"
            VERBATIM)
    ELSE()
        ADD_CUSTOM_TARGET(${TARGET_NAME})
    ENDIF()
    ADD_DEPENDENCIES(build ${TARGET_NAME})
endfunction()

# ADD_COPY_DIRECTORY_TARGET(<target> <destination> <directory>): the same for a directory tree.
function(ADD_COPY_DIRECTORY_TARGET TARGET_NAME DESTINATION SOURCE_DIRECTORY)
    IF(IS_DIRECTORY "${SOURCE_DIRECTORY}")
        ADD_CUSTOM_TARGET(${TARGET_NAME}
            COMMAND ${CMAKE_COMMAND} -E copy_directory "${SOURCE_DIRECTORY}" "${DESTINATION}"
            VERBATIM)
    ELSE()
        ADD_CUSTOM_TARGET(${TARGET_NAME})
    ENDIF()
    ADD_DEPENDENCIES(build ${TARGET_NAME})
endfunction()

# ADD_MAN_TARGET(<target> <man directory>): copies the pages <man directory>/manN/*.N into
# man/manN and compresses them.
function(ADD_MAN_TARGET TARGET_NAME MAN_SOURCE_DIRECTORY)
    SET(_COMMANDS "")
    FOREACH(_SECTION RANGE 1 9)
        FILE(GLOB _PAGES LIST_DIRECTORIES false CONFIGURE_DEPENDS "${MAN_SOURCE_DIRECTORY}/man${_SECTION}/*.${_SECTION}")
        IF(_PAGES)
            SET(_COPIED "")
            FOREACH(_PAGE IN LISTS _PAGES)
                GET_FILENAME_COMPONENT(_PAGE_NAME "${_PAGE}" NAME)
                LIST(APPEND _COPIED "${MAN_OUTPUT_PATH}/man${_SECTION}/${_PAGE_NAME}")
            ENDFOREACH()
            LIST(APPEND _COMMANDS
                COMMAND ${CMAKE_COMMAND} -E make_directory "${MAN_OUTPUT_PATH}/man${_SECTION}"
                COMMAND ${CMAKE_COMMAND} -E copy ${_PAGES} "${MAN_OUTPUT_PATH}/man${_SECTION}"
                COMMAND gzip -f ${_COPIED})
        ENDIF()
    ENDFOREACH()
    ADD_CUSTOM_TARGET(${TARGET_NAME} ${_COMMANDS} VERBATIM)
    ADD_DEPENDENCIES(build ${TARGET_NAME})
endfunction()

# ---------------------------------------------------------------------------------------------
# 4. Common targets
# ---------------------------------------------------------------------------------------------

SET (CMAKE_VERBOSE_MAKEFILE TRUE)

ADD_CUSTOM_TARGET(build ALL)
ADD_CUSTOM_TARGET(site)
# make clean empties the build tree, copies included, as section 9 installs what it holds.
SET_PROPERTY(DIRECTORY APPEND PROPERTY ADDITIONAL_CLEAN_FILES ${BUILD_PATH})
ADD_CUSTOM_TARGET(makeDirectories
    COMMAND ${CMAKE_COMMAND} -E make_directory ${BINARY_OUTPUT_PATH} ${LIBRARY_OUTPUT_PATH} ${INCLUDE_OUTPUT_PATH})
ADD_CUSTOM_TARGET(clearBuild COMMAND ${CMAKE_COMMAND} -E rm -rf ${TARGET_PATH})
ADD_CUSTOM_TARGET(clearCmake COMMAND ${CMAKE_COMMAND} -E rm -rf
    CMakeCache.txt CMakeFiles _CPack_Packages cmake_install.cmake CTestTestfile.cmake
    CPackConfig.cmake CPackSourceConfig.cmake install_manifest.txt
    WORKING_DIRECTORY ${PROJECT_PATH})
# clearPkg and clear are in section 11, as they need the names of every package.

# ---------------------------------------------------------------------------------------------
# 5. Shell scripts, interpreted languages, man pages
# ---------------------------------------------------------------------------------------------

ADD_COPY_TARGET(buildShellScripts                 ${BINARY_OUTPUT_PATH}           ${MAIN_SH_SOURCES_PATH}/bin/*)
ADD_COPY_TARGET(buildLibShells                    ${LIBRARY_OUTPUT_PATH}          ${MAIN_SH_SOURCES_PATH}/lib/*.sh ${MAIN_SH_SOURCES_PATH}/lib/*.txt)
ADD_COPY_DIRECTORY_TARGET(buildProfiles           ${LIBRARY_OUTPUT_PATH}/profiles ${MAIN_SH_SOURCES_PATH}/lib/profiles)
ADD_COPY_DIRECTORY_TARGET(buildPackages           ${LIBRARY_OUTPUT_PATH}/packages ${MAIN_SH_SOURCES_PATH}/lib/packages)
ADD_COPY_DIRECTORY_TARGET(buildEtc                ${ETC_OUTPUT_PATH}/profile.d    ${MAIN_SH_SOURCES_PATH}/etc/profile.d)
ADD_COPY_TARGET(buildServiceScripts               ${ETC_OUTPUT_PATH}/systemd/system
    ${MAIN_SH_SOURCES_PATH}/etc/systemd/system/*.service
    ${MAIN_SH_SOURCES_PATH}/etc/systemd/system/*.timer
    ${MAIN_SH_SOURCES_PATH}/etc/systemd/system/*.path
    ${MAIN_SH_SOURCES_PATH}/etc/systemd/system/*.socket
    ${MAIN_SH_SOURCES_PATH}/etc/systemd/system/*.target)
ADD_COPY_TARGET(buildServiceEnvironment           ${ETC_OUTPUT_PATH}              ${MAIN_SH_SOURCES_PATH}/etc/systemd/system/environment.conf)
ADD_COPY_TARGET(buildYumReposScripts              ${ETC_OUTPUT_PATH}/yum.repos.d  ${MAIN_SH_SOURCES_PATH}/etc/yum.repos.d/*.repo)

# Interpreted languages, the same way for each: src/main/<language>/bin/* goes to bin and the
# content of src/main/<language>/lib to lib. Elixir is section 7.
FOREACH(SCRIPT_LANGUAGE cmd groovy python cl erlang)
    ADD_COPY_TARGET(build-${SCRIPT_LANGUAGE}-bin           ${BINARY_OUTPUT_PATH}  ${MAIN_SOURCES_PATH}/${SCRIPT_LANGUAGE}/bin/*)
    ADD_COPY_DIRECTORY_TARGET(build-${SCRIPT_LANGUAGE}-lib ${LIBRARY_OUTPUT_PATH} ${MAIN_SOURCES_PATH}/${SCRIPT_LANGUAGE}/lib)
ENDFOREACH()

# Man pages of every module: src/main/man/<module>/manN/*.N.
GET_SUBDIRECTORIES(MAN_MODULES ${MAIN_MAN_SOURCES_PATH})
FOREACH(MAN_MODULE IN LISTS MAN_MODULES)
    ADD_MAN_TARGET(build-man-${MAN_MODULE} ${MAIN_MAN_SOURCES_PATH}/${MAN_MODULE})
ENDFOREACH()

# ---------------------------------------------------------------------------------------------
# 6. C++
# ---------------------------------------------------------------------------------------------

SET (CMAKE_CXX_STANDARD 17)
SET (CMAKE_CXX_STANDARD_REQUIRED ON)
SET (CMAKE_CXX_EXTENSIONS OFF)
# -Wall -Wextra -pedantic -Werror -Wfloat-conversion
ADD_COMPILE_OPTIONS(-Wall -Wextra -pedantic)
ADD_COMPILE_DEFINITIONS(PTHREADSAFE
    PROJECT_MODULE_VERSION_MAJOR=${PROJECT_VERSION_MAJOR}
    PROJECT_MODULE_VERSION_MINOR=${PROJECT_VERSION_MINOR}
    PROJECT_MODULE_VERSION_PATCH=${PROJECT_VERSION_PATCH}
    PROJECT_MODULE_VERSION_TWEAK=${PROJECT_VERSION_TWEAK}
    PROJECT_MODULE_VERSION_STRING="${PROJECT_VERSION}")
IF(CMAKE_BUILD_TYPE STREQUAL "Debug")
    ADD_COMPILE_DEFINITIONS(DEBUG _DEBUG)
ENDIF()
SET (CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -s")
SET (CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -s")
# The binaries find the libraries in ../lib, in the build tree and in the installation alike.
SET (CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
SET (CMAKE_INSTALL_RPATH "$ORIGIN/../lib")
FIND_PACKAGE(Threads REQUIRED)

INCLUDE_DIRECTORIES("/usr/include" "${MAIN_INCLUDES_PATH}" "${INCLUDE_OUTPUT_PATH}"
    "${MAIN_CPP_SOURCES_PATH}/library/include" "${MAIN_CPP_SOURCES_PATH}/main/include"
    "${TEST_CPP_SOURCES_PATH}/include" "${TEST_CPP_SOURCES_PATH}/library/include")
IF(WIN32)
    INCLUDE_DIRECTORIES("C:/pub/boost_1_82_0")
ENDIF()

# The sources of a module are the *.cpp files of its directory: a new class needs no edit here.
FILE(GLOB LIBRARY_SOURCES CONFIGURE_DEPENDS "${MAIN_CPP_SOURCES_PATH}/library/*.cpp")
FILE(GLOB MAIN_SOURCES    CONFIGURE_DEPENDS "${MAIN_CPP_SOURCES_PATH}/main/*.cpp")
FILE(GLOB TEST_SOURCES    CONFIGURE_DEPENDS "${TEST_CPP_SOURCES_PATH}/*.cpp" "${TEST_CPP_SOURCES_PATH}/library/*.cpp")

ADD_LIBRARY(examplestatic STATIC ${LIBRARY_SOURCES})
ADD_LIBRARY(exampleshared SHARED ${LIBRARY_SOURCES})
ADD_EXECUTABLE(example.bin ${MAIN_SOURCES})
TARGET_LINK_LIBRARIES(example.bin exampleshared Threads::Threads ${CMAKE_DL_LIBS})
ADD_EXECUTABLE(test.bin ${TEST_SOURCES})
TARGET_LINK_LIBRARIES(test.bin exampleshared Threads::Threads ${CMAKE_DL_LIBS})
ADD_DEPENDENCIES(build examplestatic exampleshared example.bin)
# The output directories may be gone after make clean; neither ar nor the linker creates one.
FOREACH(CPP_TARGET examplestatic exampleshared example.bin test.bin)
    ADD_DEPENDENCIES(${CPP_TARGET} makeDirectories)
ENDFOREACH()

ADD_CUSTOM_TARGET(includes COMMAND ${CMAKE_COMMAND} -E copy ${MAIN_INCLUDES_PATH}/Development.h ${INCLUDE_OUTPUT_PATH}/Development.h)
ADD_DEPENDENCIES(includes makeDirectories)
ADD_DEPENDENCIES(build includes)
ADD_CUSTOM_TARGET(javah echo javac -h ${MAIN_INCLUDES_PATH} ${MAIN_JAVA_SOURCES_PATH}/info/setmy/jni/example/Example.java)
ADD_CUSTOM_TARGET(cppcheck echo cppcheck -v --xml --xml-version=2 --enable=all -I ${MAIN_INCLUDES_PATH} ${SOURCES_PATH} 2> check.xml)
ADD_CUSTOM_TARGET(analysis echo cccc ${MAIN_CPP_SOURCES_PATH}/*.cpp ${MAIN_INCLUDES_PATH}/*.h)
ADD_CUSTOM_TARGET(debugging ${BINARY_OUTPUT_PATH}/debug DEPENDS test.bin)
FIND_PROGRAM(DOXYGEN_EXECUTABLE doxygen)
IF(DOXYGEN_EXECUTABLE)
    ADD_CUSTOM_TARGET(doxygen ${DOXYGEN_EXECUTABLE} WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
ELSE()
    ADD_CUSTOM_TARGET(doxygen ${CMAKE_COMMAND} -E echo "doxygen not found: no C++ API documentation")
ENDIF()
ADD_DEPENDENCIES(site doxygen)

# Unit tests, and with VERIFY_USED the integration tests and the memory checks.
# https://www.boost.org/doc/libs/1_78_0/libs/test/doc/html/boost_test/runtime_config/test_unit_filtering.html
SET (MEM_LEAK_TEST_COMMAND valgrind --error-exitcode=1 --leak-check=full --show-leak-kinds=all)
ADD_TEST(NAME data_types_test_ut COMMAND test.bin --run_test=data_types_test/ut)
ADD_TEST(NAME ut COMMAND test.bin --run_test=ut)
ADD_TEST(NAME library_ut COMMAND test.bin --run_test=library/ut)
ADD_TEST(NAME environment_variables_test COMMAND test.bin --run_test=environment_variables_test/ut)
ADD_TEST(NAME commandline_parameters_test COMMAND test.bin --run_test=commandline_parameters_test/ut)
ADD_TEST(NAME collection_test COMMAND test.bin --run_test=collection_test/ut)
ADD_TEST(NAME string_test COMMAND test.bin --run_test=string_test/ut)
ADD_TEST(NAME data_cell_test COMMAND test.bin --run_test=data_cell_test/ut)
IF(VERIFY_USED)
    ADD_TEST(NAME valgrind_data_types_test_ut COMMAND ${MEM_LEAK_TEST_COMMAND} ${BINARY_OUTPUT_PATH}/test.bin --run_test=data_types_test/ut)
    ADD_TEST(NAME it COMMAND test.bin --run_test=it)
    ADD_TEST(NAME library_it COMMAND test.bin --run_test=library/it)
    ADD_TEST(NAME environment_variables_test_it COMMAND test.bin --run_test=environment_variables_test/it)
    ADD_TEST(NAME commandline_parameters_test_it COMMAND test.bin --run_test=commandline_parameters_test/it)
    ADD_TEST(NAME collection_test_it COMMAND test.bin --run_test=collection_test/it)
    ADD_TEST(NAME string_test_it COMMAND test.bin --run_test=string_test/it)
    ADD_TEST(NAME data_cell_test_it COMMAND test.bin --run_test=data_cell_test/it)
    ADD_TEST(NAME valgrind_ut COMMAND ${MEM_LEAK_TEST_COMMAND} ${BINARY_OUTPUT_PATH}/test.bin --run_test=ut)
    ADD_TEST(NAME valgrind_library_ut COMMAND ${MEM_LEAK_TEST_COMMAND} ${BINARY_OUTPUT_PATH}/test.bin --run_test=library/ut)
    ADD_TEST(NAME valgrind_environment_variables_test COMMAND test.bin --run_test=environment_variables_test/ut)
    ADD_TEST(NAME valgrind_commandline_parameters_test COMMAND test.bin --run_test=commandline_parameters_test/ut)
    ADD_TEST(NAME valgrind_collection_test COMMAND test.bin --run_test=collection_test/ut)
    ADD_TEST(NAME valgrind_string_test COMMAND test.bin --run_test=string_test/ut)
    ADD_TEST(NAME valgrind_data_cell_test COMMAND test.bin --run_test=data_cell_test/ut)
    ADD_TEST(NAME valgrind_it COMMAND ${MEM_LEAK_TEST_COMMAND} ${BINARY_OUTPUT_PATH}/test.bin --run_test=it)
    ADD_TEST(NAME valgrind_library_it COMMAND ${MEM_LEAK_TEST_COMMAND} ${BINARY_OUTPUT_PATH}/test.bin --run_test=library/it)
    ADD_TEST(NAME valgrind_environment_variables_test_it COMMAND test.bin --run_test=environment_variables_test/it)
    ADD_TEST(NAME valgrind_commandline_parameters_test_it COMMAND test.bin --run_test=commandline_parameters_test/it)
    ADD_TEST(NAME valgrind_collection_test_it COMMAND test.bin --run_test=collection_test/it)
    ADD_TEST(NAME valgrind_string_test_it COMMAND test.bin --run_test=string_test/it)
    ADD_TEST(NAME valgrind_data_cell_test_it COMMAND test.bin --run_test=data_cell_test/it)
ENDIF()

# ---------------------------------------------------------------------------------------------
# 7. Elixir
# ---------------------------------------------------------------------------------------------

# Mix builds, mix.exs in the project root takes the name and the version from this file:
#   src/main/elixir/**/*.ex     compiled, with the hex dependencies, into
#                               lib/elixir/<project>/<application>/ebin, a directory per project
#                               so that projects can depend on different versions of a package
#   src/main/elixir/**/*.exs    scripts, into lib/elixir
#   src/main/elixir/bin/*       executables and launchers, into bin
#   src/test/elixir             ExUnit tests, one ctest test
# Without mix nothing of it is built, launchers included.
FIND_PROGRAM(MIX_EXECUTABLE mix HINTS /opt/elixir/bin)
FILE(GLOB_RECURSE ELIXIR_SOURCES CONFIGURE_DEPENDS "${MAIN_ELIXIR_SOURCES_PATH}/*.ex")
IF(MIX_EXECUTABLE AND EXISTS "${PROJECT_SOURCE_DIR}/mix.exs")
    IF(CMAKE_BUILD_TYPE STREQUAL "Release")
        SET (MIX_ENV prod)
    ELSE()
        SET (MIX_ENV dev)
    ENDIF()
    SET (MIX_BUILD_ROOT ${BUILD_TYPE_TARGET_PATH}/mix)
    SET (MIX_COMMAND ${CMAKE_COMMAND} -E env MIX_DEPS_PATH=${TARGET_PATH}/deps SMI_PROJECT_VERSION=${PROJECT_VERSION})
    SET (ELIXIR_BEAM_OUTPUT_PATH ${LIBRARY_OUTPUT_PATH}/elixir/${PROJECT_NAME})
    # The applications are copied with ebin, priv and the consolidated protocols, without the
    # build manifests; the directory is emptied first, so what is gone from the build is gone.
    ADD_CUSTOM_TARGET(buildElixir
        COMMAND ${MIX_COMMAND} MIX_ENV=${MIX_ENV} MIX_BUILD_PATH=${MIX_BUILD_ROOT}/${MIX_ENV} ${MIX_EXECUTABLE} deps.get --only ${MIX_ENV}
        COMMAND ${MIX_COMMAND} MIX_ENV=${MIX_ENV} MIX_BUILD_PATH=${MIX_BUILD_ROOT}/${MIX_ENV} ${MIX_EXECUTABLE} compile
        COMMAND ${CMAKE_COMMAND} -E rm -rf ${ELIXIR_BEAM_OUTPUT_PATH}
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${MIX_BUILD_ROOT}/${MIX_ENV}/lib ${ELIXIR_BEAM_OUTPUT_PATH}
        COMMAND sh -c "rm -rf \"$0\"/*/.mix" ${ELIXIR_BEAM_OUTPUT_PATH}
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        VERBATIM)
    ADD_DEPENDENCIES(build buildElixir)
    ADD_DEPENDENCIES(buildElixir makeDirectories)

    FILE(GLOB_RECURSE ELIXIR_SCRIPTS LIST_DIRECTORIES false CONFIGURE_DEPENDS "${MAIN_ELIXIR_SOURCES_PATH}/*.exs")
    LIST(FILTER ELIXIR_SCRIPTS EXCLUDE REGEX "^${MAIN_ELIXIR_SOURCES_PATH}/bin/")
    ADD_COPY_TARGET(buildElixirLib ${LIBRARY_OUTPUT_PATH}/elixir ${ELIXIR_SCRIPTS})
    ADD_COPY_TARGET(buildElixirScripts ${BINARY_OUTPUT_PATH} ${MAIN_ELIXIR_SOURCES_PATH}/bin/*)

    IF(IS_DIRECTORY "${TEST_ELIXIR_SOURCES_PATH}")
        ADD_TEST(NAME elixir_unit_tests
            COMMAND ${MIX_COMMAND} MIX_ENV=test MIX_BUILD_PATH=${MIX_BUILD_ROOT}/test
                sh -c "\"$0\" deps.get --only test && \"$0\" test" ${MIX_EXECUTABLE}
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
    ENDIF()
    MESSAGE("-- Elixir:               ${MIX_EXECUTABLE}, MIX_ENV ${MIX_ENV}")
ELSEIF(ELIXIR_SOURCES)
    MESSAGE(WARNING "mix not found or no mix.exs: the Elixir sources of ${MAIN_ELIXIR_SOURCES_PATH} are not built")
ENDIF()

# ---------------------------------------------------------------------------------------------
# 8. Site
# ---------------------------------------------------------------------------------------------

# src/site/markdown and src/site/resources go into doc/<project> of the package. make site builds
# target/site: the pages as HTML when pandoc is installed, beside the markdown they link with.
ADD_COPY_DIRECTORY_TARGET(buildDocMarkdown  ${DOC_OUTPUT_PATH}/${PROJECT_NAME} ${SITE_SOURCES_PATH}/markdown)
ADD_COPY_DIRECTORY_TARGET(buildDocResources ${DOC_OUTPUT_PATH}/${PROJECT_NAME} ${SITE_SOURCES_PATH}/resources)

SET (SITE_OUTPUT_PATH ${TARGET_PATH}/site)
SET (SITE_COMMANDS COMMAND ${CMAKE_COMMAND} -E rm -rf ${SITE_OUTPUT_PATH}
                   COMMAND ${CMAKE_COMMAND} -E make_directory ${SITE_OUTPUT_PATH})
FOREACH(SITE_PART resources markdown)
    IF(IS_DIRECTORY "${SITE_SOURCES_PATH}/${SITE_PART}")
        LIST(APPEND SITE_COMMANDS COMMAND ${CMAKE_COMMAND} -E copy_directory ${SITE_SOURCES_PATH}/${SITE_PART} ${SITE_OUTPUT_PATH})
    ENDIF()
ENDFOREACH()
FIND_PROGRAM(PANDOC_EXECUTABLE pandoc)
IF(PANDOC_EXECUTABLE)
    FILE(GLOB_RECURSE SITE_PAGES RELATIVE "${SITE_SOURCES_PATH}/markdown" CONFIGURE_DEPENDS "${SITE_SOURCES_PATH}/markdown/*.md")
    FOREACH(SITE_PAGE IN LISTS SITE_PAGES)
        STRING(REGEX REPLACE "\\.md$" ".html" SITE_HTML "${SITE_PAGE}")
        LIST(APPEND SITE_COMMANDS COMMAND ${PANDOC_EXECUTABLE} --standalone --from gfm --to html5
            --metadata pagetitle=${PROJECT_NAME}
            --output ${SITE_OUTPUT_PATH}/${SITE_HTML} ${SITE_SOURCES_PATH}/markdown/${SITE_PAGE})
    ENDFOREACH()
ELSE()
    LIST(APPEND SITE_COMMANDS COMMAND ${CMAKE_COMMAND} -E echo "pandoc not found: the site is the markdown of ${SITE_OUTPUT_PATH}")
ENDIF()
ADD_CUSTOM_TARGET(buildSite ${SITE_COMMANDS} VERBATIM)
ADD_DEPENDENCIES(site buildSite)

# ---------------------------------------------------------------------------------------------
# 9. Installation of the main package
# ---------------------------------------------------------------------------------------------

# What the build tree has is what is installed, whatever module put it there: no file list. The
# test binary stays out. /var is not packaged: the install scripts create /var/opt/setmy.info.
INSTALL(DIRECTORY "${BINARY_OUTPUT_PATH}/"  DESTINATION bin USE_SOURCE_PERMISSIONS OPTIONAL PATTERN "test.bin" EXCLUDE)
INSTALL(DIRECTORY "${LIBRARY_OUTPUT_PATH}/" DESTINATION lib USE_SOURCE_PERMISSIONS OPTIONAL)
INSTALL(DIRECTORY "${MAN_OUTPUT_PATH}/"     DESTINATION man OPTIONAL)
INSTALL(DIRECTORY "${ETC_OUTPUT_PATH}/"     DESTINATION etc USE_SOURCE_PERMISSIONS OPTIONAL)
INSTALL(DIRECTORY "${DOC_OUTPUT_PATH}/"     DESTINATION doc OPTIONAL)

# ---------------------------------------------------------------------------------------------
# 10. Configuration packages
# ---------------------------------------------------------------------------------------------

# Every directory src/main/config/<package> is an RPM of its own, named <package>, built by
# make package beside the main one, without a spec file:
#
#   etc/..., usr/...       every directory is installed at /, as it is; the files below etc are
#                          %config(noreplace)
#   description            first line the summary, the rest the description
#   requires, conflicts    one package per line, a version allowed: nginx >= 1.20
#   deploy-targets         where it is deployed, see section 12; every environment without it
#   pre.install.sh, post.install.sh, pre.uninstall.sh, post.uninstall.sh   the scriptlets, rpm's
#                          $1 as in src/main/sh/rpm
SET (CONFIG_PACKAGES "")
GET_SUBDIRECTORIES(CONFIG_PACKAGE_DIRECTORIES ${MAIN_CONFIG_SOURCES_PATH})
FOREACH(CONFIG_PACKAGE IN LISTS CONFIG_PACKAGE_DIRECTORIES)
    SET (CONFIG_DIRECTORY "${MAIN_CONFIG_SOURCES_PATH}/${CONFIG_PACKAGE}")
    STRING(TOUPPER "${CONFIG_PACKAGE}" CONFIG_COMPONENT)

    GET_SUBDIRECTORIES(CONFIG_TREES "${CONFIG_DIRECTORY}")
    FOREACH(CONFIG_TREE IN LISTS CONFIG_TREES)
        INSTALL(DIRECTORY "${CONFIG_DIRECTORY}/${CONFIG_TREE}" DESTINATION /
            COMPONENT ${CONFIG_PACKAGE} EXCLUDE_FROM_ALL USE_SOURCE_PERMISSIONS)
    ENDFOREACH()

    SET (CPACK_RPM_${CONFIG_COMPONENT}_PACKAGE_NAME         "${CONFIG_PACKAGE}")
    SET (CPACK_RPM_${CONFIG_COMPONENT}_FILE_NAME            "${CONFIG_PACKAGE}-${PROJECT_VERSION}.noarch.rpm")
    SET (CPACK_RPM_${CONFIG_COMPONENT}_PACKAGE_ARCHITECTURE noarch)
    # Not relocatable: the files belong where they are.
    SET (CPACK_RPM_${CONFIG_COMPONENT}_PACKAGE_PREFIX       "/")

    IF(EXISTS "${CONFIG_DIRECTORY}/description")
        FILE(STRINGS "${CONFIG_DIRECTORY}/description" CONFIG_DESCRIPTION_LINES)
        LIST(POP_FRONT CONFIG_DESCRIPTION_LINES CONFIG_SUMMARY)
        LIST(JOIN CONFIG_DESCRIPTION_LINES "\n" CONFIG_DESCRIPTION)
        SET (CPACK_RPM_${CONFIG_COMPONENT}_PACKAGE_SUMMARY     "${CONFIG_SUMMARY}")
        SET (CPACK_RPM_${CONFIG_COMPONENT}_PACKAGE_DESCRIPTION "${CONFIG_DESCRIPTION}")
    ENDIF()
    SET (CONFIG_REQUIRES "")
    FOREACH(CONFIG_RELATION REQUIRES CONFLICTS)
        STRING(TOLOWER "${CONFIG_RELATION}" CONFIG_RELATION_FILE)
        IF(EXISTS "${CONFIG_DIRECTORY}/${CONFIG_RELATION_FILE}")
            FILE(STRINGS "${CONFIG_DIRECTORY}/${CONFIG_RELATION_FILE}" CONFIG_RELATIONS REGEX "[^ \t]")
            LIST(JOIN CONFIG_RELATIONS ", " CONFIG_RELATION_TEXT)
            SET (CPACK_RPM_${CONFIG_COMPONENT}_PACKAGE_${CONFIG_RELATION} "${CONFIG_RELATION_TEXT}")
            IF(CONFIG_RELATION STREQUAL "REQUIRES")
                FOREACH(CONFIG_REQUIRE IN LISTS CONFIG_RELATIONS)
                    STRING(REGEX MATCH "^[ \t]*([^ \t]+)" CONFIG_REQUIRE "${CONFIG_REQUIRE}")
                    LIST(APPEND CONFIG_REQUIRES "${CMAKE_MATCH_1}")
                ENDFOREACH()
            ENDIF()
        ENDIF()
    ENDFOREACH()
    SET (CONFIG_REQUIRES_${CONFIG_PACKAGE} ${CONFIG_REQUIRES})
    FOREACH(CONFIG_SCRIPT pre.install:PRE_INSTALL post.install:POST_INSTALL pre.uninstall:PRE_UNINSTALL post.uninstall:POST_UNINSTALL)
        STRING(REPLACE ":" ";" CONFIG_SCRIPT "${CONFIG_SCRIPT}")
        LIST(GET CONFIG_SCRIPT 0 CONFIG_SCRIPT_FILE)
        LIST(GET CONFIG_SCRIPT 1 CONFIG_SCRIPT_KIND)
        IF(EXISTS "${CONFIG_DIRECTORY}/${CONFIG_SCRIPT_FILE}.sh")
            SET (CPACK_RPM_${CONFIG_COMPONENT}_${CONFIG_SCRIPT_KIND}_SCRIPT_FILE "${CONFIG_DIRECTORY}/${CONFIG_SCRIPT_FILE}.sh")
        ENDIF()
    ENDFOREACH()

    # The files below etc are configuration a machine may change; the installation prefix of the
    # main package is not this package's.
    SET (CONFIG_FILE_LIST "%exclude %dir /opt" "%exclude %dir ${CMAKE_INSTALL_PREFIX}")
    FILE(GLOB_RECURSE CONFIG_ETC_FILES RELATIVE "${CONFIG_DIRECTORY}" CONFIGURE_DEPENDS "${CONFIG_DIRECTORY}/etc/*")
    FOREACH(CONFIG_ETC_FILE IN LISTS CONFIG_ETC_FILES)
        LIST(APPEND CONFIG_FILE_LIST "%config(noreplace) /${CONFIG_ETC_FILE}")
    ENDFOREACH()
    SET (CPACK_RPM_${CONFIG_COMPONENT}_USER_FILELIST ${CONFIG_FILE_LIST})

    SET (CONFIG_TARGETS "")
    IF(EXISTS "${CONFIG_DIRECTORY}/deploy-targets")
        FILE(READ "${CONFIG_DIRECTORY}/deploy-targets" CONFIG_TARGETS)
        STRING(REGEX REPLACE "[ \t\r\n,]+" ";" CONFIG_TARGETS "${CONFIG_TARGETS}")
        LIST(REMOVE_ITEM CONFIG_TARGETS "")
    ENDIF()
    IF(NOT CONFIG_TARGETS)
        SET (CONFIG_TARGETS ${SMI_ENVIRONMENTS})
    ENDIF()
    SET (CONFIG_TARGETS_${CONFIG_PACKAGE} ${CONFIG_TARGETS})
    LIST(APPEND CONFIG_PACKAGES ${CONFIG_PACKAGE})
    MESSAGE("-- config package ${CONFIG_PACKAGE}: deploy to ${CONFIG_TARGETS}")
ENDFOREACH()

# Dependency order: a package after the packages of this project it requires, for the order of
# the deployment in section 12.
SET (CONFIG_UNORDERED ${CONFIG_PACKAGES})
SET (CONFIG_PACKAGES "")
WHILE(CONFIG_UNORDERED)
    SET (CONFIG_NEXT "")
    FOREACH(CONFIG_PACKAGE IN LISTS CONFIG_UNORDERED)
        SET (CONFIG_READY TRUE)
        FOREACH(CONFIG_REQUIRE IN LISTS CONFIG_REQUIRES_${CONFIG_PACKAGE})
            IF(CONFIG_REQUIRE IN_LIST CONFIG_UNORDERED AND NOT CONFIG_REQUIRE STREQUAL CONFIG_PACKAGE)
                SET (CONFIG_READY FALSE)
            ENDIF()
        ENDFOREACH()
        IF(CONFIG_READY)
            SET (CONFIG_NEXT ${CONFIG_PACKAGE})
            BREAK()
        ENDIF()
    ENDFOREACH()
    IF(NOT CONFIG_NEXT)
        MESSAGE(WARNING "Configuration packages that require each other, in the order found: ${CONFIG_UNORDERED}")
        LIST(APPEND CONFIG_PACKAGES ${CONFIG_UNORDERED})
        BREAK()
    ENDIF()
    LIST(APPEND CONFIG_PACKAGES ${CONFIG_NEXT})
    LIST(REMOVE_ITEM CONFIG_UNORDERED ${CONFIG_NEXT})
ENDWHILE()

# PLACEHOLDER-PRE-PACKAGING #

# ---------------------------------------------------------------------------------------------
# 11. Packaging
# ---------------------------------------------------------------------------------------------

# Binary packages or non-binary (scripts, Java, Python) packages.
SET (MACHINE_BINARY_PROJECT TRUE)
IF(MACHINE_BINARY_PROJECT)
    SET (ARCH_TYPE_SUFFIX "${CMAKE_SYSTEM_PROCESSOR}")
    IF(CMAKE_SYSTEM_PROCESSOR MATCHES "^(x86_64|AMD64|amd64)$")
        SET (DEBIAN_ARCH_TYPE_SUFFIX "amd64")
    ELSEIF(CMAKE_SYSTEM_PROCESSOR MATCHES "^(aarch64|arm64|ARM64)$")
        SET (DEBIAN_ARCH_TYPE_SUFFIX "arm64")
    ELSEIF(CMAKE_SYSTEM_PROCESSOR MATCHES "^i[3-6]86$")
        SET (DEBIAN_ARCH_TYPE_SUFFIX "i386")
    ENDIF()
ELSE()
    SET (ARCH_TYPE_SUFFIX "noarch")
    SET (DEBIAN_ARCH_TYPE_SUFFIX "all")
ENDIF()

# https://cmake.org/cmake/help/latest/manual/cpack-generators.7.html
SET (CPACK_PACKAGE_NAME                 "${PROJECT_NAME}")
SET (CPACK_PACKAGE_VENDOR               "${PROJECT_VENDOR}")
SET (CPACK_PACKAGE_DESCRIPTION          "${PROJECT_DESCRIPTION}")
SET (CPACK_PACKAGE_DESCRIPTION_SUMMARY  "${PROJECT_DESCRIPTION_SUMMARY}")
SET (CPACK_PACKAGE_VERSION              "${PROJECT_VERSION}")
SET (CPACK_PACKAGE_FILE_NAME            "${CPACK_PACKAGE_NAME}-${PROJECT_VERSION}.${ARCH_TYPE_SUFFIX}")
SET (CPACK_PACKAGE_VERSION_MAJOR        "${PROJECT_VERSION_MAJOR}")
SET (CPACK_PACKAGE_VERSION_MINOR        "${PROJECT_VERSION_MINOR}")
SET (CPACK_PACKAGE_VERSION_PATCH        "${PROJECT_VERSION_PATCH}")
SET (CPACK_PACKAGE_INSTALL_DIRECTORY    "${PROJECT_NAME}")
SET (CPACK_PACKAGING_INSTALL_PREFIX     ${CMAKE_INSTALL_PREFIX})
SET (CPACK_PACKAGE_RELOCATABLE          TRUE)
# Values written to CPackConfig.cmake escaped, so a description may hold quotes and the like.
SET (CPACK_VERBATIM_VARIABLES          TRUE)

# https://cmake.org/cmake/help/latest/cpack_gen/rpm.html
# One RPM per component: the main package and each configuration package. The archives below
# hold the main package only, as the configuration packages are not part of a plain install.
SET (CPACK_RPM_COMPONENT_INSTALL        ON)
SET (CPACK_COMPONENTS_GROUPING          IGNORE)
SET (CPACK_COMPONENTS_ALL               main ${CONFIG_PACKAGES})
SET (CPACK_RPM_PACKAGE_LICENSE          "${PROJECT_LICENSE}")
SET (CPACK_RPM_PACKAGE_DEBUG            true)
SET (CPACK_RPM_CHANGELOG_FILE           ${CHANGE_LOG_FILE_NAME})
# rpmbuild would rewrite the "#!/usr/bin/env <interpreter>" shebangs of the scripts.
SET (CPACK_RPM_SPEC_MORE_DEFINE         "%undefine __brp_mangle_shebangs")
SET (CPACK_RPM_MAIN_PACKAGE_NAME        "${PROJECT_NAME}")
SET (CPACK_RPM_MAIN_FILE_NAME           "${CPACK_PACKAGE_FILE_NAME}.rpm")
SET (CPACK_RPM_MAIN_PACKAGE_ARCHITECTURE ${ARCH_TYPE_SUFFIX})
SET (CPACK_RPM_MAIN_PACKAGE_SUMMARY     "${PROJECT_DESCRIPTION_SUMMARY}")
SET (CPACK_RPM_MAIN_PACKAGE_DESCRIPTION "${PROJECT_DESCRIPTION}")
SET (CPACK_RPM_MAIN_PRE_INSTALL_SCRIPT_FILE    "${RPM_INSTALL_SCRIPTS_PATH}/pre.install.sh")
SET (CPACK_RPM_MAIN_PRE_UNINSTALL_SCRIPT_FILE  "${RPM_INSTALL_SCRIPTS_PATH}/pre.uninstall.sh")
SET (CPACK_RPM_MAIN_POST_INSTALL_SCRIPT_FILE   "${RPM_INSTALL_SCRIPTS_PATH}/post.install.sh")
SET (CPACK_RPM_MAIN_POST_UNINSTALL_SCRIPT_FILE "${RPM_INSTALL_SCRIPTS_PATH}/post.uninstall.sh")

# https://cmake.org/cmake/help/latest/cpack_gen/deb.html
SET (CPACK_DEBIAN_PACKAGE_NAME          "${PROJECT_NAME}")
SET (CPACK_DEBIAN_PACKAGE_MAINTAINER    "${PROJECT_MAINTAINER}")
SET (CPACK_DEBIAN_PACKAGE_PRIORITY      "optional")
SET (CPACK_DEBIAN_PACKAGE_SECTION       "libs")
SET (CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${DEB_INSTALL_SCRIPTS_PATH}/preinst" "${DEB_INSTALL_SCRIPTS_PATH}/prerm"
                                        "${DEB_INSTALL_SCRIPTS_PATH}/postinst" "${DEB_INSTALL_SCRIPTS_PATH}/postrm")
SET (CPACK_DEBIAN_PACKAGE_CONTROL_STRICT_PERMISSION TRUE)
IF(DEBIAN_ARCH_TYPE_SUFFIX)
    SET (CPACK_DEBIAN_PACKAGE_ARCHITECTURE "${DEBIAN_ARCH_TYPE_SUFFIX}")
ENDIF()

# https://cmake.org/cmake/help/latest/cpack_gen/freebsd.html
SET (CPACK_FREEBSD_PACKAGE_NAME         "${PROJECT_NAME}")
SET (CPACK_FREEBSD_PACKAGE_COMMENT      "${PROJECT_DESCRIPTION_SUMMARY}")
SET (CPACK_FREEBSD_PACKAGE_DESCRIPTION  "${PROJECT_DESCRIPTION}")
SET (CPACK_FREEBSD_PACKAGE_WWW          "${PROJECT_WWW}")
SET (CPACK_FREEBSD_PACKAGE_LICENSE      "${PROJECT_LICENSE}")
SET (CPACK_FREEBSD_PACKAGE_MAINTAINER   "${PROJECT_MAINTAINER}")
SET (CPACK_FREEBSD_PACKAGE_ORIGIN       "misc/${PROJECT_NAME}")
SET (CPACK_FREEBSD_PACKAGE_CATEGORIES   "libs")

# https://cmake.org/cmake/help/latest/cpack_gen/dmg.html
SET (CPACK_DMG_VOLUME_NAME              "${PROJECT_NAME} Installer")
SET (CPACK_DMG_FORMAT                   "UDBZ")

SET (CPACK_GENERATOR "${DEFAULT_PACKAGES}")
IF (WIN32)
    SET (CPACK_GENERATOR "${DEFAULT_PACKAGES};NSIS")
ENDIF()
IF(DISTRIBUTION STREQUAL "RedHat")
    SET (CPACK_GENERATOR "${DEFAULT_PACKAGES};RPM")
ENDIF()
IF(DISTRIBUTION STREQUAL "Debian")
    SET (CPACK_GENERATOR "${DEFAULT_PACKAGES};DEB")
ENDIF()
IF(DISTRIBUTION STREQUAL "MacOS")
    SET (CPACK_GENERATOR "${DEFAULT_PACKAGES};DragNDrop")
ENDIF()
# include(CPack) leaves CPACK_GENERATOR holding the source package generators.
SET (PACKAGE_GENERATORS "${CPACK_GENERATOR}")

INCLUDE(CPack)

# The package files of the project and of its configuration packages, in the project directory.
SET (CLEAR_PACKAGES ${PROJECT_NAME} ${CONFIG_PACKAGES})
LIST(TRANSFORM CLEAR_PACKAGES APPEND "-[0-9]*")
ADD_CUSTOM_TARGET(clearPkg COMMAND sh -c "rm -f $@" sh ${CLEAR_PACKAGES} WORKING_DIRECTORY ${PROJECT_PATH} VERBATIM)
ADD_CUSTOM_TARGET(clear)
ADD_DEPENDENCIES(clear clearCmake clearBuild clearPkg)

# ---------------------------------------------------------------------------------------------
# 12. Deployment
# ---------------------------------------------------------------------------------------------

# The packages go to the machines of a runtime environment with smi-deploy of setmy-info-scripts,
# which uploads them and hands them to the deployment service there, setmy-info-deploy.path and
# smi-incoming-deploy, which installs them:
#
#   make upload-<target>      copies the packages to the upload directory of the machines
#   make handover-<target>    moves them to the directory the deployment service watches
#   make deploy-<target>      both
#   make deploy-help          every target with its packages
#
# A target is an environment of SMI_ENVIRONMENTS, which runs all of its targets, or an environment
# with a machine role, live-fe. The main package goes to SMI_PACKAGE_DEPLOY_TARGETS, a
# configuration package to its deploy-targets. The machines are not in the repository but in the
# environment of make, the CI job: SMI_DEPLOY_<TARGET>_HOSTS, <TARGET> in capitals and - as _,
# [user@]host[:port] separated by spaces. SMI_DEPLOY_STAGE=draft hands over to incoming/draft.
# Nothing is built here and the packages go in dependency order.
SET (DEPLOY_SCRIPT "${MAIN_SH_SOURCES_PATH}/build/deploy.sh")
SET (SMI_PACKAGE_DEPLOY_TARGETS "${SMI_ENVIRONMENTS}" CACHE STRING "Deploy targets of the main package")

SET (DEPLOY_TARGETS "")
SET (DEPLOY_PACKAGES "")
IF("RPM" IN_LIST PACKAGE_GENERATORS)
    SET (DEPLOY_FILE "${PROJECT_PATH}/${CPACK_RPM_MAIN_FILE_NAME}")
    LIST(APPEND DEPLOY_PACKAGES "${DEPLOY_FILE}")
    SET (DEPLOY_PACKAGE_TARGETS_${DEPLOY_FILE} ${SMI_PACKAGE_DEPLOY_TARGETS})
    FOREACH(CONFIG_PACKAGE IN LISTS CONFIG_PACKAGES)
        STRING(TOUPPER "${CONFIG_PACKAGE}" CONFIG_COMPONENT)
        SET (DEPLOY_FILE "${PROJECT_PATH}/${CPACK_RPM_${CONFIG_COMPONENT}_FILE_NAME}")
        LIST(APPEND DEPLOY_PACKAGES "${DEPLOY_FILE}")
        SET (DEPLOY_PACKAGE_TARGETS_${DEPLOY_FILE} ${CONFIG_TARGETS_${CONFIG_PACKAGE}})
    ENDFOREACH()
ENDIF()
FOREACH(DEPLOY_PACKAGE IN LISTS DEPLOY_PACKAGES)
    FOREACH(DEPLOY_TARGET IN LISTS DEPLOY_PACKAGE_TARGETS_${DEPLOY_PACKAGE})
        STRING(REGEX MATCH "^[a-z0-9]+" DEPLOY_ENVIRONMENT "${DEPLOY_TARGET}")
        IF(NOT DEPLOY_TARGET MATCHES "^[a-z0-9]+(-[a-z0-9]+)*$" OR NOT DEPLOY_ENVIRONMENT IN_LIST SMI_ENVIRONMENTS)
            MESSAGE(FATAL_ERROR "Deploy target '${DEPLOY_TARGET}' of ${DEPLOY_PACKAGE} is not <environment>[-<role>] of ${SMI_ENVIRONMENTS}")
        ENDIF()
        LIST(APPEND DEPLOY_TARGETS ${DEPLOY_TARGET})
        LIST(APPEND DEPLOY_PACKAGES_${DEPLOY_TARGET} ${DEPLOY_PACKAGE})
    ENDFOREACH()
ENDFOREACH()
LIST(REMOVE_DUPLICATES DEPLOY_TARGETS)
LIST(SORT DEPLOY_TARGETS)

SET (DEPLOY_HELP COMMAND ${CMAKE_COMMAND} -E echo "make upload|handover|deploy-<target>, SMI_DEPLOY_STAGE=draft for the draft directory:")
FOREACH(DEPLOY_ACTION upload handover deploy)
    FOREACH(DEPLOY_ENVIRONMENT IN LISTS SMI_ENVIRONMENTS)
        SET (DEPLOY_ENVIRONMENT_COMMANDS "")
        FOREACH(DEPLOY_TARGET IN LISTS DEPLOY_TARGETS)
            IF(DEPLOY_TARGET STREQUAL DEPLOY_ENVIRONMENT OR DEPLOY_TARGET MATCHES "^${DEPLOY_ENVIRONMENT}-")
                STRING(TOUPPER "${DEPLOY_TARGET}" DEPLOY_NAME)
                STRING(REPLACE "-" "_" DEPLOY_NAME "${DEPLOY_NAME}")
                SET (DEPLOY_COMMAND COMMAND sh ${DEPLOY_SCRIPT} ${DEPLOY_ACTION} ${DEPLOY_TARGET}
                    "--hosts=${SMI_DEPLOY_${DEPLOY_NAME}_HOSTS}" "--var=${SMI_RUNTIME_VAR_PATH}"
                    ${DEPLOY_PACKAGES_${DEPLOY_TARGET}})
                IF(DEPLOY_TARGET STREQUAL DEPLOY_ENVIRONMENT)
                    LIST(PREPEND DEPLOY_ENVIRONMENT_COMMANDS ${DEPLOY_COMMAND})
                ELSE()
                    LIST(APPEND DEPLOY_ENVIRONMENT_COMMANDS ${DEPLOY_COMMAND})
                    ADD_CUSTOM_TARGET(${DEPLOY_ACTION}-${DEPLOY_TARGET} ${DEPLOY_COMMAND} VERBATIM)
                ENDIF()
                IF(DEPLOY_ACTION STREQUAL "deploy")
                    LIST(APPEND DEPLOY_HELP COMMAND ${CMAKE_COMMAND} -E echo "  ${DEPLOY_TARGET}: SMI_DEPLOY_${DEPLOY_NAME}_HOSTS")
                    FOREACH(DEPLOY_PACKAGE IN LISTS DEPLOY_PACKAGES_${DEPLOY_TARGET})
                        GET_FILENAME_COMPONENT(DEPLOY_PACKAGE_NAME "${DEPLOY_PACKAGE}" NAME)
                        LIST(APPEND DEPLOY_HELP COMMAND ${CMAKE_COMMAND} -E echo "      ${DEPLOY_PACKAGE_NAME}")
                    ENDFOREACH()
                ENDIF()
            ENDIF()
        ENDFOREACH()
        IF(NOT DEPLOY_ENVIRONMENT_COMMANDS)
            SET (DEPLOY_ENVIRONMENT_COMMANDS COMMAND ${CMAKE_COMMAND} -E echo "Nothing to ${DEPLOY_ACTION} to ${DEPLOY_ENVIRONMENT}")
        ENDIF()
        ADD_CUSTOM_TARGET(${DEPLOY_ACTION}-${DEPLOY_ENVIRONMENT} ${DEPLOY_ENVIRONMENT_COMMANDS} VERBATIM)
    ENDFOREACH()
ENDFOREACH()
ADD_CUSTOM_TARGET(deploy-help ${DEPLOY_HELP} VERBATIM)

# PLACEHOLDER-END #
