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

enable_testing()

# The build definition is the templates src/main/resources/cmake/**/*.cmake.in and
# src/test/resources/cmake/**/*.cmake.in. Every configure generates the .cmake files from them into
# target/cmake, in the same tree as under src, and only the generated files are included: no
# .cmake file is in git. A generated file whose template is gone is removed, so a deleted module
# is gone from the build as well. CONFIGURE_DEPENDS and the configure_file dependencies make the
# build configure again when a template is added, changed or removed.
SET (SMI_GENERATED_CMAKE_PATH ${PROJECT_BINARY_DIR}/target/cmake)
FILE(GLOB_RECURSE SMI_CMAKE_TEMPLATES RELATIVE ${PROJECT_SOURCE_DIR} CONFIGURE_DEPENDS
    ${PROJECT_SOURCE_DIR}/src/main/resources/cmake/*.cmake.in
    ${PROJECT_SOURCE_DIR}/src/test/resources/cmake/*.cmake.in)
SET (SMI_GENERATED_CMAKE_FILES "")
FOREACH(SMI_CMAKE_TEMPLATE IN LISTS SMI_CMAKE_TEMPLATES)
    STRING(REGEX REPLACE "\\.in$" "" SMI_CMAKE_FILE "${SMI_CMAKE_TEMPLATE}")
    CONFIGURE_FILE(${PROJECT_SOURCE_DIR}/${SMI_CMAKE_TEMPLATE} ${SMI_GENERATED_CMAKE_PATH}/${SMI_CMAKE_FILE} COPYONLY)
    LIST(APPEND SMI_GENERATED_CMAKE_FILES ${SMI_GENERATED_CMAKE_PATH}/${SMI_CMAKE_FILE})
ENDFOREACH()
FILE(GLOB_RECURSE SMI_EXISTING_CMAKE_FILES ${SMI_GENERATED_CMAKE_PATH}/src/*.cmake)
FOREACH(SMI_EXISTING_CMAKE_FILE IN LISTS SMI_EXISTING_CMAKE_FILES)
    IF(NOT SMI_EXISTING_CMAKE_FILE IN_LIST SMI_GENERATED_CMAKE_FILES)
        FILE(REMOVE ${SMI_EXISTING_CMAKE_FILE})
    ENDIF()
ENDFOREACH()

INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/main/resources/cmake/functions.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/test/resources/cmake/functions.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/main/resources/cmake/variables.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/test/resources/cmake/variables.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/main/resources/cmake/sources.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/test/resources/cmake/sources.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/main/resources/cmake/targets.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/test/resources/cmake/targets.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/main/resources/cmake/dependencies.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/test/resources/cmake/dependencies.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/main/resources/cmake/configure.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/test/resources/cmake/configure.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/main/resources/cmake/lib.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/test/resources/cmake/lib.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/main/resources/cmake/bin.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/test/resources/cmake/bin.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/main/resources/cmake/man.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/test/resources/cmake/man.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/main/resources/cmake/etc.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/test/resources/cmake/etc.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/main/resources/cmake/var.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/test/resources/cmake/var.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/main/resources/cmake/site.cmake)

# PLACEHOLDER-PRE-PACKAGING #

INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/main/resources/cmake/packaging.cmake)
INCLUDE(${SMI_GENERATED_CMAKE_PATH}/src/main/resources/cmake/deploy.cmake)

# PLACEHOLDER-END #
