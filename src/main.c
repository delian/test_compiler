#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "parser/ast.h"

extern int pmain(void);

AST *ast;

int main(void)
{
    pmain();

    return EXIT_SUCCESS;
}