cmake_minimum_required(VERSION 3.10)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_BINARY_DIR})
list(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_BINARY_DIR})
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)  # Prevent overriding the parrent project settings on Windows

set(target parser_tests)

conan_cmake_configure(REQUIRES
                      gtest/1.15.0
                      GENERATORS
                      CMakeDeps CMakeToolchain)
conan_cmake_install(PATH_OR_REFERENCE .
                    BUILD missing
                    REMOTE conancenter
                    SETTINGS ${settings})

find_package(GTest REQUIRED)

enable_testing()

add_executable(${target} parser_tests.cc)

target_link_libraries(${target} parser gtest::gtest)

include(GoogleTest)
gtest_discover_tests(${target})
