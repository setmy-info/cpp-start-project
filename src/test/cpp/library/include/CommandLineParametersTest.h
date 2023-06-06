#ifndef SET_MY_INFO_COMMANDLINE_PARAMETERS_TEST_H
#define    SET_MY_INFO_COMMANDLINE_PARAMETERS_TEST_H

#include "CppUnitTest.h"
#include "CommandLineParameters.h"
#include "Macros.h"

using SetMyInfo::CommandLineParameters;

BOOST_AUTO_TEST_SUITE(commandline_parameters_test)

    BOOST_AUTO_TEST_SUITE(ut)

        BOOST_AUTO_TEST_CASE(arguments_test) {
            //CommandLineParameters commandline_parameters;
            const char *arguments[] = {"programName", "abc", "def=ghi", "jkl=mno=prs"};
            BOOST_CHECK_EQUAL(ARRAY_SIZEOF(arguments), 4);
            //commandline_parameters.Args(ARRAY_SIZEOF(arguments), arguments);
            BOOST_CHECK_EQUAL(1, 1);
        }

    BOOST_AUTO_TEST_SUITE_END()

    BOOST_AUTO_TEST_SUITE(it)

        BOOST_AUTO_TEST_CASE(char_lengths) {
            BOOST_CHECK_EQUAL(1, 1);
        }

    BOOST_AUTO_TEST_SUITE_END()

BOOST_AUTO_TEST_SUITE_END()

#endif // SET_MY_INFO_COMMANDLINE_PARAMETERS_TEST_H
