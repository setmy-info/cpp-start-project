# PLACEHOLDER-BEGIN #
MESSAGE("-- cpp targets.cmake")

ADD_CUSTOM_TARGET(cppcheck    echo cppcheck -v --xml --xml-version=2 --enable=all -I ${PROJECT_SOURCE_DIR}/include ${PROJECT_SOURCE_DIR}/src 2> check.xml WORKING_DIRECTORY ./)
ADD_CUSTOM_TARGET(debugging   ./debug DEPENDS test.bin WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
ADD_CUSTOM_TARGET(doxygen     doxygen)

# PLACEHOLDER-END #
