#ifndef SET_MY_INFO_ENVIRONMENT_VARIABLES_TEST_H
#define	SET_MY_INFO_ENVIRONMENT_VARIABLES_TEST_H

#include "CppUnitTest.h"
#include "EnvironmentVariables.h"

BOOST_AUTO_TEST_SUITE(environment_variables_test)

    BOOST_AUTO_TEST_SUITE(ut)

        BOOST_AUTO_TEST_CASE(char_lengths) {
            BOOST_CHECK_EQUAL(1, 1);
        }

    BOOST_AUTO_TEST_SUITE_END()

    BOOST_AUTO_TEST_SUITE(it)

        BOOST_AUTO_TEST_CASE(char_lengths) {
            BOOST_CHECK_EQUAL(1, 1);
        }

    BOOST_AUTO_TEST_SUITE_END()

BOOST_AUTO_TEST_SUITE_END()

#endif // SET_MY_INFO_ENVIRONMENT_VARIABLES_TEST_H
