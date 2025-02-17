#ifndef AST_H
#define AST_H

// #include <stdio.h>
#include <stdlib.h>

typedef struct AST AST;

typedef enum AST_TYPE
{
    AST_UNDEFINED,
    AST_PROGRAM,
    AST_PROGRAM_BLOCK,
    AST_GLOB_VARIABLE,
    AST_FUNCTION_DECLARATION,
    AST_DECLARE_FUNCTION,
    AST_DECLARE_FUNCTION_NOPARM,
    AST_FUNCTION_DECLARATION_NOPARM,
    AST_PARAMETERS,
    AST_PARAMETER,
    AST_BLOCK_STATEMENT,
    AST_BLOCK_STATEMENTS,
    AST_BLOCK_EMPTY,
    AST_STATEMENTS,
    AST_STATEMENT,
    AST_IF_STATEMENT,
    AST_FOR_STATEMENT_3,
    AST_FOR_STATEMENT_2,
    AST_FOR_STATEMENT_1,
    AST_FOR_STATEMENT_0,
    AST_RETURN_STATEMENT_EXPRESSION,
    AST_RETURN_STATEMENT,
    AST_CONTINUE_STATEMENT,
    AST_CONTINUE_STATEMENT_EXPRESSION,
    AST_BREAK_STATEMENT,
    AST_BREAK_STATEMENT_EXPRESSION,
    AST_WHILE_STATEMENT,
    AST_BOOL_EXPRESSION,
    AST_BOOL_EXP_XOR,
    AST_BOOL_EXP_OR,
    AST_BOOL_EXP_AND,
    AST_BOOL_TERM,
    AST_BOOL_TERM_NOT,
    AST_BOOL_TERM_TILDE,
    AST_BOOL_FACTOR,
    AST_BOOL_TRUE,
    AST_BOOL_FALSE,
    AST_EXPRESSION,
    AST_EXPRESSION_TERM_PLUS,
    AST_EXPRESSION_TERM_MINUS,
    AST_TERM,
    AST_TERM_TIMES,
    AST_TERM_DIVIDE,
    AST_TERM_MODULO,
    AST_FACTOR,
    AST_FACTOR_VAL,
    AST_FACTOR_VAL_NEG,
    AST_VARIABLE,
    AST_FUNCTION_CALL,
    AST_PARAMETERS_EXP,
    AST_PARAMETER_EXP,
    AST_VARIABLE_ASSIGNMENT,
    AST_VARIABLE_DECLARATION,
    AST_T_VOID,
    AST_T_INT,
    AST_T_FLOAT,
    AST_T_BOOL,
    AST_T_STRING,
} AST_TYPE;

struct AST
{
    AST_TYPE type;
    void *value;
    char *value_str;
    int len;
    AST **child;
};

extern AST *ast;
extern AST *ast_new(AST_TYPE type);
extern AST *ast_new_add(AST_TYPE type, int n, ...);
extern void ast_add(AST *node, int n, ...);
extern void ast_print(AST *node);
extern void ast_free(AST *node);

#define ssprintf(...) ({         \
    char *str = NULL;            \
    asprintf(&str, __VA_ARGS__); \
    str;                         \
})

#define value_str(node, ...) (node->value_str = ssprintf(__VA_ARGS__))

#endif
