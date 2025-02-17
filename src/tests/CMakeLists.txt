cmake_minimum_required(VERSION 3.10)

# TODO: I shall do this with Conan

# include(FetchContent)
# FetchContent_Declare(
#   googletest
#   URL https://github.com/google/googletest/archive/03597a01ee50ed33e9dfd640b249b4be3799d395.zip
# )
# set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
# FetchContent_MakeAvailable(googletest)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_BINARY_DIR})
list(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_BINARY_DIR})
# set(CMAKE_VERBOSE_MAKEFILE 1)

conan_cmake_configure(REQUIRES
                      gtest/1.15.0
                      GENERATORS CMakeDeps CMakeToolchain)
conan_cmake_install(PATH_OR_REFERENCE .
                    BUILD missing
                    REMOTE conancenter
                    SETTINGS ${settings})

find_package(GTest REQUIRED)

enable_testing()

add_executable(
    lexer_test
    lexer_test.cc
)

target_link_libraries(
    lexer_test
    gtest::gtest
)

include(GoogleTest)
gtest_discover_tests(lexer_test)
