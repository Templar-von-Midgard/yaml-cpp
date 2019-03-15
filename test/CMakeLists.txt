include(ExternalProject)

if(MSVC)
  # MS Visual Studio expects lib prefix on static libraries,
  # but CMake compiles them without prefix
  # See https://gitlab.kitware.com/cmake/cmake/issues/17338
  set(CMAKE_STATIC_LIBRARY_PREFIX "")
endif()

ExternalProject_Add(googletest_project
  SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/gtest-1.8.0"
  INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}/prefix"
  CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>"
             "-DBUILD_GMOCK=ON"
             "-Dgtest_force_shared_crt=ON"
)

add_library(gmock IMPORTED UNKNOWN)
set_target_properties(gmock PROPERTIES
  IMPORTED_LOCATION ${PROJECT_BINARY_DIR}/test/prefix/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock${CMAKE_STATIC_LIBRARY_SUFFIX}
  INTERFACE_INCLUDE_DIRECTORIES "${PROJECT_BINARY_DIR}/test/prefix/include"
  INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${PROJECT_BINARY_DIR}/test/prefix/include"
)
add_dependencies(gmock googletest_project)

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

add_dependencies(run-tests googletest_project)

add_test(
  NAME yaml-test
  COMMAND run-tests
)
