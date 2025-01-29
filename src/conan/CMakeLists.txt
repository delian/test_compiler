cmake_minimum_required(VERSION 3.15)

set(CONAN_HOST_PROFILE default)

if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
  message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
  file(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/0.18.1/conan.cmake"
                "${CMAKE_CURRENT_BINARY_DIR}/conan.cmake"
                TLS_VERIFY ON)
endif()
include(${CMAKE_CURRENT_BINARY_DIR}/conan.cmake)
conan_cmake_autodetect(settings)
