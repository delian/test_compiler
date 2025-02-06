cmake_minimum_required(VERSION 3.15)
project(compiler VERSION 0.1 LANGUAGES CXX)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_BINARY_DIR})
list(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_BINARY_DIR})
set(CMAKE_VERBOSE_MAKEFILE 1)
set(CMAKE_BUILD_TYPE Debug)

conan_cmake_configure(REQUIRES
                      llvm-core/13.0.0
                      GENERATORS CMakeDeps)
conan_cmake_install(PATH_OR_REFERENCE .
                    BUILD missing
                    REMOTE conancenter
                    SETTINGS ${settings})

find_package(LLVM REQUIRED)

add_library(${PROJECT_NAME} compiler.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE llvm-core::llvm-core)

