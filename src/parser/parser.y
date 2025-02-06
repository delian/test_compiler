%{
    #include <stdio.h>
    #include "../ast.h"
    
    extern int yylex();
    extern int yyparse();
    void yyerror(char *s);
%}

%union {
    int ival;
    int fval;
    char *sval;
    struct AST *ast;
}

%token <fval> FLOAT
%token <ival> INTEGER
%token <sval> NAME
%token SEMICOLON
%token COMMA
%token INCLUDE LPAREN RPAREN RETURN CONTINUE BREAK WHILE FOR IF 
%token T_VOID T_INT T_FLOAT T_BOOL T_STRING 
%token DECLARE TRUE FALSE
%token PLUS MINUS TIMES DIVIDE MODULO EQ AND OR XOR NOT TILDE
%token RBRACE LBRACE
%token LBRACKET RBRACKET DOLLAR EQUAL CARET ELSE NE LT LE GT GE

%start program

%type <ast> program_block program
%type <ast> type_spec variable_declaration variable_assignment parameter_exp
%type <ast> parameters_exp function_call variable factor_val factor term_modulo term_times term_divide term
%type <ast> expression_term_minus expression_term_plus expression
%type <ast> bool_expression bool_term bool_factor bool_true bool_false bool_term_not bool_term_tilde
%type <ast> bool_exp_and bool_exp_or bool_exp_xor
%type <ast> while_statement block break_statement continue_statement return_statement
%type <ast> if_statement for_statement statement statements parameter parameters
%type <ast> function_declaration declare_function glob_variable glob_include

%%

program: program_block {
    // $$ = $1;
    ast = $1;
    // printf("Program TYPE: %s\n", $1->type);
};

program_block: program_block glob_variable { $$ = $1; ast_add($$, 1, $2); }
             | glob_variable { $$ = ast_new("program_block"); ast_add($$, 1, $1); }
             | program_block function_declaration { $$ = $1; ast_add($$, 1, $2); }
             | function_declaration { $$ = ast_new("program_block"); ast_add($$, 1, $1); }
             | program_block SEMICOLON { $$ = $1; }
             | SEMICOLON {} // Empty statement
             | program_block declare_function { $$ = $1; ast_add($$, 1, $2); }
             | declare_function { $$ = ast_new("program_block"); ast_add($$, 1, $1); }
             | program_block glob_include { $$ = $1; ast_add($$, 1, $2); }
             | glob_include { $$ = ast_new("program_block"); ast_add($$, 1, $1); };

glob_include: INCLUDE NAME { $$ = ast_new("glob_include"); $$->value = $2; }; // This have to be implemented in the parser and skipping the AST itself

glob_variable: variable_declaration SEMICOLON { $$ = ast_new("glob_variable"); ast_add($$, 1, $1); };

declare_function: DECLARE type_spec NAME LPAREN parameters RPAREN { $$ = ast_new("declare_function"); ast_add($$, 2, $2, $5); $$->value = $3; }
                | DECLARE type_spec NAME LPAREN RPAREN { $$ = ast_new("declare_function_noparm"); $$->value = $3; ast_add($$, 1, $2); };

function_declaration: type_spec NAME LPAREN parameters RPAREN block { $$ = ast_new("function_declaration"); $$->value = $2; ast_add($$, 3, $1, $4, $6); }
                    | type_spec NAME LPAREN RPAREN block { $$ = ast_new("function_declaration_noparm"); $$->value = $2; ast_add($$, 2, $1, $5); };

parameters: parameters COMMA parameter { $$ = $1; ast_add($$, 1, $3); }
          | parameter { $$ = ast_new("parameters"); ast_add($$, 1, $1); };

parameter: type_spec NAME { $$ = ast_new("parameter"); ast_add($$, 1, $1); $$->value = $2; };

block: statement { $$ = ast_new("block_statement"); ast_add($$, 1, $1); }
     | LBRACE statements RBRACE { $$ = ast_new("block_statements"); ast_add($$, 1, $2); }
     | LBRACE RBRACE { $$ = ast_new("block_empty"); };

statements: statement { $$ = ast_new("statements"); ast_add($$, 1, $1); }
          | statements SEMICOLON statement { $$ = $1; ast_add($$, 1, $3); };

statement: bool_expression { $$ = ast_new("statement"); ast_add($$, 1, $1); }
         | variable_declaration { $$ = ast_new("statement"); ast_add($$, 1, $1); }
         | return_statement { $$ = ast_new("statement"); ast_add($$, 1, $1); }
         | continue_statement { $$ = ast_new("statement"); ast_add($$, 1, $1); }
         | break_statement { $$ = ast_new("statement"); ast_add($$, 1, $1); }
         | while_statement { $$ = ast_new("statement"); ast_add($$, 1, $1); }
         | for_statement { $$ = ast_new("statement"); ast_add($$, 1, $1); }
         | variable_assignment { $$ = ast_new("statement"); ast_add($$, 1, $1); }
         | if_statement { $$ = ast_new("statement"); ast_add($$, 1, $1); };

if_statement: IF LPAREN bool_expression RPAREN block { $$ = ast_new("if_statement"); ast_add($$, 2, $3, $5); };

for_statement: FOR LPAREN statement SEMICOLON statement SEMICOLON statement RPAREN block { $$ = ast_new("for_statement_3"); ast_add($$, 4, $3, $5, $7, $9); }
             | FOR LPAREN RPAREN block { $$ = ast_new("for_statement_0"); ast_add($$, 1, $4); }
             | FOR LPAREN statement RPAREN block { $$ = ast_new("for_statement_1"); ast_add($$, 2, $3, $5); }
             | FOR LPAREN statement SEMICOLON statement RPAREN block { $$ = ast_new("for_statement_2"); ast_add($$, 3, $3, $5, $7); };

return_statement: RETURN expression { $$ = ast_new("return_statement_expression"); ast_add($$, 1, $2); }
                | RETURN { $$ = ast_new("return_statement"); };

continue_statement: CONTINUE { $$ = ast_new("continue_statement"); }
                  | CONTINUE expression { $$ = ast_new("continue_statement_expression"); ast_add($$, 1, $2); };

break_statement: BREAK { $$ = ast_new("break_statement"); }
               | BREAK expression { $$ = ast_new("break_statement_expression"); ast_add($$, 1, $2); };

while_statement: WHILE LPAREN bool_expression RPAREN block { $$ = ast_new("while_statement"); ast_add($$, 2, $3, $5); };

bool_expression: bool_exp_xor { $$ = ast_new("bool_expression"); ast_add($$, 1, $1); }
               | bool_exp_or { $$ = ast_new("bool_expression"); ast_add($$, 1, $1); }
               | bool_exp_and { $$ = ast_new("bool_expression"); ast_add($$, 1, $1); }
               | bool_term { $$ = ast_new("bool_expression"); ast_add($$, 1, $1); };

bool_exp_xor: bool_expression XOR bool_term { $$ = ast_new("bool_exp_xor"); ast_add($$, 2, $1, $3); };
bool_exp_or: bool_expression OR bool_term { $$ = ast_new("bool_exp_or"); ast_add($$, 2, $1, $3); };
bool_exp_and: bool_expression AND bool_term { $$ = ast_new("bool_exp_and"); ast_add($$, 2, $1, $3); };

bool_term: bool_factor { $$ = ast_new("bool_term"); ast_add($$, 1, $1); }
         | bool_term_tilde { $$ = ast_new("bool_term"); ast_add($$, 1, $1); }
         | bool_term_not { $$ = ast_new("bool_term"); ast_add($$, 1, $1); };

bool_term_not: NOT bool_factor { $$ = ast_new("bool_term_not"); ast_add($$, 1, $2); };
bool_term_tilde: TILDE bool_factor { $$ = ast_new("bool_term_tilde"); ast_add($$, 1, $2); };

bool_factor: bool_true { $$ = ast_new("bool_factor"); ast_add($$, 1, $1); }
           | bool_false { $$ = ast_new("bool_factor"); ast_add($$, 1, $1); }
           | expression { $$ = ast_new("bool_factor"); ast_add($$, 1, $1); };


bool_true: TRUE { $$ = ast_new("bool_true"); $$->value = &(int){1}; };
bool_false: FALSE { $$ = ast_new("bool_false"); $$->value = &(int){0}; };

expression: expression_term_plus { $$ = ast_new("expression"); ast_add($$, 1, $1); }
          | expression_term_minus { $$ = ast_new("expression"); ast_add($$, 1, $1); }
          | term { $$ = ast_new("expression"); ast_add($$, 1, $1); };

expression_term_plus: expression PLUS term { $$ = ast_new("expression_term_plus"); ast_add($$, 2, $1, $3); };
expression_term_minus: expression MINUS term { $$ = ast_new("expression_term_minus"); ast_add($$, 2, $1, $3); };

term: term_times { $$ = ast_new("term"); ast_add($$, 1, $1); }
    | term_divide { $$ = ast_new("term"); ast_add($$, 1, $1); }
    | term_modulo { $$ = ast_new("term"); ast_add($$, 1, $1); }
    | factor { $$ = ast_new("term"); ast_add($$, 1, $1); };

term_times: term TIMES factor { $$ = ast_new("term_times"); ast_add($$, 2, $1, $3); }; 
term_divide: term DIVIDE factor { $$ = ast_new("term_divide"); ast_add($$, 2, $1, $3); };
term_modulo: term MODULO factor { $$ = ast_new("term_modulo"); ast_add($$, 2, $1, $3); };

factor: LPAREN expression RPAREN { $$ = ast_new("factor"); ast_add($$, 1, $2); }
      | factor_val { $$ = ast_new("factor"); ast_add($$, 1, $1); }
      | variable { $$ = ast_new("factor"); ast_add($$, 1, $1); }
      | function_call { $$ = ast_new("factor"); ast_add($$, 1, $1); };

factor_val: INTEGER { $$ = ast_new("factor_val"); $$->value = &(int){$1}; } // Annonymous re-allocation of a value
      | MINUS INTEGER { $$ = ast_new("factor_val_neg"); $$->value = &(int){$2}; }
      | FLOAT { $$ = ast_new("factor_val"); $$->value = &(float){$1}; }
      | MINUS FLOAT { $$ = ast_new("factor_val_neg"); $$->value = &(float){$2}; };

variable: NAME { $$ = ast_new("variable"); $$->value = $1; };

function_call: NAME LPAREN parameters_exp RPAREN { $$ = ast_new("function_call"); $$->value = $1; ast_add($$, 1, $3); }
             | NAME LPAREN RPAREN { $$ = ast_new("function_call"); $$->value = $1; };

parameters_exp: parameters_exp COMMA parameter_exp { $$ = $1; ast_add($$, 1, $3); }
              | parameter_exp { $$ = ast_new("parameters_exp"); ast_add($$, 1, $1); };

parameter_exp: expression { $$ = ast_new("parameter_exp"); ast_add($$, 1, $1); };

variable_assignment: NAME EQ expression { $$ = ast_new("variable_assignment"); $$->value = $1; ast_add($$, 1, $3); };

variable_declaration: type_spec NAME EQ expression { $$ = ast_new("variable_declaration"); $$->value = $2; ast_add($$, 1, $4); }
                    | type_spec NAME { $$ = ast_new("variable_declaration"); $$->value = $2; };

type_spec: T_VOID { $$ = ast_new("void"); }
         | T_INT { $$ = ast_new("int"); }
         | T_FLOAT { $$ = ast_new("float"); }
         | T_BOOL { $$ = ast_new("bool"); }
         | T_STRING { $$ = ast_new("string"); };

%%

#include <readline/readline.h>
#include <readline/history.h>

#define HISTORYFILE ".ply_history"

AST *ast;

typedef struct yy_buffer_state * YY_BUFFER_STATE;
extern int yyparse();
extern YY_BUFFER_STATE yy_scan_string(char * str);
extern void yypush_buffer_state(YY_BUFFER_STATE new_buffer);
extern void yy_delete_buffer(YY_BUFFER_STATE buffer);

static char *line_read = (char *)NULL;

void yyerror ( char *s ) {
    printf("ERROR: %s\n", s);
}


int pmain() {

    read_history(HISTORYFILE);
    while(1) {
        line_read = readline("Parser> ");
        if ((!line_read)||(!*line_read)) break;
        add_history(line_read);
        write_history(HISTORYFILE);

        printf("line_read: '%s'\n", line_read);

        YY_BUFFER_STATE buffer = yy_scan_string(line_read);
        yypush_buffer_state(buffer);
        yyparse();
        yy_delete_buffer(buffer);

        printf("\n");
        ast_print(ast);
        /* ast_free(ast);
        ast = NULL; */
    }
    return 0;
}
