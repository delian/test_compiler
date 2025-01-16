cmake_minimum_required(VERSION 3.15)
project(ply C)

set(CMAKE_BUILD_TYPE Release)
set(CONAN_HOST_PROFILE default)
set(BUILD_SHARED_LIBS OFF)
# set(CMAKE_EXE_LINKER_FLAGS "-static")

if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
  message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
  file(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/0.18.0/conan.cmake"
                "${CMAKE_BINARY_DIR}/conan.cmake"
                TLS_VERIFY ON)
endif()

include(${CMAKE_BINARY_DIR}/conan.cmake)


conan_cmake_configure(REQUIRES 
                        zlib/1.2.11 
                        llvm-core/13.0.0
                        GENERATORS CMakeDeps)

conan_cmake_autodetect(settings)

conan_cmake_install(PATH_OR_REFERENCE .
                    BUILD missing
                    REMOTE conancenter
                    PROFILE ${CONAN_HOST_PROFILE}
                    SETTINGS ${settings})

find_package(ZLIB REQUIRED)
find_package(LLVM REQUIRED)

find_package(FLEX REQUIRED)
flex_target(lexer src/parser/lexer.l ${CMAKE_SOURCE_DIR}/src/parser/temp/flex_lexer.c)

find_package(BISON REQUIRED)
bison_target(parser src/parser/parser.y ${CMAKE_SOURCE_DIR}/src/parser/temp/bison_parser.c)

add_flex_bison_dependency(lexer parser)

add_library(parser ${FLEX_lexer_OUTPUTS} ${BISON_parser_OUTPUTS})
add_executable(${PROJECT_NAME} src/main.c)

target_link_libraries(${PROJECT_NAME} parser LLVM)
install(TARGETS ${PROJECT_NAME} DESTINATION bin)
