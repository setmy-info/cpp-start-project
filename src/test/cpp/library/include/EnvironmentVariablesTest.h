#ifndef SET_MY_INFO_ENVIRONMENT_VARIABLES_TEST_H
#define    SET_MY_INFO_ENVIRONMENT_VARIABLES_TEST_H

#include "CppUnitTest.h"
#include "EnvironmentVariables.h"

using set_my_info::EnvironmentVariables;

BOOST_AUTO_TEST_SUITE(environment_variables_test)

    BOOST_AUTO_TEST_SUITE(ut)

        BOOST_AUTO_TEST_CASE(can_find_value) {
            EnvironmentVariables &environmentVariables = EnvironmentVariables::GetInstance();
            const std::optional<std::string> path = environmentVariables.GetEnv("PATH");
            const std::string bin = "/bin";
            BOOST_CHECK(path.has_value());
            BOOST_CHECK(path.value().find(bin) != std::string::npos);
        }

        BOOST_AUTO_TEST_CASE(can_find_value_string) {
            EnvironmentVariables &environmentVariables = EnvironmentVariables::GetInstance();
            const std::string path_key = "PATH";
            const std::optional<std::string> path = environmentVariables.GetEnv(path_key);
            const std::string bin = "/bin";
            BOOST_CHECK(path.has_value());
            BOOST_CHECK(path.value().find(bin) != std::string::npos);
        }

        BOOST_AUTO_TEST_CASE(non_existing_variable) {
            EnvironmentVariables &environmentVariables = EnvironmentVariables::GetInstance();
            const std::string path_key = "NON_EXISTING_ENV_VARIABLE";
            const std::optional<std::string> path = environmentVariables.GetEnv(path_key);
            BOOST_CHECK(!path.has_value());
        }

        BOOST_AUTO_TEST_CASE(null_argument_accepting) {
            EnvironmentVariables &environmentVariables = EnvironmentVariables::GetInstance();
            const char *path_key = nullptr;
            const std::optional<std::string> path = environmentVariables.GetEnv(path_key);
            BOOST_CHECK(!path.has_value());
        }

    BOOST_AUTO_TEST_SUITE_END()

    BOOST_AUTO_TEST_SUITE(it)

        BOOST_AUTO_TEST_CASE(char_lengths) {
            BOOST_CHECK_EQUAL(1, 1);
        }

    BOOST_AUTO_TEST_SUITE_END()

BOOST_AUTO_TEST_SUITE_END()

#endif // SET_MY_INFO_ENVIRONMENT_VARIABLES_TEST_H
