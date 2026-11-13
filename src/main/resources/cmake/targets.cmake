# PLACEHOLDER-BEGIN #
MESSAGE("-- targets.cmake")

SET (CMAKE_VERBOSE_MAKEFILE TRUE)

ADD_CUSTOM_TARGET(build ALL)
ADD_CUSTOM_TARGET(clear)

# Interpreted languages, the same way for each: src/main/<language>/bin/* goes to bin and the
# content of src/main/<language>/lib to lib. A target of a language without sources does nothing,
# so a project adds a language by adding its directory.
ADD_COPY_TARGET(buildCmdScripts               ${BINARY_OUTPUT_PATH}  ${MAIN_CMD_SOURCES_PATH}/bin/*)
ADD_COPY_DIRECTORY_TARGET(buildCmdLib         ${LIBRARY_OUTPUT_PATH} ${MAIN_CMD_SOURCES_PATH}/lib)
ADD_COPY_TARGET(buildGroovyScripts            ${BINARY_OUTPUT_PATH}  ${MAIN_GROOVY_SOURCES_PATH}/bin/*)
ADD_COPY_DIRECTORY_TARGET(buildGroovyLib      ${LIBRARY_OUTPUT_PATH} ${MAIN_GROOVY_SOURCES_PATH}/lib)
ADD_COPY_TARGET(buildPythonScripts            ${BINARY_OUTPUT_PATH}  ${MAIN_PYTHON_SOURCES_PATH}/bin/*)
ADD_COPY_DIRECTORY_TARGET(buildPythonLib      ${LIBRARY_OUTPUT_PATH} ${MAIN_PYTHON_SOURCES_PATH}/lib)
ADD_COPY_TARGET(buildCLScripts                ${BINARY_OUTPUT_PATH}  ${MAIN_COMMON_LISP_SOURCES_PATH}/bin/*)
ADD_COPY_DIRECTORY_TARGET(buildCLLib          ${LIBRARY_OUTPUT_PATH} ${MAIN_COMMON_LISP_SOURCES_PATH}/lib)
# Elixir: executable scripts here, the rest of src/main/elixir is the elixir language of cmake.
ADD_COPY_TARGET(buildElixirScripts            ${BINARY_OUTPUT_PATH}  ${MAIN_ELIXIR_SOURCES_PATH}/bin/*)
ADD_COPY_TARGET(buildErlangScripts            ${BINARY_OUTPUT_PATH}  ${MAIN_ERLANG_SOURCES_PATH}/bin/*)
ADD_COPY_DIRECTORY_TARGET(buildErlangLib      ${LIBRARY_OUTPUT_PATH} ${MAIN_ERLANG_SOURCES_PATH}/lib)

ADD_CUSTOM_TARGET(clearBuild          rm -rf ${TARGET_PATH})
ADD_CUSTOM_TARGET(clearPkg            rm -rf ./${PROJECT_NAME}*.tar.gz ./${PROJECT_NAME}*.rpm ./${PROJECT_NAME}*.sh ./${PROJECT_NAME}*.deb ./${PROJECT_NAME}*.tar.Z ./${PROJECT_NAME}*.7z ./${PROJECT_NAME}*.tar.bz2 ./${PROJECT_NAME}*.tar.xz ./${PROJECT_NAME}*.zip ./${PROJECT_NAME}*.dmg)
ADD_CUSTOM_TARGET(clearCmake          rm -rf ./*.cmake ./_CPack_Packages install_manifest.txt CMakeCache.txt)
ADD_CUSTOM_TARGET(site)

INCLUDE_LANGUAGES_CMAKE_FILES(${MAIN_CMAKE_PATH} targets)

# PLACEHOLDER-END #
