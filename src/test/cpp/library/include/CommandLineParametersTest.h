#ifndef SET_MY_INFO_COMMANDLINE_PARAMETERS_TEST_H
#define SET_MY_INFO_COMMANDLINE_PARAMETERS_TEST_H

#include "CppUnitTest.h"
#include "CommandLineParameters.h"
#include "Macros.h"

using set_my_info::CommandLineParameters;

BOOST_AUTO_TEST_SUITE(commandline_parameters_test)

    BOOST_AUTO_TEST_SUITE(ut)

        BOOST_AUTO_TEST_CASE(arguments_test) {
            CommandLineParameters commandline_parameters;
            const char *arguments[] = {"programName", "abc", "def=ghi", "jkl=mno=prs"};
            BOOST_CHECK_EQUAL(ARRAY_SIZEOF(arguments), 4);
            commandline_parameters.Args(ARRAY_SIZEOF(arguments), arguments);
            std::string property_name = "abc";
            BOOST_CHECK(commandline_parameters.parameters_map_[property_name].empty());
            property_name = "def";
            std::string value = "ghi";
            BOOST_CHECK(!commandline_parameters.parameters_map_[property_name].empty());
            BOOST_CHECK_EQUAL(commandline_parameters.parameters_map_[property_name].at(0), value);

            property_name = "jkl";
            BOOST_CHECK(!commandline_parameters.parameters_map_[property_name].empty());
            value = "mno";
            BOOST_CHECK_EQUAL(commandline_parameters.parameters_map_[property_name].at(0), value);
            value = "prs";
            BOOST_CHECK_EQUAL(commandline_parameters.parameters_map_[property_name].at(1), value);
        }

    BOOST_AUTO_TEST_SUITE_END()

    BOOST_AUTO_TEST_SUITE(it)

        BOOST_AUTO_TEST_CASE(char_lengths) {
            BOOST_CHECK_EQUAL(1, 1);
        }

    BOOST_AUTO_TEST_SUITE_END()

BOOST_AUTO_TEST_SUITE_END()

#endif // SET_MY_INFO_COMMANDLINE_PARAMETERS_TEST_H
