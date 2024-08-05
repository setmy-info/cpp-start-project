#ifndef CPP_START_PROJECT_DATA_CELL_H
#define CPP_START_PROJECT_DATA_CELL_H

#include <cstddef>
#include "DataType.h"

namespace set_my_info {

    class DataCell {
    private:
        DataType data_type_;
        size_t data_length_;
        Byte *data_;

        void allocate(const size_t length);

        void free();

        template<typename T>
        Boolean set(const T value);

        template<typename T>
        Boolean setStruct(const T &value);

        Boolean setString(const char *const value);

    public:
        DataCell();

        DataCell &operator=(const Boolean value);

        DataCell &operator=(const UInt8 value);

        DataCell &operator=(const SInt8 value);

        DataCell &operator=(const UInt16 value);

        DataCell &operator=(const SInt16 value);

        DataCell &operator=(const UInt32 value);

        DataCell &operator=(const SInt32 value);

        DataCell &operator=(const UInt64 value);

        DataCell &operator=(const SInt64 value);

        DataCell &operator=(const Float value);

        DataCell &operator=(const Double value);

        DataCell &operator=(const LongDouble value);

        DataCell &operator=(const Date &value);

        DataCell &operator=(const Time &value);

        DataCell &operator=(const DateTime &value);

        DataCell &operator=(const char *const value);

        void setData(const Boolean value);

        void setData(const UInt8 value);

        void setData(const SInt8 value);

        void setData(const UInt16 value);

        void setData(const SInt16 value);

        void setData(const UInt32 value);

        void setData(const SInt32 value);

        void setData(const UInt64 value);

        void setData(const SInt64 value);

        void setData(const Float value);

        void setData(const Double value);

        void setData(const LongDouble value);

        void setData(const Date &value);

        void setData(const Time &value);

        void setData(const DateTime &value);

        void setData(const char *const value);

        size_t GetDataLength();

        DataType GetDataTpe();

        virtual ~DataCell();
    };
}

#endif //CPP_START_PROJECT_DATA_CELL_H
