# PLACEHOLDER-BEGIN #
MESSAGE("-- main dependencies.cmake")

ADD_DEPENDENCIES(buildCppMainMan makeDirectories)
ADD_DEPENDENCIES(example.bin     buildCppMainMan)
ADD_DEPENDENCIES(example.bin     exampleshared)
ADD_DEPENDENCIES(example.bin     examplestatic)

# PLACEHOLDER-END #