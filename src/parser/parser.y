%{
    //#include "../lexer.tab.h"
    #include <stdio.h>
    
    extern int yylex();
    extern int yyparse();
%}

%token INCLUDE NAME LPAREN RPAREN RETURN CONTINUE BREAK WHILE FOR IF 
%token T_VOID T_INT T_FLOAT T_BOOL T_STRING DECLARE TRUE FALSE FLOAT INTEGER STRING
%token PLUS MINUS TIMES DIVIDE MODULO EQ NE LT LE GT GE AND OR XOR NOT TILDE

%%

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

void yyerror ( char *s )
{
    printf("ERROR: %s\n", s);
}


int pmain() {
    printf("Parser> ");
    yyparse();
    return 0;
}
