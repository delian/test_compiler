cmake_minimum_required(VERSION 3.15)
project(compressor C)

set(CMAKE_BUILD_TYPE Release)
set(CONAN_HOST_PROFILE default)

# Include the Conan module
include(FetchContent)

FetchContent_Declare(
    conan
    GIT_REPOSITORY https://github.com/conan-io/cmake-conan.git
    GIT_TAG 0.18.1 # Use the latest stable version
)

FetchContent_MakeAvailable(conan)

include(${conan_SOURCE_DIR}/conan.cmake)

conan_make_run(
   REQUIRES zlib/1.2.11
   BASIC_SETUP
   BUILD missing
)

# find_package(ZLIB REQUIRED)

add_executable(${PROJECT_NAME} src/main.c)

target_link_libraries(${PROJECT_NAME} CONAN_PKG::zlib)

# target_link_libraries(${PROJECT_NAME} ZLIB::ZLIB)