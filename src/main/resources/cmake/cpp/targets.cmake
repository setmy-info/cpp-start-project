# PLACEHOLDER-BEGIN #
MESSAGE("-- cpp targets.cmake")

# Actually C++ SDK, API or similar .h files copy
ADD_CUSTOM_TARGET(includes    cp ${MAIN_INCLUDES_PATH}/Development.h ${INCLUDE_OUTPUT_PATH}/Development.h)
ADD_CUSTOM_TARGET(analysis    echo cccc ${MAIN_CPP_SOURCES_PATH}/*.cpp .${MAIN_INCLUDES_PATH}/*.h WORKING_DIRECTORY ${PROJECT_PATH})
ADD_CUSTOM_TARGET(cppcheck    echo cppcheck -v --xml --xml-version=2 --enable=all -I ${PROJECT_SOURCE_DIR}/include ${PROJECT_SOURCE_DIR}/src 2> check.xml WORKING_DIRECTORY ./)
ADD_CUSTOM_TARGET(debugging   ./debug DEPENDS test.bin WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
ADD_CUSTOM_TARGET(doxygen     doxygen)

INCLUDE_CMAKE_FILE(${MAIN_CPP_CMAKE_PATH}/javah/targets.cmake)
INCLUDE_CMAKE_FILE(${MAIN_CPP_CMAKE_PATH}/library/targets.cmake)
INCLUDE_CMAKE_FILE(${MAIN_CPP_CMAKE_PATH}/main/targets.cmake)

# PLACEHOLDER-END #
