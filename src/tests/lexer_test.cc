#include <gtest/gtest.h>

#include <iostream>
#include <filesystem>
#include <string>

// Demonstrate some basic assertions.
TEST(ParsingTest, ParsingFiles)
{
    // Expect two strings not to be equal.
    EXPECT_STRNE("hello", "hello2");
    // Expect equality.
    EXPECT_EQ(7 * 6, 42);
};

TEST(ParsingTest, ParsingFilesDir) {
    std::string path = "../../lang-tests";
    std::cout << "Current path is " << std::filesystem::current_path() << std::endl;
    for (const auto & entry : std::filesystem::directory_iterator(path)) {
        std::cout << entry.path() << std::endl;
    }
    EXPECT_EQ(1, 1);
};
