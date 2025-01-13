cmake_minimum_required(VERSION 3.15)
project(compressor C)

set(CMAKE_BUILD_TYPE Release)
set(CONAN_HOST_PROFILE default)

if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
  message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
  file(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/0.18.0/conan.cmake"
                "${CMAKE_BINARY_DIR}/conan.cmake"
                TLS_VERIFY ON)
endif()

include(${CMAKE_BINARY_DIR}/conan.cmake)


conan_cmake_configure(REQUIRES zlib/1.2.11
                      GENERATORS CMakeDeps
                     )
conan_cmake_autodetect(settings)

conan_cmake_install(PATH_OR_REFERENCE .
                    BUILD missing
                    REMOTE conancenter
                    PROFILE ${CONAN_HOST_PROFILE}
                    SETTINGS ${settings})

find_package(ZLIB REQUIRED)

add_executable(${PROJECT_NAME} src/main.c)

target_link_libraries(${PROJECT_NAME} ZLIB::ZLIB)