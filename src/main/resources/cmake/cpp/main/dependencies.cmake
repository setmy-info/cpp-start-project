# PLACEHOLDER-BEGIN #
MESSAGE("-- main dependencies.cmake")

ADD_DEPENDENCIES(example.bin    buildMan)
ADD_DEPENDENCIES(example.bin    exampleshared)
ADD_DEPENDENCIES(example.bin    examplestatic)

# PLACEHOLDER-END #