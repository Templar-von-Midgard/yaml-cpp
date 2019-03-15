cmake_minimum_required(VERSION 3.13 FATAL_ERROR)

add_library(yaml-cpp)
target_sources(yaml-cpp PRIVATE
  include/yaml-cpp/anchor.h
  include/yaml-cpp/binary.h
  include/yaml-cpp/emitfromevents.h
  include/yaml-cpp/emitter.h
  include/yaml-cpp/emitterdef.h
  include/yaml-cpp/emittermanip.h
  include/yaml-cpp/emitterstyle.h
  include/yaml-cpp/eventhandler.h
  include/yaml-cpp/exceptions.h
  include/yaml-cpp/mark.h
  include/yaml-cpp/null.h
  include/yaml-cpp/ostream_wrapper.h
  include/yaml-cpp/parser.h
  include/yaml-cpp/stlemitter.h
  include/yaml-cpp/traits.h
  include/yaml-cpp/yaml.h

  include/yaml-cpp/node/convert.h
  include/yaml-cpp/node/emit.h
  include/yaml-cpp/node/impl.h
  include/yaml-cpp/node/parse.h
  include/yaml-cpp/node/ptr.h
  include/yaml-cpp/node/type.h
  include/yaml-cpp/node/detail/bool_type.h
  include/yaml-cpp/node/detail/impl.h
  include/yaml-cpp/node/detail/iterator.h
  include/yaml-cpp/node/detail/iterator_fwd.h
  include/yaml-cpp/node/detail/memory.h
  include/yaml-cpp/node/detail/node.h
  include/yaml-cpp/node/detail/node_data.h
  include/yaml-cpp/node/detail/node_iterator.h
  include/yaml-cpp/node/detail/node_ref.h

  src/collectionstack.h
  src/directives.h
  src/emitterstate.h
  src/emitterutils.h
  src/exp.h
  src/indentation.h
  src/nodebuilder.h
  src/nodeevents.h
  src/ptr_vector.h
  src/regeximpl.h
  src/regex_yaml.h
  src/scanner.h
  src/scanscalar.h
  src/scantag.h
  src/setting.h
  src/singledocparser.h
  src/streamcharsource.h
  src/stream.h
  src/stringsource.h
  src/tag.h
  src/token.h

  src/binary.cpp
  src/convert.cpp
  src/directives.cpp
  src/emit.cpp
  src/emitfromevents.cpp
  src/emitter.cpp
  src/emitterstate.cpp
  src/emitterutils.cpp
  src/exceptions.cpp
  src/exp.cpp
  src/memory.cpp
  src/nodebuilder.cpp
  src/node.cpp
  src/node_data.cpp
  src/nodeevents.cpp
  src/null.cpp
  src/ostream_wrapper.cpp
  src/parse.cpp
  src/parser.cpp
  src/regex_yaml.cpp
  src/scanner.cpp
  src/scanscalar.cpp
  src/scantag.cpp
  src/scantoken.cpp
  src/simplekey.cpp
  src/singledocparser.cpp
  src/stream.cpp
  src/tag.cpp
)

if(YAML_CPP_BUILD_CONTRIB)
  target_sources(yaml-cpp PRIVATE
    include/yaml-cpp/contrib/anchordict.h
    include/yaml-cpp/contrib/graphbuilder.h

    src/contrib/graphbuilder.cpp
    src/contrib/graphbuilderadapter.h
    src/contrib/graphbuilderadapter.cpp
  )
else()
  target_compile_definitions(yaml-cpp
    PUBLIC YAML_CPP_NO_CONTRIB
  )
endif()

include(GenerateExportHeader)
generate_export_header(yaml-cpp)
configure_file(
  ${CMAKE_CURRENT_BINARY_DIR}/yaml-cpp_export.h
  ${CMAKE_CURRENT_BINARY_DIR}/include/yaml-cpp/yaml-cpp_export.h
  COPYONLY
)

target_include_directories(yaml-cpp
  PUBLIC $<INSTALL_INTERFACE:include>
         $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
         $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
  PRIVATE src
)

set_target_properties(yaml-cpp PROPERTIES
  VERSION ${YAML_CPP_VERSION}
  SOVERSION "${YAML_CPP_VERSION_MAJOR}.${YAML_CPP_VERSION_MINOR}"
  CXX_VISIBILITY_PRESET "hidden"
  VISIBILITY_INLINES_HIDDEN ON
  PROJECT_LABEL "yaml-cpp ${LABEL_SUFFIX}"
)

install(
  TARGETS yaml-cpp
  EXPORT yaml-cpp-targets
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
)
if(YAML_CPP_BUILD_CONTRIB)
  install(
    DIRECTORY include/yaml-cpp
    DESTINATION include
  )
else()
  install(
    DIRECTORY include/yaml-cpp
    DESTINATION include
    PATTERN "contrib" EXCLUDE
  )
endif()
install(
  DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/yaml-cpp
  DESTINATION include
)
install(
  EXPORT yaml-cpp-targets
  NAMESPACE yaml-cpp::
  DESTINATION lib/cmake/yaml-cpp
)
