#include <gtest/gtest.h>

#include <iostream>
#include <filesystem>
#include <string>
#include <cstdlib>

#define TESTDIRENV "TEST_DIR_PATH"
#define TESTDIRPATH "../../lang-tests"
#define TESTPATTERN ".ll"

extern "C" int parse_file(const char *filename);

TEST(ParsingTest, ParsingFilesDir) {
    std::string path = std::getenv(TESTDIRENV) != nullptr ? std::getenv(TESTDIRENV) : TESTDIRPATH;
    for (const auto & entry : std::filesystem::directory_iterator(path)) {
        if (!entry.is_regular_file()) continue;
        const auto base_name = entry.path().filename().string();
        if (base_name.find(TESTPATTERN) == std::string::npos) continue;
        std::cout << "Parsing file " << entry.path() << std::endl;
        EXPECT_EQ(parse_file(entry.path().string().c_str()),0);
    }
};
