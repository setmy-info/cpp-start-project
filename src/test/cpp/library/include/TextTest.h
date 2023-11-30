#ifndef SET_MY_INFO_TEXT_TEST_H
#define SET_MY_INFO_TEXT_TEST_H

#include "CppUnitTest.h"
#include "Text.h"
#include "Macros.h"

#include <string>
#include <vector>

using namespace set_my_info::text::operations;
using namespace set_my_info;

BOOST_AUTO_TEST_SUITE(string_test)

    BOOST_AUTO_TEST_SUITE(ut)

        BOOST_AUTO_TEST_CASE(ToString_test) {
            const std::string result = ToString(0);
            const std::string expected = "";
            BOOST_CHECK_EQUAL(result, expected);
            const std::string result2 = ToString(nullptr);
            const std::string expected2 = "";
            BOOST_CHECK_EQUAL(result2, expected2);
            const char *str = "Hello";
            const std::string result3 = ToString(str);
            const std::string expected3 = "Hello";
            BOOST_CHECK_EQUAL(result3, expected3);
        }

        BOOST_AUTO_TEST_CASE(RemoveAllWhitespace_test) {
            const std::string result = RemoveAllWhitespace("  \t \n \r Hola  \t \n \r  ");
            const std::string expected = "Hola";
            BOOST_CHECK_EQUAL(result, expected);
            const std::string result2 = RemoveAllWhitespace("  \t \n \r Ho la  \t \n \r  ");
            const std::string expected2 = "Hola";
            BOOST_CHECK_EQUAL(result2, expected2);
        }

        BOOST_AUTO_TEST_CASE(ToLowerCase_test) {
            const std::string result = ToLowerCase("  \t \n \r HoLa  \t \n \r  ");
            const std::string expected = "  \t \n \r hola  \t \n \r  ";
            BOOST_CHECK_EQUAL(result, expected);
        }

        BOOST_AUTO_TEST_CASE(ToUpperCase_test) {
            const std::string result = ToUpperCase("  \t \n \r HoLa  \t \n \r  ");
            const std::string expected = "  \t \n \r HOLA  \t \n \r  ";
            BOOST_CHECK_EQUAL(result, expected);
        }

        BOOST_AUTO_TEST_CASE(trim_test) {
            const std::string result = Trim("  \t \n \r Hola  \t \n \r  ");
            const std::string expected = "Hola";
            BOOST_CHECK_EQUAL(result, expected);
            const std::string result2 = Trim("  \t \n \r Ho la  \t \n \r  ");
            const std::string expected2 = "Ho la";
            BOOST_CHECK_EQUAL(result2, expected2);
        }

        BOOST_AUTO_TEST_CASE(split_and_trim_test) {
            const std::string parseable = " asd fg , bsg, cs dg  , dsg  ";
            const std::vector<std::string> result = SplitAndTrim(parseable);
            BOOST_CHECK_EQUAL(result.size(), 4);
            BOOST_CHECK_EQUAL(result.at(0), "asd fg");
            BOOST_CHECK_EQUAL(result.at(1), "bsg");
            BOOST_CHECK_EQUAL(result.at(2), "cs dg");
            BOOST_CHECK_EQUAL(result.at(3), "dsg");
        }

        BOOST_AUTO_TEST_CASE(trim_list_test) {
            const std::vector<std::string> textLists = {"a  ", " b ", "  c  ", "   d"};
            const std::vector<std::string> result = TrimList(textLists);
            BOOST_CHECK_EQUAL(result.size(), 4);
            BOOST_CHECK_EQUAL(result.at(0), "a");
            BOOST_CHECK_EQUAL(result.at(1), "b");
            BOOST_CHECK_EQUAL(result.at(2), "c");
            BOOST_CHECK_EQUAL(result.at(3), "d");
        }

        BOOST_AUTO_TEST_CASE(ToBoolean_test) {
            BOOST_CHECK_EQUAL(ToBoolean(""), false);
            BOOST_CHECK_EQUAL(ToBoolean("", false), false);
            BOOST_CHECK_EQUAL(ToBoolean("", true), true);
            BOOST_CHECK_EQUAL(ToBoolean("False"), false);
            BOOST_CHECK_EQUAL(ToBoolean("False", true), false);
            BOOST_CHECK_EQUAL(ToBoolean("True"), true);
            BOOST_CHECK_EQUAL(ToBoolean("True", false), true);
            BOOST_CHECK_EQUAL(ToBoolean("yEs"), true);
            BOOST_CHECK_EQUAL(ToBoolean("nO"), false);
        }

        BOOST_AUTO_TEST_CASE(ToShort_test) {
            BOOST_CHECK_EQUAL(ToShort(""), 0);
            BOOST_CHECK_EQUAL(ToShort("", 1), 1);
            BOOST_CHECK_EQUAL(ToShort("-123"), -123);
            BOOST_CHECK_EQUAL(ToShort("- 123", 1), -123);
            BOOST_CHECK_EQUAL(ToShort("123"), 123);
            BOOST_CHECK_EQUAL(ToShort(" 123 "), 123);
            try {
                ToShort("1000000");
                BOOST_FAIL("Exception not thrown");
            } catch (const std::invalid_argument &ex) {
                BOOST_CHECK_EQUAL(ex.what(), "Invalid short value");
            }
            try {
                ToShort("-1000000");
                BOOST_FAIL("Exception not thrown");
            } catch (const std::invalid_argument &ex) {
                BOOST_CHECK_EQUAL(ex.what(), "Invalid short value");
            }
        }

        BOOST_AUTO_TEST_CASE(ToUnsignedShort_test) {
            BOOST_CHECK_EQUAL(ToUnsignedShort(""), 0);
            BOOST_CHECK_EQUAL(ToUnsignedShort("", 1), 1);
            BOOST_CHECK_EQUAL(ToUnsignedShort("123"), 123);
            BOOST_CHECK_EQUAL(ToUnsignedShort(" 123 "), 123);

            try {
                ToUnsignedShort("- 123");
                BOOST_FAIL("Exception not thrown");
            } catch (const std::out_of_range &ex) {
                BOOST_CHECK_EQUAL(ex.what(), "Value out of range for unsigned short");
            }
            try {
                ToUnsignedShort("-123");
                BOOST_FAIL("Exception not thrown");
            } catch (const std::out_of_range &ex) {
                BOOST_CHECK_EQUAL(ex.what(), "Value out of range for unsigned short");
            }
            try {
                ToUnsignedShort("1000000");
                BOOST_FAIL("Exception not thrown");
            } catch (const std::out_of_range &ex) {
                BOOST_CHECK_EQUAL(ex.what(), "Value out of range for unsigned short");
            }
        }

    BOOST_AUTO_TEST_SUITE_END()

    BOOST_AUTO_TEST_SUITE(it)

        BOOST_AUTO_TEST_CASE(abc_lengths) {
            BOOST_CHECK_EQUAL(1, 1);
        }

    BOOST_AUTO_TEST_SUITE_END()

BOOST_AUTO_TEST_SUITE_END()

#endif // SET_MY_INFO_TEXT_TEST_H
