# PLACEHOLDER-BEGIN #
MESSAGE("-- cpp targets.cmake")

ADD_CUSTOM_TARGET(cppcheck    echo cppcheck -v --xml --xml-version=2 --enable=all -I ${PROJECT_SOURCE_DIR}/include ${PROJECT_SOURCE_DIR}/src 2> check.xml WORKING_DIRECTORY ./)
ADD_CUSTOM_TARGET(debugging   ./debug DEPENDS test.bin WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
# API documentation into target/doxygen, part of make site when doxygen is installed.
FIND_PROGRAM(DOXYGEN_EXECUTABLE doxygen)
IF(DOXYGEN_EXECUTABLE)
    ADD_CUSTOM_TARGET(doxygen     ${DOXYGEN_EXECUTABLE} WORKING_DIRECTORY ${PROJECT_PATH})
ELSE()
    ADD_CUSTOM_TARGET(doxygen     ${CMAKE_COMMAND} -E echo "doxygen not found: no C++ API documentation")
ENDIF()

# PLACEHOLDER-END #
