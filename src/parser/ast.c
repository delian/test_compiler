#include "ast.h"
#include <stdarg.h>
#include <stdio.h>

char *ast_type_to_string(AST_TYPE type)
{
  switch (type)
  {
  case AST_UNDEFINED:
    return "AST_UNDEFINED";
  case AST_PROGRAM:
    return "AST_PROGRAM";
  case AST_PROGRAM_BLOCK:
    return "AST_PROGRAM_BLOCK";
  case AST_GLOB_VARIABLE:
    return "AST_GLOB_VARIABLE";
  case AST_FUNCTION_DECLARATION:
    return "AST_FUNCTION_DECLARATION";
  case AST_DECLARE_FUNCTION:
    return "AST_DECLARE_FUNCTION";
  case AST_DECLARE_FUNCTION_NOPARM:
    return "AST_DECLARE_FUNCTION_NOPARM";
  case AST_FUNCTION_DECLARATION_NOPARM:
    return "AST_FUNCTION_DECLARATION_NOPARM";
  case AST_PARAMETERS:
    return "AST_PARAMETERS";
  case AST_PARAMETER:
    return "AST_PARAMETER";
  case AST_BLOCK_STATEMENT:
    return "AST_BLOCK_STATEMENT";
  case AST_BLOCK_STATEMENTS:
    return "AST_BLOCK_STATEMENTS";
  case AST_BLOCK_EMPTY:
    return "AST_BLOCK_EMPTY";
  case AST_STATEMENTS:
    return "AST_STATEMENTS";
  case AST_STATEMENT:
    return "AST_STATEMENT";
  case AST_IF_STATEMENT:
    return "AST_IF_STATEMENT";
  case AST_FOR_STATEMENT_3:
    return "AST_FOR_STATEMENT_3";
  case AST_FOR_STATEMENT_2:
    return "AST_FOR_STATEMENT_2";
  case AST_FOR_STATEMENT_1:
    return "AST_FOR_STATEMENT_1";
  case AST_FOR_STATEMENT_0:
    return "AST_FOR_STATEMENT_0";
  case AST_RETURN_STATEMENT_EXPRESSION:
    return "AST_RETURN_STATEMENT_EXPRESSION";
  case AST_RETURN_STATEMENT:
    return "AST_RETURN_STATEMENT";
  case AST_CONTINUE_STATEMENT:
    return "AST_CONTINUE_STATEMENT";
  case AST_CONTINUE_STATEMENT_EXPRESSION:
    return "AST_CONTINUE_STATEMENT_EXPRESSION";
  case AST_BREAK_STATEMENT:
    return "AST_BREAK_STATEMENT";
  case AST_BREAK_STATEMENT_EXPRESSION:
    return "AST_BREAK_STATEMENT_EXPRESSION";
  case AST_WHILE_STATEMENT:
    return "AST_WHILE_STATEMENT";
  case AST_BOOL_EXPRESSION:
    return "AST_BOOL_EXPRESSION";
  case AST_BOOL_EXP_XOR:
    return "AST_BOOL_EXP_XOR";
  case AST_BOOL_EXP_OR:
    return "AST_BOOL_EXP_OR";
  case AST_BOOL_EXP_AND:
    return "AST_BOOL_EXP_AND";
  case AST_BOOL_TERM:
    return "AST_BOOL_TERM";
  case AST_BOOL_TERM_NOT:
    return "AST_BOOL_TERM_NOT";
  case AST_BOOL_TERM_TILDE:
    return "AST_BOOL_TERM_TILDE";
  case AST_BOOL_FACTOR:
    return "AST_BOOL_FACTOR";
  case AST_BOOL_TRUE:
    return "AST_BOOL_TRUE";
  case AST_BOOL_FALSE:
    return "AST_BOOL_FALSE";
  case AST_EXPRESSION:
    return "AST_EXPRESSION";
  case AST_EXPRESSION_TERM_PLUS:
    return "AST_EXPRESSION_TERM_PLUS";
  case AST_EXPRESSION_TERM_MINUS:
    return "AST_EXPRESSION_TERM_MINUS";
  case AST_TERM:
    return "AST_TERM";
  case AST_TERM_TIMES:
    return "AST_TERM_TIMES";
  case AST_TERM_DIVIDE:
    return "AST_TERM_DIVIDE";
  case AST_TERM_MODULO:
    return "AST_TERM_MODULO";
  case AST_FACTOR:
    return "AST_FACTOR";
  case AST_FACTOR_VAL:
    return "AST_FACTOR_VAL";
  case AST_FACTOR_VAL_NEG:
    return "AST_FACTOR_VAL_NEG";
  case AST_VARIABLE:
    return "AST_VARIABLE";
  case AST_FUNCTION_CALL:
    return "AST_FUNCTION_CALL";
  case AST_PARAMETERS_EXP:
    return "AST_PARAMETERS_EXP";
  case AST_PARAMETER_EXP:
    return "AST_PARAMETER_EXP";
  case AST_VARIABLE_ASSIGNMENT:
    return "AST_VARIABLE_ASSIGNMENT";
  case AST_VARIABLE_DECLARATION:
    return "AST_VARIABLE_DECLARATION";
  case AST_T_VOID:
    return "AST_T_VOID";
  case AST_T_INT:
    return "AST_T_INT";
  case AST_T_FLOAT:
    return "AST_T_FLOAT";
  case AST_T_BOOL:
    return "AST_T_BOOL";
  case AST_T_STRING:
    return "AST_T_STRING";
  }
  return ssprintf("Unknown AST_TYPE %d", type);
}

AST *ast_new(AST_TYPE type)
{
  AST *node = malloc(sizeof(AST));
  node->child = NULL;
  node->type = type;
  node->len = 0;
  node->value = NULL;
  node->value_str = NULL;
  return node;
}

void ast_add(AST *node, int n, ...)
{
  va_list args;

  node->child = realloc(node->child, (node->len + n) * sizeof(AST *));
  int total = node->len + n;

  for (va_start(args, n); node->len < total; node->len++)
  {
    AST *child = va_arg(args, AST *);
    if (child == NULL)
      continue;
    // printf("node %s childlen %d < %d\n", node->type, node->len, total);
    node->child[node->len] = child;
  }

  va_end(args);
}

AST *ast_new_add(AST_TYPE type, int n, ...)
{
  AST *node = ast_new(type);
  va_list args;

  node->child = realloc(node->child, (node->len + n) * sizeof(AST *));
  int total = node->len + n;

  for (va_start(args, n); node->len < total; node->len++)
  {
    AST *child = va_arg(args, AST *);
    if (child == NULL)
      continue;
    node->child[node->len] = child;
  }

  va_end(args);

  return node;
}

void ast_free(AST *node)
{
  for (int i = 0; i < node->len; i++)
  {
    ast_free(node->child[i]);
  }
  free(node->value_str); // Explicit malloc needs to be freed. I won't do this
                         // for ->value as it often points to ELF allocated
                         // static symbols in memory which are shared constants
                         // and not allocated with malloc
  free(node->child);
  free(node);
}

void ast_print_depth(AST *node, int depth)
{
  for (int i = 0; i < depth; i++)
    printf("|  ");
  printf("Type: '%s' Value: '%s'", ast_type_to_string(node->type),
         node->value_str);
  if (node->len > 0)
    printf(" Children (%d):", node->len);
  printf("\n");
  for (int i = 0; i < node->len; i++)
    ast_print_depth(node->child[i], depth + 1);
}

void ast_print(AST *node) { ast_print_depth(node, 0); }
