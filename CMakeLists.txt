cmake_minimum_required(VERSION 3.13 FATAL_ERROR)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

project(YAML_CPP VERSION 0.6.2 LANGUAGES CXX
  DESCRIPTION "A YAML parser and emitter in C++"
  HOMEPAGE_URL "https://github.com/Templar-von-Midgard/yaml-cpp"
)

include(AddFeatureOption)
add_feature_option(
  NAME YAML_CPP_BUILD_TESTS
  FEATURE "yaml-cpp: Enable testing"
  DEFAULT ON
)
add_feature_option(
  NAME YAML_CPP_BUILD_TOOLS
  FEATURE "Enable parse tools"
  DEFAULT ON
)
add_feature_option(
  NAME YAML_CPP_BUILD_CONTRIB
  FEATURE "Enable contrib stuff in library"
  DEFAULT ON
)
add_feature_option(
  NAME BUILD_SHARED_LIBS
  FEATURE "Build Shared Libraries"
  DEFAULT OFF
)

# Set minimum C++ to 2011 standards
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

if(BUILD_SHARED_LIBS)
  set(LABEL_SUFFIX "shared")
else()
  set(LABEL_SUFFIX "static")
endif()

if(WIN32)
  if(BUILD_SHARED_LIBS)
    add_definitions(-D${PROJECT_NAME}_DLL)  # use or build Windows DLL
  endif()
endif()

if(MSVC)
  ### Project stuff
  # /W3 = set warning level; see http://msdn.microsoft.com/en-us/library/thxezb7y.aspx
  # /wd4127 = disable warning C4127 "conditional expression is constant"; see http://msdn.microsoft.com/en-us/library/6t66728h.aspx
  # /wd4355 = disable warning C4355 "'this' : used in base member initializer list"; http://msdn.microsoft.com/en-us/library/3c594ae3.aspx
  string(APPEND CMAKE_CXX_FLAGS " /W3 /wd4127 /wd4355")
elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
  string(APPEND CMAKE_CXX_FLAGS " -Wall -Wextra -Wshadow -Weffc++ -pedantic -pedantic-errors -Wno-long-long")
endif()


### Library
add_subdirectory(lib)

include(CMakePackageConfigHelpers)
configure_package_config_file(
  "yaml-cpp-config.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/yaml-cpp-config.cmake"
  INSTALL_DESTINATION lib/cmake/yaml-cpp
)
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/yaml-cpp-config-version.cmake"
  COMPATIBILITY SameMajorVersion
)
install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/yaml-cpp-config.cmake"
  "${CMAKE_CURRENT_BINARY_DIR}/yaml-cpp-config-version.cmake"
  DESTINATION lib/cmake/yaml-cpp
)

### Extras
if(YAML_CPP_BUILD_TESTS)
  enable_testing()
  add_subdirectory(test)
endif()
if(YAML_CPP_BUILD_TOOLS)
  add_subdirectory(util)
endif()

feature_summary(
  WHAT ALL
  FATAL_ON_MISSING_REQUIRED_PACKAGES
)
