# PLACEHOLDER-BEGIN #
MESSAGE("-- elixir targets.cmake")

# Compiles with Mix, which knows what changed, and copies the applications, the project's and its
# dependencies', into ELIXIR_BEAM_OUTPUT_PATH.
IF(ELIXIR_BUILD_ENABLED)
    ADD_CUSTOM_TARGET(buildElixir
        COMMAND ${MIX_COMMAND_ENVIRONMENT} MIX_ENV=${MIX_ENV} MIX_BUILD_PATH=${MIX_BUILD_ROOT}/${MIX_ENV}
            ${MIX_EXECUTABLE} deps.get --only ${MIX_ENV}
        COMMAND ${MIX_COMMAND_ENVIRONMENT} MIX_ENV=${MIX_ENV} MIX_BUILD_PATH=${MIX_BUILD_ROOT}/${MIX_ENV}
            ${MIX_EXECUTABLE} compile
        COMMAND ${CMAKE_COMMAND} -DSOURCE=${MIX_BUILD_ROOT}/${MIX_ENV}/lib -DDESTINATION=${ELIXIR_BEAM_OUTPUT_PATH}
            -P ${MAIN_CMAKE_PATH}/elixir/elixir-copy.cmake
        WORKING_DIRECTORY ${PROJECT_PATH}
        VERBATIM)
ELSE()
    ADD_CUSTOM_TARGET(buildElixir)
ENDIF()

# Scripts: every *.exs of src/main/elixir but the executable ones of bin, which targets.cmake of
# the project copies into bin.
FILE(GLOB_RECURSE ELIXIR_SCRIPTS LIST_DIRECTORIES false CONFIGURE_DEPENDS "${MAIN_ELIXIR_SOURCES_PATH}/*.exs")
LIST(FILTER ELIXIR_SCRIPTS EXCLUDE REGEX "^${MAIN_ELIXIR_SOURCES_PATH}/bin/")
ADD_COPY_TARGET(buildElixirLib ${LIBRARY_OUTPUT_PATH}/elixir ${ELIXIR_SCRIPTS})

ADD_MAN_TARGET(buildElixirMan ${ELIXIR_MAN_SOURCES_PATH} 1 2 3 4 5 6 7 8 9)

# PLACEHOLDER-END #
