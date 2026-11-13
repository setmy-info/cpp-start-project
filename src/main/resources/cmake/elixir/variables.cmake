# PLACEHOLDER-BEGIN #
MESSAGE("-- elixir variables.cmake")

# Elixir with Mix, mix.exs in the project root. See src/site/markdown/elixir.md.

FIND_PROGRAM(MIX_EXECUTABLE    mix    HINTS /opt/elixir/bin)
FIND_PROGRAM(ELIXIR_EXECUTABLE elixir HINTS /opt/elixir/bin)

FILE(GLOB_RECURSE ELIXIR_SOURCES CONFIGURE_DEPENDS "${MAIN_ELIXIR_SOURCES_PATH}/*.ex")
IF(MIX_EXECUTABLE AND EXISTS "${PROJECT_PATH}/mix.exs")
    SET (ELIXIR_BUILD_ENABLED TRUE)
ELSE()
    SET (ELIXIR_BUILD_ENABLED FALSE)
    IF(ELIXIR_SOURCES)
        MESSAGE(WARNING "mix not found or no mix.exs: the Elixir sources of ${MAIN_ELIXIR_SOURCES_PATH} are not built")
    ENDIF()
ENDIF()

IF(CMAKE_BUILD_TYPE STREQUAL "Release")
    SET (MIX_ENV prod)
ELSE()
    SET (MIX_ENV dev)
ENDIF()

# The application name mix.exs derives from the project name.
STRING(REGEX REPLACE "[^A-Za-z0-9_]" "_" ELIXIR_APP "${PROJECT_NAME}")

SET (MIX_BUILD_ROOT            ${BUILD_TYPE_TARGET_PATH}/mix)
SET (MIX_DEPS_PATH             ${TARGET_PATH}/deps)
# Compiled applications of this project, its own ERL_LIBS directory, so that two projects in one
# installation can depend on different versions of one package.
SET (ELIXIR_BEAM_OUTPUT_PATH   ${LIBRARY_OUTPUT_PATH}/elixir/${PROJECT_NAME})
SET (ELIXIR_MAN_SOURCES_PATH   ${MAIN_MAN_SOURCES_PATH}/elixir)

# The environment of every mix command: <command> with these in front, through cmake -E env.
SET (MIX_COMMAND_ENVIRONMENT
    ${CMAKE_COMMAND} -E env
    MIX_DEPS_PATH=${MIX_DEPS_PATH}
    SMI_PROJECT_VERSION=${PROJECT_VERSION})

MESSAGE("-- ELIXIR_BUILD_ENABLED: ${ELIXIR_BUILD_ENABLED}")
MESSAGE("-- MIX_EXECUTABLE: ${MIX_EXECUTABLE}")
MESSAGE("-- MIX_ENV: ${MIX_ENV}")
MESSAGE("-- ELIXIR_APP: ${ELIXIR_APP}")
MESSAGE("-- ELIXIR_BEAM_OUTPUT_PATH: ${ELIXIR_BEAM_OUTPUT_PATH}")

# PLACEHOLDER-END #
