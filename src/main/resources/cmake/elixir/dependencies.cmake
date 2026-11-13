# PLACEHOLDER-BEGIN #
MESSAGE("-- elixir dependencies.cmake")

ADD_DEPENDENCIES(build buildElixir buildElixirLib buildElixirMan)
ADD_DEPENDENCIES(buildElixir    makeDirectories)
ADD_DEPENDENCIES(buildElixirLib makeDirectories)
ADD_DEPENDENCIES(buildElixirMan makeDirectories)

# PLACEHOLDER-END #
