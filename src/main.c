#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "parser/lexer.tab.h"

extern int pmain(void);

int main(void)
{
    pmain();

    return EXIT_SUCCESS;
}