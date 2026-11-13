# PLACEHOLDER-BEGIN #
MESSAGE("-- rpm dependencies.cmake")

# make all builds the RPMs of every module.
IF(RPM_MODULE_TARGETS)
    ADD_DEPENDENCIES(buildRpms ${RPM_MODULE_TARGETS})
ENDIF()
ADD_DEPENDENCIES(build buildRpms)

# PLACEHOLDER-END #
