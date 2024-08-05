#ifndef SET_MY_INFO_DATA_TYPES_TEST_H
#define    SET_MY_INFO_DATA_TYPES_TEST_H

#include "CppUnitTest.h"
#include "DataType.h"

BOOST_AUTO_TEST_SUITE(data_types_test)

    BOOST_AUTO_TEST_SUITE(ut)

        BOOST_AUTO_TEST_CASE(char_lengths) {
            BOOST_CHECK_EQUAL(sizeof(set_my_info::Char), 1);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::UChar), 1);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::SChar), 1);

            BOOST_CHECK(std::numeric_limits<set_my_info::Char>::is_signed);
            BOOST_CHECK(!std::numeric_limits<set_my_info::UChar>::is_signed);
            BOOST_CHECK(std::numeric_limits<set_my_info::SChar>::is_signed);
        }

        BOOST_AUTO_TEST_CASE(int8_lengths) {
            BOOST_CHECK_EQUAL(sizeof(set_my_info::Int8), 1);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::UInt8), 1);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::SInt8), 1);

            BOOST_CHECK(std::numeric_limits<set_my_info::Int8>::is_signed);
            BOOST_CHECK(!std::numeric_limits<set_my_info::UInt8>::is_signed);
            BOOST_CHECK(std::numeric_limits<set_my_info::SInt8>::is_signed);
        }

        BOOST_AUTO_TEST_CASE(int16_lengths) {
            BOOST_CHECK_EQUAL(sizeof(set_my_info::Int16), 2);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::UInt16), 2);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::SInt16), 2);

            BOOST_CHECK(std::numeric_limits<set_my_info::Int16>::is_signed);
            BOOST_CHECK(!std::numeric_limits<set_my_info::UInt16>::is_signed);
            BOOST_CHECK(std::numeric_limits<set_my_info::SInt16>::is_signed);
        }

        BOOST_AUTO_TEST_CASE(int32_lengths) {
            BOOST_CHECK_EQUAL(sizeof(set_my_info::Int), 4);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::UInt), 4);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::Int32), 4);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::UInt32), 4);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::SInt32), 4);

            BOOST_CHECK(std::numeric_limits<set_my_info::Int>::is_signed);
            BOOST_CHECK(!std::numeric_limits<set_my_info::UInt>::is_signed);
            BOOST_CHECK(std::numeric_limits<set_my_info::Int32>::is_signed);
            BOOST_CHECK(!std::numeric_limits<set_my_info::UInt32>::is_signed);
            BOOST_CHECK(std::numeric_limits<set_my_info::SInt32>::is_signed);
        }

        BOOST_AUTO_TEST_CASE(int64_lengths) {
            BOOST_CHECK_EQUAL(sizeof(set_my_info::Int64), 8);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::UInt64), 8);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::SInt64), 8);

            BOOST_CHECK(std::numeric_limits<set_my_info::Int64>::is_signed);
            BOOST_CHECK(!std::numeric_limits<set_my_info::UInt64>::is_signed);
            BOOST_CHECK(std::numeric_limits<set_my_info::SInt64>::is_signed);
        }

        BOOST_AUTO_TEST_CASE(float_types_lengths) {
            BOOST_CHECK_EQUAL(sizeof(set_my_info::Float32), 4);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::Float), 4);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::Double64), 8);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::Double), 8);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::LongDouble), 16);//128 bit
        }

        BOOST_AUTO_TEST_CASE(pointer_types_lengths) {
#ifdef __LP64__
            BOOST_CHECK_EQUAL(sizeof(set_my_info::Pointer), 8);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::UPointerInt), 8);
#else
            BOOST_CHECK_EQUAL(sizeof(set_my_info::Pointer), 4);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::UPointerInt), 4);
#endif

        }

        BOOST_AUTO_TEST_CASE(misc_types_lengths) {
            BOOST_CHECK_EQUAL(sizeof(set_my_info::Type), 8);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::UPosition), 8);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::SPosition), 8);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::Position), 8);
        }

        BOOST_AUTO_TEST_CASE(date_time_types_lengths) {
            BOOST_CHECK_EQUAL(sizeof(set_my_info::Date), 8);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::Time), 16);
            BOOST_CHECK_EQUAL(sizeof(set_my_info::DateTime), 24);
        }

        BOOST_AUTO_TEST_CASE(data_type_enums_values) {
            BOOST_CHECK_EQUAL(set_my_info::DataType::UINT8, 1);
            BOOST_CHECK_EQUAL(set_my_info::DataType::SINT8, 2);
            BOOST_CHECK_EQUAL(set_my_info::DataType::UINT16, 3);
            BOOST_CHECK_EQUAL(set_my_info::DataType::SINT16, 4);
            BOOST_CHECK_EQUAL(set_my_info::DataType::UINT32, 5);
            BOOST_CHECK_EQUAL(set_my_info::DataType::SINT32, 6);
            BOOST_CHECK_EQUAL(set_my_info::DataType::UINT64, 7);
            BOOST_CHECK_EQUAL(set_my_info::DataType::SINT64, 8);
            BOOST_CHECK_EQUAL(set_my_info::DataType::FLOAT, 9);
            BOOST_CHECK_EQUAL(set_my_info::DataType::DOUBLE, 10);
            BOOST_CHECK_EQUAL(set_my_info::DataType::LONG_DOUBLE, 11);
            BOOST_CHECK_EQUAL(set_my_info::DataType::DATE, 12);
            BOOST_CHECK_EQUAL(set_my_info::DataType::TIME, 13);
            BOOST_CHECK_EQUAL(set_my_info::DataType::DATE_TIME, 14);
            BOOST_CHECK_EQUAL(set_my_info::DataType::STRING, 15);
        }

    BOOST_AUTO_TEST_SUITE_END()

BOOST_AUTO_TEST_SUITE_END()

#endif // SET_MY_INFO_DATA_TYPES_TEST_H
