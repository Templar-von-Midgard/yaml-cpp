function(required_variable _variable)
  cmake_parse_arguments(rv "" "PREFIX" "" ${ARGN})
  if(NOT rv_PREFIX)
    set(rv_PREFIX "")
  else()
    string(APPEND rv_PREFIX "_")
  endif()
  if(NOT DEFINED ${rv_PREFIX}${_variable})
    message(FATAL_ERROR "${_variable} is required")
  endif()
endfunction()
