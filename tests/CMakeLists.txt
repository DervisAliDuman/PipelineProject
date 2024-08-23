add_subdirectory(googletest)
add_executable(test_main test_main.cpp)
target_link_libraries(test_main gtest gtest_main)
add_test(NAME test_main COMMAND test_main)
