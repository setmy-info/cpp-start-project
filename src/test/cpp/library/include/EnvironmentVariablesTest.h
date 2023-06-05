#ifndef SET_MY_INFO_ENVIRONMENT_VARIABLES_TEST_H
#define	SET_MY_INFO_ENVIRONMENT_VARIABLES_TEST_H

#include "CppUnitTest.h"
#include "EnvironmentVariables.h"

using SetMyInfo::EnvironmentVariables;

BOOST_AUTO_TEST_SUITE(environment_variables_test)

    BOOST_AUTO_TEST_SUITE(ut)

        BOOST_AUTO_TEST_CASE(can_find_value) {
            EnvironmentVariables& environmentVariables = EnvironmentVariables::getInstance();
            const std::optional<std::string> path = environmentVariables.GetEnv("PATH");
            const std::string bin = "/bin";
            BOOST_CHECK(path.has_value());
            BOOST_CHECK(path.value().find(bin) != std::string::npos);
        }

        BOOST_AUTO_TEST_CASE(can_find_value_string) {
            EnvironmentVariables& environmentVariables = EnvironmentVariables::getInstance();
            const std::string path_key = "PATH";
            const std::optional<std::string> path = environmentVariables.GetEnv(path_key);
            const std::string bin = "/bin";
            BOOST_CHECK(path.has_value());
            BOOST_CHECK(path.value().find(bin) != std::string::npos);
        }

    BOOST_AUTO_TEST_SUITE_END()

    BOOST_AUTO_TEST_SUITE(it)

        BOOST_AUTO_TEST_CASE(char_lengths) {
            BOOST_CHECK_EQUAL(1, 1);
        }

    BOOST_AUTO_TEST_SUITE_END()

BOOST_AUTO_TEST_SUITE_END()

#endif // SET_MY_INFO_ENVIRONMENT_VARIABLES_TEST_H
