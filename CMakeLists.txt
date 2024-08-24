cmake_minimum_required(VERSION 3.10)

project(MyCppProject VERSION 1.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

include_directories(include)
add_executable(MyCppProject src/main.cpp src/utils.cpp)

enable_testing()
add_executable(run_tests tests/test_utils.cpp src/utils.cpp)
add_test(NAME RunTests COMMAND run_tests)
