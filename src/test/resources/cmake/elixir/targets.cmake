# PLACEHOLDER-BEGIN #
MESSAGE("-- test elixir targets.cmake")

# The ExUnit tests of src/test/elixir as one ctest test, in the test environment of Mix and with
# its own build directory. mix test compiles what it needs; deps.get fetches what only the tests
# use.
IF(ELIXIR_BUILD_ENABLED AND IS_DIRECTORY "${TEST_ELIXIR_SOURCES_PATH}")
    ADD_TEST(NAME elixir_unit_tests
        COMMAND ${MIX_COMMAND_ENVIRONMENT} MIX_ENV=test MIX_BUILD_PATH=${MIX_BUILD_ROOT}/test
            sh -c "\"${MIX_EXECUTABLE}\" deps.get --only test && \"${MIX_EXECUTABLE}\" test"
        WORKING_DIRECTORY ${PROJECT_PATH})
ENDIF()

# PLACEHOLDER-END #
