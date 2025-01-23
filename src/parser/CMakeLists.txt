cmake_minimum_required(VERSION 3.15)

conan_cmake_configure(REQUIRES
                      readline/8.2
                      GENERATORS CMakeDeps)

conan_cmake_install(PATH_OR_REFERENCE .
                    BUILD missing
                    REMOTE conancenter
                    PROFILE ${CONAN_HOST_PROFILE}
                    SETTINGS ${settings})

find_library(Readline_LIBRARY
    NAMES readline
    HINTS ${Readline_ROOT_DIR}/lib ${Readline_ROOT_DIR}/lib64
    REQUIRED
)


find_package(BISON REQUIRED)
bison_target(parser parser.y ${CMAKE_CURRENT_SOURCE_DIR}/temp/bison_parser.c 
             COMPILE_FLAGS -Wcounterexamples
             VERBOSE
            )

find_package(FLEX REQUIRED)
flex_target(lexer lexer.l ${CMAKE_CURRENT_SOURCE_DIR}/temp/flex_lexer.c)

add_flex_bison_dependency(lexer parser)

add_library(parser ${FLEX_lexer_OUTPUTS} ${BISON_parser_OUTPUTS})
