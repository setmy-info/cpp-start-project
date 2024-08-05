#ifndef SET_MY_INFO_DATA_TYPES_H
#define SET_MY_INFO_DATA_TYPES_H

namespace set_my_info {

    using SChar = signed char;
    using UChar = unsigned char;
    using Char = SChar;

    using UInt8 = unsigned char;
    using SInt8 = signed char;
    using Int8 = SInt8;

    using UInt16 = unsigned short;
    using SInt16 = signed short;
    using Int16 = SInt16;

    using UInt32 = unsigned int;
    using SInt32 = signed int;
    using Int32 = SInt32;
    using Int = Int32;
    using UInt = UInt32;

    using UInt64 = unsigned long long;
    using SInt64 = signed long long;
    using Int64 = SInt64;

    using Float32 = float;
    using Double64 = double;
    using LongDouble = long double;
    using Float = Float32;
    using Double = Double64;

    using Pointer = void *;

#if defined(__LP64__)
    using UPointerInt = UInt64;
#else
    using UPointerInt = UInt32;
#endif

    using Type = UInt64;
    using UPosition = UInt64;
    using SPosition = SInt64;
    using Position = SInt64;

    struct Date {
        UInt8 day;
        UInt8 month;
        UInt32 year;
    };

    struct Time {
        UInt8 hours;
        UInt8 minutes;
        UInt8 seconds;
        UInt64 nanoseconds;
    };

    struct DateTime {
        Date date;
        Time time;
    };

    enum DataType {
        UINT8 = 1,
        SINT8,
        UINT16,
        SINT16,
        UINT32,
        SINT32,
        UINT64,
        SINT64,
        FLOAT,
        DOUBLE,
        LONG_DOUBLE,
        DATE,
        TIME,
        DATE_TIME,
        STRING,
    };
}

#endif //SET_MY_INFO_DATA_TYPES_H
