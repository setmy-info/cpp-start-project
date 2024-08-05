#include "DataCell.h"

#include <new>
#include <cstring>

namespace set_my_info {

    DataCell::DataCell() : data_type_(NO_TYPE), data_length_(0), data_(nullptr) {
    }

    DataCell::~DataCell() {
        this->free();
    }

    DataCell &DataCell::operator=(const Boolean value) {
        this->setData(value);
        return *this;
    }

    DataCell &DataCell::operator=(const UInt8 value) {
        this->setData(value);
        return *this;
    }

    DataCell &DataCell::operator=(const SInt8 value) {
        this->setData(value);
        return *this;
    }

    DataCell &DataCell::operator=(const UInt16 value) {
        this->setData(value);
        return *this;
    }

    DataCell &DataCell::operator=(const SInt16 value) {
        this->setData(value);
        return *this;
    }

    DataCell &DataCell::operator=(const UInt32 value) {
        this->setData(value);
        return *this;
    }

    DataCell &DataCell::operator=(const SInt32 value) {
        this->setData(value);
        return *this;
    }

    DataCell &DataCell::operator=(const UInt64 value) {
        this->setData(value);
        return *this;
    }

    DataCell &DataCell::operator=(const SInt64 value) {
        this->setData(value);
        return *this;
    }

    DataCell &DataCell::operator=(const Float value) {
        this->setData(value);
        return *this;
    }

    DataCell &DataCell::operator=(const Double value) {
        this->setData(value);
        return *this;
    }

    DataCell &DataCell::operator=(const LongDouble value) {
        this->setData(value);
        return *this;
    }

    DataCell& DataCell::operator=(const Date &value) {
        this->setData(value);
        return *this;
    }

    DataCell& DataCell::operator=(const Time &value) {
        this->setData(value);
        return *this;
    }

    DataCell& DataCell::operator=(const DateTime &value) {
        this->setData(value);
        return *this;
    }

    void DataCell::setData(const Boolean value) {
        if (this->set(value)) {
            this->data_type_ = BOOLEAN;
        }
    }

    void DataCell::setData(const UInt8 value) {
        if (this->set(value)) {
            this->data_type_ = UINT8;
        }
    }

    void DataCell::setData(const SInt8 value) {
        if (this->set(value)) {
            this->data_type_ = SINT8;
        }
    }

    void DataCell::setData(const UInt16 value) {
        if (this->set(value)) {
            this->data_type_ = UINT16;
        }
    }

    void DataCell::setData(const SInt16 value) {
        if (this->set(value)) {
            this->data_type_ = SINT16;
        }
    }

    void DataCell::setData(const UInt32 value) {
        if (this->set(value)) {
            this->data_type_ = UINT32;
        }
    }

    void DataCell::setData(const SInt32 value) {
        if (this->set(value)) {
            this->data_type_ = SINT32;
        }
    }

    void DataCell::setData(const UInt64 value) {
        if (this->set(value)) {
            this->data_type_ = UINT64;
        }
    }

    void DataCell::setData(const SInt64 value) {
        if (this->set(value)) {
            this->data_type_ = SINT64;
        }
    }

    void DataCell::setData(const Float value) {
        if (this->set(value)) {
            this->data_type_ = FLOAT;
        }
    }

    void DataCell::setData(const Double value) {
        if (this->set(value)) {
            this->data_type_ = DOUBLE;
        }
    }

    void DataCell::setData(const LongDouble value) {
        if (this->set(value)) {
            this->data_type_ = DOUBLE;
        }
    }

    void DataCell::setData(const Date &value) {
        if (this->setStruct(value)) {
            this->data_type_ = DATE;
        }
    }

    void DataCell::setData(const Time &value) {
        if (this->setStruct(value)) {
            this->data_type_ = TIME;
        }
    }

    void DataCell::setData(const DateTime &value) {
        if (this->setStruct(value)) {
            this->data_type_ = DATE_TIME;
        }
    }

    template<typename T>
    Boolean DataCell::set(const T value) {
        try {
            if (this->data_ != nullptr) {
                this->free();
            }
            this->allocate(sizeof(value));
            *(T *) this->data_ = value;
            return true;
        } catch (std::bad_alloc &badAllocException) {
            return false;
        }
    }

    template<typename T>
    Boolean DataCell::setStruct(const T &value) {
        try {
            if (this->data_ != nullptr) {
                this->free();
            }
            const size_t size = sizeof(value);
            this->allocate(size);
            std::memcpy(this->data_, &value, size);
            return true;
        } catch (std::bad_alloc &badAllocException) {
            return false;
        }
    }

    size_t DataCell::GetDataLength() {
        return this->data_length_;
    }

    DataType DataCell::GetDataTpe() {
        return this->data_type_;
    }

    void DataCell::allocate(const size_t length) {
        this->data_ = new Byte[length];
        this->data_length_ = length;
    }

    void DataCell::free() {
        delete[] this->data_;
        this->data_ = nullptr;
        this->data_length_ = 0;
        this->data_type_ = NO_TYPE;
    }
}