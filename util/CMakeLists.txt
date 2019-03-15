cmake_minimum_required(VERSION 3.13 FATAL_ERROR)

string(APPEND CMAKE_CXX_FLAGS " -Wno-unused-parameter")

add_executable(parse parse.cpp)
target_link_libraries(parse
  PRIVATE yaml-cpp
)

add_executable(sandbox sandbox.cpp)
target_link_libraries(sandbox
  PRIVATE yaml-cpp
)

add_executable(read read.cpp)
target_link_libraries(read
  PRIVATE yaml-cpp
)
