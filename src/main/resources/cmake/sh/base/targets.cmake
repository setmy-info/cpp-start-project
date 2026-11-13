# PLACEHOLDER-BEGIN #
MESSAGE("-- base targets.cmake")

ADD_CUSTOM_TARGET(makeDirectories
    mkdir -p ${BUILD_PATH} &&
    mkdir -p ${BINARY_OUTPUT_PATH} &&
    mkdir -p ${LIBRARY_OUTPUT_PATH} &&
    mkdir -p ${MAN_OUTPUT_PATH}/man1 &&
    mkdir -p ${MAN_OUTPUT_PATH}/man2 &&
    mkdir -p ${MAN_OUTPUT_PATH}/man3 &&
    mkdir -p ${MAN_OUTPUT_PATH}/man4 &&
    mkdir -p ${MAN_OUTPUT_PATH}/man5 &&
    mkdir -p ${MAN_OUTPUT_PATH}/man6 &&
    mkdir -p ${MAN_OUTPUT_PATH}/man7 &&
    mkdir -p ${MAN_OUTPUT_PATH}/man8 &&
    mkdir -p ${MAN_OUTPUT_PATH}/man9 &&
    mkdir -p ${INFO_OUTPUT_PATH} &&
    mkdir -p ${LIBRARY_OUTPUT_PATH}/profiles &&
    mkdir -p ${LIBRARY_OUTPUT_PATH}/packages &&
    mkdir -p ${ETC_PROFILED_OUTPUT_PATH} &&
    mkdir -p ${INCLUDE_OUTPUT_PATH} &&
    mkdir -p ${ETC_SYSTEM_OUTPUT_PATH} &&
    mkdir -p ${ETC_YUM_REPOS_PATH}
)

# Each target copies what exists and does nothing otherwise, so these lines stay as they are in a
# derived project, whichever of the directories it uses.
ADD_MAN_TARGET(buildMan                           ${BASE_MAN_SOURCES_PATH} 1 2 3 4 5 6 7 8 9)
ADD_COPY_DIRECTORY_TARGET(buildEtc                ${ETC_PROFILED_OUTPUT_PATH}       ${MAIN_SH_SOURCES_PATH}/etc/profile.d)
ADD_COPY_TARGET(buildLibShells                    ${LIBRARY_OUTPUT_PATH}            ${MAIN_SH_SOURCES_PATH}/lib/*.sh ${MAIN_SH_SOURCES_PATH}/lib/*.txt)
ADD_COPY_TARGET(buildShellScripts                 ${BINARY_OUTPUT_PATH}             ${MAIN_SH_SOURCES_PATH}/bin/*)
# Units that need a path of the installation are *.in files, configured by configure.cmake.
ADD_COPY_TARGET(buildServiceScripts               ${ETC_SYSTEM_OUTPUT_PATH}
    ${MAIN_SH_SOURCES_PATH}/etc/systemd/system/*.service
    ${MAIN_SH_SOURCES_PATH}/etc/systemd/system/*.timer
    ${MAIN_SH_SOURCES_PATH}/etc/systemd/system/*.path
    ${MAIN_SH_SOURCES_PATH}/etc/systemd/system/*.socket
    ${MAIN_SH_SOURCES_PATH}/etc/systemd/system/*.target)
ADD_COPY_TARGET(buildServiceEnvironment           ${ETC_OUTPUT_PATH}                ${MAIN_SH_SOURCES_PATH}/etc/systemd/system/environment.conf)
ADD_COPY_TARGET(buildYumReposScripts              ${ETC_YUM_REPOS_PATH}             ${MAIN_SH_SOURCES_PATH}/etc/yum.repos.d/*.repo)
ADD_COPY_DIRECTORY_TARGET(buildProfiles           ${LIBRARY_OUTPUT_PATH}/profiles   ${MAIN_SH_SOURCES_PATH}/lib/profiles)
ADD_COPY_DIRECTORY_TARGET(buildPackages           ${LIBRARY_OUTPUT_PATH}/packages   ${MAIN_SH_SOURCES_PATH}/lib/packages)

# PLACEHOLDER-END #
