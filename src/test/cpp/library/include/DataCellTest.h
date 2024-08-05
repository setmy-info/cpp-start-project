#ifndef SET_MY_INFO_DATA_CELL_TEST_H
#define SET_MY_INFO_DATA_CELL_TEST_H

#include "CppUnitTest.h"
#include "DataCell.h"

BOOST_AUTO_TEST_SUITE(data_cell_test)

    BOOST_AUTO_TEST_SUITE(ut)

        BOOST_AUTO_TEST_CASE(boolean_value_set) {
            const set_my_info::UInt16 value = 1234;
            set_my_info::DataCell data_cell;
            data_cell = value;

            BOOST_CHECK_EQUAL(data_cell.GetDataLength(), 2);
            BOOST_CHECK_EQUAL(data_cell.GetDataTpe(), UINT16);
        }

        BOOST_AUTO_TEST_CASE(string_value_set) {
            const char *text = "Hello World!";
            set_my_info::DataCell data_cell;
            data_cell = text;

            BOOST_CHECK_EQUAL(data_cell.GetDataLength(), 13);
            BOOST_CHECK_EQUAL(data_cell.GetDataTpe(), STRING);
        }

    BOOST_AUTO_TEST_SUITE_END()

    BOOST_AUTO_TEST_SUITE(it)

        BOOST_AUTO_TEST_CASE(boolean_value_set) {
            BOOST_CHECK_EQUAL(1, 1);
        }

    BOOST_AUTO_TEST_SUITE_END()

BOOST_AUTO_TEST_SUITE_END()

#endif // SET_MY_INFO_DATA_CELL_TEST_H
