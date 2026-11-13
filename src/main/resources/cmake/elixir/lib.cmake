# PLACEHOLDER-BEGIN #
MESSAGE("-- elixir lib.cmake")

# The scripts and, under lib/elixir/<project>, the compiled applications. OPTIONAL: a project
# without Elixir has no such directory.
INSTALL(DIRECTORY "${LIBRARY_OUTPUT_PATH}/elixir" DESTINATION lib OPTIONAL USE_SOURCE_PERMISSIONS)

# PLACEHOLDER-END #
