cmake_minimum_required(VERSION 3.13 FATAL_ERROR)

string(APPEND CMAKE_CXX_FLAGS " -Wno-unused-parameter")

add_sources(parse.cpp)
add_executable(parse parse.cpp)
target_link_libraries(parse yaml-cpp)

add_sources(sandbox.cpp)
add_executable(sandbox sandbox.cpp)
target_link_libraries(sandbox yaml-cpp)

add_sources(read.cpp)
add_executable(read read.cpp)
target_link_libraries(read yaml-cpp)

