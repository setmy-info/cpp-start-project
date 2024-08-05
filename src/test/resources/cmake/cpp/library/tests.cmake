# https://www.boost.org/doc/libs/1_78_0/libs/test/doc/html/boost_test/runtime_config/test_unit_filtering.html

# Unit test section
ADD_TEST(NAME ut COMMAND test.bin --run_test=ut)
ADD_TEST(NAME library_ut COMMAND test.bin --run_test=library/ut)
ADD_TEST(NAME environment_variables_test COMMAND test.bin --run_test=environment_variables_test/ut)
ADD_TEST(NAME commandline_parameters_test COMMAND test.bin --run_test=commandline_parameters_test/ut)
ADD_TEST(NAME collection_test COMMAND test.bin --run_test=collection_test/ut)
ADD_TEST(NAME string_test COMMAND test.bin --run_test=string_test/ut)
ADD_TEST(NAME data_cell_test COMMAND test.bin --run_test=data_cell_test/ut)

IF(VERIFY_USED)
# Integration test section
ADD_TEST(NAME it COMMAND test.bin --run_test=it)
ADD_TEST(NAME library_it COMMAND test.bin --run_test=library/it)
ADD_TEST(NAME environment_variables_test_it COMMAND test.bin --run_test=environment_variables_test/it)
ADD_TEST(NAME commandline_parameters_test_it COMMAND test.bin --run_test=commandline_parameters_test/it)
ADD_TEST(NAME collection_test_it COMMAND test.bin --run_test=collection_test/it)
ADD_TEST(NAME string_test_it COMMAND test.bin --run_test=string_test/it)
ADD_TEST(NAME data_cell_test_it COMMAND test.bin --run_test=data_cell_test/it)

# Unit test valgrind section
ADD_TEST(NAME valgrind_ut COMMAND ${MEM_LEAK_TEST_COMMAND} ${BINARY_OUTPUT_PATH}/test.bin --run_test=ut)
ADD_TEST(NAME valgrind_library_ut COMMAND ${MEM_LEAK_TEST_COMMAND} ${BINARY_OUTPUT_PATH}/test.bin --run_test=library/ut)
ADD_TEST(NAME valgrind_environment_variables_test COMMAND test.bin --run_test=environment_variables_test/ut)
ADD_TEST(NAME valgrind_commandline_parameters_test COMMAND test.bin --run_test=commandline_parameters_test/ut)
ADD_TEST(NAME valgrind_collection_test COMMAND test.bin --run_test=collection_test/ut)
ADD_TEST(NAME valgrind_string_test COMMAND test.bin --run_test=string_test/ut)
ADD_TEST(NAME valgrind_data_cell_test COMMAND test.bin --run_test=data_cell_test/ut)

# Integration test valgrind section
ADD_TEST(NAME valgrind_it COMMAND ${MEM_LEAK_TEST_COMMAND} ${BINARY_OUTPUT_PATH}/test.bin --run_test=it)
ADD_TEST(NAME valgrind_library_it COMMAND ${MEM_LEAK_TEST_COMMAND} ${BINARY_OUTPUT_PATH}/test.bin --run_test=library/it)
ADD_TEST(NAME valgrind_environment_variables_test_it COMMAND test.bin --run_test=environment_variables_test/it)
ADD_TEST(NAME valgrind_commandline_parameters_test_it COMMAND test.bin --run_test=commandline_parameters_test/it)
ADD_TEST(NAME valgrind_collection_test_it COMMAND test.bin --run_test=collection_test/it)
ADD_TEST(NAME valgrind_string_test_it COMMAND test.bin --run_test=string_test/it)
ADD_TEST(NAME valgrind_data_cell_test_it COMMAND test.bin --run_test=data_cell_test/it)
ENDIF()
