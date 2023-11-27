#ifndef SET_MY_INFO_COLLECTION_TEST_H
#define SET_MY_INFO_COLLECTION_TEST_H

#include "CppUnitTest.h"
#include "Collection.h"

using namespace SetMyInfo::Collection::Operations;

BOOST_AUTO_TEST_SUITE(collection_test)

    BOOST_AUTO_TEST_SUITE(ut)

        BOOST_AUTO_TEST_CASE(apply_concat_many_test) {
            std::vector<int> vec1 = {1, 2, 3};
            std::vector<int> vec2 = {4, 5, 6};
            std::vector<int> vec3 = {7, 8, 9};
            std::vector<int> result;

            apply_concat_many({vec1, vec2, vec3}, result);

            BOOST_CHECK_EQUAL(result.size(), 9);
            BOOST_CHECK_EQUAL(result[0], 1);
            BOOST_CHECK_EQUAL(result[1], 2);
            BOOST_CHECK_EQUAL(result[2], 3);
            BOOST_CHECK_EQUAL(result[3], 4);
            BOOST_CHECK_EQUAL(result[4], 5);
            BOOST_CHECK_EQUAL(result[5], 6);
            BOOST_CHECK_EQUAL(result[6], 7);
            BOOST_CHECK_EQUAL(result[7], 8);
            BOOST_CHECK_EQUAL(result[8], 9);
        }

        BOOST_AUTO_TEST_CASE(product_test) {
            std::vector<int> list_a = {1, 2, 3};
            std::vector<std::string> list_b = {"a", "b"};
            std::vector<std::pair<int, std::string>> result;
            std::function<std::pair<int, std::string>(const int &, const std::string &)>
                    product_function = [](const int &x, const std::string &y) -> std::pair<int, std::string> {
                return std::make_pair(x, y);
            };

            product(list_a, list_b, product_function, result);

            BOOST_CHECK_EQUAL(result.size(), 6);
            BOOST_CHECK_EQUAL(result[0].first, 1);
            BOOST_CHECK_EQUAL(result[0].second, "a");
            BOOST_CHECK_EQUAL(result[1].first, 1);
            BOOST_CHECK_EQUAL(result[1].second, "b");
            BOOST_CHECK_EQUAL(result[2].first, 2);
            BOOST_CHECK_EQUAL(result[2].second, "a");
            BOOST_CHECK_EQUAL(result[3].first, 2);
            BOOST_CHECK_EQUAL(result[3].second, "b");
            BOOST_CHECK_EQUAL(result[4].first, 3);
            BOOST_CHECK_EQUAL(result[4].second, "a");
            BOOST_CHECK_EQUAL(result[5].first, 3);
            BOOST_CHECK_EQUAL(result[5].second, "b");
        }

    BOOST_AUTO_TEST_SUITE_END()

    BOOST_AUTO_TEST_SUITE(it)

        BOOST_AUTO_TEST_CASE(abc_lengths) {
            BOOST_CHECK_EQUAL(1, 1);
        }

    BOOST_AUTO_TEST_SUITE_END()

BOOST_AUTO_TEST_SUITE_END()

#endif // SET_MY_INFO_COLLECTION_TEST_H
