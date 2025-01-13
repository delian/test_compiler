#define OUTPUTFILE "lexer.tkn"

#define EOF (0)
#define PLUS (1)
#define MINUS (2)
#define TIMES (3)
#define DIVIDE (4)
#define LP (5)
#define RP (6)
#define EQ (7)
#define INTEGER (8)
#define FLOAT (9)

int yylex();
void yyerror(char *s);
int yyparse();

