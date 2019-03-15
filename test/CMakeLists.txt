include(ExternalProject)

if(MSVC)
  # MS Visual Studio expects lib prefix on static libraries,
  # but CMake compiles them without prefix
  # See https://gitlab.kitware.com/cmake/cmake/issues/17338
  set(CMAKE_STATIC_LIBRARY_PREFIX "")
endif()

set(BUILD_GMOCK ON)
add_subdirectory(gtest-1.8.0)
target_include_directories(gmock
  INTERFACE gtest-1.8.0/googletest/include
            gtest-1.8.0/googlemock/include
)

find_package(Threads)

add_executable(run-tests)
target_sources(run-tests PRIVATE
  main.cpp

  handler_test.h
  mock_event_handler.h
  specexamples.h
  ostream_wrapper_test.cpp
  regex_test.cpp

  integration/emitter_test.cpp
  integration/encoding_test.cpp
  integration/gen_emitter_test.cpp
  integration/handler_spec_test.cpp
  integration/handler_test.cpp
  integration/load_node_test.cpp
  integration/node_spec_test.cpp

  node/node_test.cpp
)
target_compile_options(run-tests PRIVATE
  $<$<IN_LIST:$<CXX_COMPILER_ID>,Clang;GNU>:-Wno-variadic-macros>
  $<$<IN_LIST:$<CXX_COMPILER_ID>,Clang;GNU>:-Wno-sign-compare>
  $<$<CXX_COMPILER_ID:Clang>:-Wno-sign-compare>
)
target_include_directories(run-tests
  PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}
          ${YAML_CPP_SOURCE_DIR}/lib/src
)

target_link_libraries(run-tests
  PRIVATE yaml-cpp
          gmock
          Threads::Threads
)

add_test(
  NAME yaml-test
  COMMAND run-tests
)
