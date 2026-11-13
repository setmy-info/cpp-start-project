# PLACEHOLDER-BEGIN #
MESSAGE("-- cpp dependencies.cmake")

ADD_DEPENDENCIES(build    includes)
ADD_DEPENDENCIES(includes makeDirectories)
ADD_DEPENDENCIES(site     doxygen)

# PLACEHOLDER-END #
