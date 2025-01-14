cmake_minimum_required(VERSION 3.15)
project(ply C)

set(CMAKE_BUILD_TYPE Release)
set(CONAN_HOST_PROFILE default)

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
                      GENERATORS CMakeDeps
                     )
conan_cmake_autodetect(settings)

conan_cmake_install(PATH_OR_REFERENCE .
                    BUILD missing
                    REMOTE conancenter
                    PROFILE ${CONAN_HOST_PROFILE}
                    SETTINGS ${settings})

find_package(ZLIB REQUIRED)
find_package(LLVM REQUIRED)


# find_package(BISON REQUIRED)
# set(BisonOutput ${CMAKE_SOURCE_DIR}/src/bison_parser.cpp)
# if(BISON_FOUND)
#   add_custom_command(
#     OUTPUT ${BisonOutput}
#     COMMAND ${BISON_EXECUTABLE} -d -o ${BisonOutput} ${CMAKE_SOURCE_DIR}/src/parser.y
#     DEPENDS ${CMAKE_SOURCE_DIR}/src/parser.y
#   )
# endif()

find_package(FLEX REQUIRED)
set(FlexOutput ${CMAKE_SOURCE_DIR}/src/parser/temp/flex_lexer.c)
if(FLEX_FOUND)
  add_custom_command(
    OUTPUT ${FlexOutput}
    COMMAND ${FLEX_EXECUTABLE} -o ${FlexOutput} ${CMAKE_SOURCE_DIR}/src/parser/lexer.l
    DEPENDS ${CMAKE_SOURCE_DIR}/src/parser/lexer.l
  )
endif()

add_library(parser ${FlexOutput})
add_executable(${PROJECT_NAME} src/main.c)

target_link_libraries(${PROJECT_NAME} parser LLVM)
