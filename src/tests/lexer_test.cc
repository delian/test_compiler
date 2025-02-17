#include <gtest/gtest.h>

// Demonstrate some basic assertions.
TEST(ParsingTest, ParsingFiles)
{
    // Expect two strings not to be equal.
    EXPECT_STRNE("hello", "hello2");
    // Expect equality.
    EXPECT_EQ(7 * 6, 42);
}
