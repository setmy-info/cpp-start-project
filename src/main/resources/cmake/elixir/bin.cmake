# PLACEHOLDER-BEGIN #
MESSAGE("-- elixir bin.cmake")

INSTALL(PROGRAMS "${BINARY_OUTPUT_PATH}/smi-example-exs" DESTINATION bin)
# A launcher only with what it launches.
IF(ELIXIR_BUILD_ENABLED)
    INSTALL(PROGRAMS "${BINARY_OUTPUT_PATH}/smi-example-elixir" DESTINATION bin)
ENDIF()

# PLACEHOLDER-END #
