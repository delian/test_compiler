cmake_minimum_required(VERSION 3.15)
project(parser C)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_BINARY_DIR})
list(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_BINARY_DIR})
set(CMAKE_VERBOSE_MAKEFILE 1)

conan_cmake_configure(REQUIRES
                      readline/8.2
                      GENERATORS CMakeDeps)
conan_cmake_install(PATH_OR_REFERENCE .
                    BUILD missing
                    REMOTE conancenter
                    SETTINGS ${settings})

find_package(readline REQUIRED)

find_package(BISON REQUIRED)
bison_target(${PROJECT_NAME} parser.y ${CMAKE_CURRENT_SOURCE_DIR}/temp/bison_parser.c 
             COMPILE_FLAGS -Wcounterexamples
             VERBOSE
            )

find_package(FLEX REQUIRED)
flex_target(lexer lexer.l ${CMAKE_CURRENT_SOURCE_DIR}/temp/flex_lexer.c)

add_flex_bison_dependency(lexer parser)

add_library(${PROJECT_NAME} ${FLEX_lexer_OUTPUTS} ${BISON_parser_OUTPUTS} ${readline_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} PRIVATE readline::readline)
