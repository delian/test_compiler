%{
    // #include "../lexer.tab.h"
    #include <stdio.h>
    
    extern int yylex();
    extern int yyparse();
%}

%token INCLUDE NAME LPAREN RPAREN RETURN CONTINUE BREAK WHILE FOR IF 
%token T_VOID T_INT T_FLOAT T_BOOL T_STRING DECLARE TRUE FALSE FLOAT INTEGER STRING
%token PLUS MINUS TIMES DIVIDE MODULO EQ NE LT LE GT GE AND OR XOR NOT TILDE
%token RBRACE LBRACE LBRACKET RBRACKET DOLLAR SEMICOLON COMMA EQUAL CARET ELSE

%start program

%%

program : program_block
        ;

program_block : /* empty */
              | program_block glob_variable
              | glob_variable
              | program_block function_declaration
              | function_declaration
              | program_block ';'
              | ';'
              | program_block declare_function
              | declare_function
              | program_block glob_include
              | glob_include
              ;

glob_include : INCLUDE NAME
             ;

glob_variable : variable_declaration ';'
              ;

declare_function : DECLARE type_spec NAME LPAREN parameters RPAREN
                 | DECLARE type_spec NAME LPAREN RPAREN
                 ;

function_declaration : type_spec NAME LPAREN parameters RPAREN block
                     | type_spec NAME LPAREN RPAREN block
;

parameters : parameters ',' parameter
           | parameter
;

parameter : type_spec NAME
;

block : statement
      | '{' statements '}'
      | '{' '}'
;

statements : statement
           | statements ';' statement
;

statement : bool_expression
          | variable_declaration
          | return_statement
          | continue_statement
          | break_statement
          | while_statement
          | for_statement
          | if_statement
          | variable_assignment
;

if_statement : IF LPAREN bool_expression RPAREN block
;

return_statement : RETURN expression
                 | RETURN
;

continue_statement : CONTINUE
                   | CONTINUE expression
;

break_statement : BREAK
                | BREAK expression
;

while_statement : WHILE LPAREN bool_expression RPAREN block
;

for_statement : FOR LPAREN statement ';' statement ';' statement RPAREN block
              | FOR LPAREN RPAREN block
              | FOR LPAREN statement RPAREN block
              | FOR LPAREN statement ';' statement RPAREN block
;

expression : expression PLUS term
           | expression MINUS term
           | term
           | string
;

term : term TIMES factor
     | term DIVIDE factor
     | term MODULO factor
     | factor
;

bool_expression : bool_expression AND bool_term
                | bool_expression OR bool_term
                | bool_expression XOR bool_term
                | bool_term
;

bool_term : bool_factor
          | NOT bool_factor
          | TILDE bool_factor
;

bool_factor : TRUE
            | FALSE
            | expression
;

string: STRING
;

factor: INTEGER
      | MINUS INTEGER
      | FLOAT
      | MINUS FLOAT
      | variable
      | function_call
      | LPAREN expression RPAREN
;

variable : NAME
;

function_call : NAME LPAREN parameters_exp RPAREN
              | NAME LPAREN RPAREN
;

variable_declaration : type_spec NAME
                     | type_spec NAME EQ expression
;

variable_assignment : NAME EQ expression
;

type_spec : T_VOID
          | T_INT
          | T_FLOAT
          | T_BOOL
          | T_STRING
;

parameters_exp : parameters_exp ',' parameter_exp
               | parameter_exp
;

parameter_exp : expression
;

%%

/* #include <readline.h> */

#include <readline/readline.h>
#include <readline/history.h>

#define HISTORYFILE ".ply_history"

typedef struct yy_buffer_state * YY_BUFFER_STATE;
extern int yyparse();
extern YY_BUFFER_STATE yy_scan_string(char * str);
extern void yypush_buffer_state(YY_BUFFER_STATE new_buffer);
extern void yy_delete_buffer(YY_BUFFER_STATE buffer);

static char *line_read = (char *)NULL;

void yyerror ( char *s )
{
    printf("ERROR: %s\n", s);
}


int pmain() {

    read_history(HISTORYFILE);
    line_read = readline("Parser> ");
    if (line_read && *line_read) add_history(line_read);
    write_history(HISTORYFILE);

    YY_BUFFER_STATE buffer = yy_scan_string(line_read);
    yypush_buffer_state(buffer);
    yyparse();
    yy_delete_buffer(buffer);
    return 0;
}
