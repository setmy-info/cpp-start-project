# PLACEHOLDER-BEGIN #
MESSAGE("-- dependencies.cmake")

SET (SCRIPT_LANGUAGE_TARGETS
    buildCmdScripts     buildCmdLib
    buildGroovyScripts  buildGroovyLib
    buildPythonScripts  buildPythonLib
    buildCLScripts      buildCLLib
    buildElixirScripts  buildElixirLib
    buildErlangScripts  buildErlangLib)
ADD_DEPENDENCIES(build ${SCRIPT_LANGUAGE_TARGETS})
FOREACH(SCRIPT_LANGUAGE_TARGET IN LISTS SCRIPT_LANGUAGE_TARGETS)
    ADD_DEPENDENCIES(${SCRIPT_LANGUAGE_TARGET} makeDirectories)
ENDFOREACH()
ADD_DEPENDENCIES(clear clearCmake clearBuild clearPkg)

INCLUDE_LANGUAGES_CMAKE_FILES(${MAIN_CMAKE_PATH} dependencies)

# PLACEHOLDER-END #
