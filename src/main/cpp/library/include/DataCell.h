#ifndef CPP_START_PROJECT_DATA_CELL_H
#define CPP_START_PROJECT_DATA_CELL_H

namespace set_my_info {

    class DataCell {
    private:
        DataType data_type_;
    public:
        DataCell(DataType data_type);
        virtual ~DataCell();
    };

}

#endif //CPP_START_PROJECT_DATA_CELL_H
