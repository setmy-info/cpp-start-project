#ifndef SET_MY_INFO_STRING_TEST_H
#define SET_MY_INFO_STRING_TEST_H

#include "CppUnitTest.h"
#include "String.h"

#include <string>
#include <vector>

using namespace set_my_info::string::operations;

BOOST_AUTO_TEST_SUITE(string_test)

    BOOST_AUTO_TEST_SUITE(ut)

        BOOST_AUTO_TEST_CASE(trim_test) {
            const std::string result = Trim("  \t \n \r Hola  \t \n \r  ");
            const std::string expected = "Hola";
            BOOST_CHECK_EQUAL(result, expected);
        }

        BOOST_AUTO_TEST_CASE(split_and_trim_test) {
            const std::string parseable = " asdfg , bsg, csdg  , dsg  ";
            const std::vector<std::string> result = SplitAndTrim(parseable);
            BOOST_CHECK_EQUAL(result.size(), 4);
            BOOST_CHECK_EQUAL(result.at(0), "asdfg");
            BOOST_CHECK_EQUAL(result.at(1), "bsg");
            BOOST_CHECK_EQUAL(result.at(2), "csdg");
            BOOST_CHECK_EQUAL(result.at(3), "dsg");
        }

    BOOST_AUTO_TEST_SUITE_END()

    BOOST_AUTO_TEST_SUITE(it)

        BOOST_AUTO_TEST_CASE(abc_lengths) {
            BOOST_CHECK_EQUAL(1, 1);
        }

    BOOST_AUTO_TEST_SUITE_END()

BOOST_AUTO_TEST_SUITE_END()

#endif // SET_MY_INFO_STRING_TEST_H
