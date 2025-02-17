cmake_minimum_required(VERSION 3.14)
project(ply C CXX)

set(CMAKE_WARN_DEPRECATED 1)
set(CMAKE_WARN_UNUSED_CLI 1)
set(CMAKE_VERBOSE_MAKEFILE 1)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 11)

set(CMAKE_BUILD_TYPE Release)
# set(BUILD_SHARED_LIBS OFF)
# set(CMAKE_EXE_LINKER_FLAGS "-static")

enable_testing()

file(COPY lang-tests DESTINATION ${CMAKE_BINARY_DIR})
add_subdirectory(src/conan)
add_subdirectory(src/parser)
add_subdirectory(src/compiler)
add_subdirectory(src/tests)

add_executable(${PROJECT_NAME} src/main.c)

target_link_libraries(${PROJECT_NAME} parser compiler)
install(TARGETS ${PROJECT_NAME} DESTINATION bin)
