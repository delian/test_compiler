cmake_minimum_required(VERSION 3.14)
project(ply C CXX)

set(CMAKE_WARN_DEPRECATED 1)
set(CMAKE_WARN_UNUSED_CLI 1)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 17)
set(CMAKE_CXX_FLAGS --coverage)
set(CMAKE_BUILD_TYPE Debug)

enable_testing()

file(COPY lang-tests DESTINATION ${CMAKE_BINARY_DIR})
add_subdirectory(src/conan)
add_subdirectory(src/parser)
add_subdirectory(src/compiler)
add_subdirectory(src/tests)

add_executable(${PROJECT_NAME} src/main.c)

target_link_libraries(${PROJECT_NAME} parser compiler)
install(TARGETS ${PROJECT_NAME} DESTINATION bin)

set_source_files_properties(tags PROPERTIES GENERATED true)
add_custom_target(tags
    COMMAND ctags -R --c++-kinds=+p --fields=+iaS --extras=+-Ffqpqrs .
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)
