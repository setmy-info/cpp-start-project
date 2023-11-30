#ifndef SET_MY_INFO_COLLECTION_H
#define SET_MY_INFO_COLLECTION_H

#include <vector>
#include <functional>

namespace set_my_info::collection::operations {

    template<typename T>
    std::vector<T> apply_concat_many(const std::vector<std::vector<T>> &vectors) {
        std::vector<T> result;
        for (const auto &arg: vectors) {
            result.insert(result.end(), arg.begin(), arg.end());
        }
        return result;
    }

    template<typename A, typename B, typename T>
    std::vector<T> product(
            const std::vector<A> &list_a,
            const std::vector<B> &list_b,
            std::function<T(const A &, const B &)> product_function
    ) {
        std::vector<T> result;
        for (const auto &x: list_a) {
            for (const auto &y: list_b) {
                result.push_back(product_function(x, y));
            }
        }
        return result;
    }

    template<typename A, typename B>
    std::vector<std::pair<A, B>> product_as_pairs(
            const std::vector<A> &dimension_a,
            const std::vector<B> &dimension_b
    ) {
        std::vector<std::pair<A, B>> result;
        for (const auto &x: dimension_a) {
            for (const auto &y: dimension_b) {
                result.emplace_back(x, y);
            }
        }
        return result;
    }
}
#endif //SET_MY_INFO_COLLECTION_H
