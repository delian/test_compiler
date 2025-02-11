%option noyywrap nodefault debug

%x COMMENT

%{
#include "../temp/bison_parser.h"
%}


%%

[ \t\n]                     ;
\/\*                        BEGIN(COMMENT);
<COMMENT>[^*\n]*            ;
<COMMENT>\n                 ;
<COMMENT>\*+[^*/\n]*        ;
<COMMENT>\*+\/              BEGIN(INITIAL);
#.*                         ; // Ignore a comment
[0-9]+\.[0-9]*              { yylval.fval = atof(yytext); return FLOAT; }
[0-9]+                      { yylval.ival = atoi(yytext); return INTEGER; }
"+"                         { return PLUS; }
"-"                         { return MINUS; }
"*"                         { return TIMES; }
"/"                         { return DIVIDE; }
"("                         { return LPAREN; }
")"                         { return RPAREN; }
"{"                         { return LBRACE; }
"}"                         { return RBRACE; }
"["                         { return LBRACKET; }
"]"                         { return RBRACKET; }
\$                          { return DOLLAR; }
";"                         { return SEMICOLON; }
","                         { return COMMA; }
"^"                         { return CARET; }
\~                          { return TILDE; }
"%"                         { return MODULO; }
"=="                        { return EQUAL; }
"="                         { return EQ; }
"!="                        { return NE; }
"<"                         { return LT; }
"<="                        { return LE; }
">"                         { return GT; }
">="                        { return GE; }
"&&"                        { return AND; }
"||"                        { return OR; }
"!"                         { return NOT; }
if                          { return IF; }
else                        { return ELSE; }
while                       { return WHILE; }
for                         { return FOR; }
return                      { return RETURN; }
continue                    { return CONTINUE; }
break                       { return BREAK; }
and                         { return AND; }
or                          { return OR; }
xor                         { return XOR; }
not                         { return NOT; }
true                        { return TRUE; }
false                       { return FALSE; }
void                        { return T_VOID; }
int                         { return T_INT; }
float                       { return T_FLOAT; }
bool                        { return T_BOOL; }
string                      { return T_STRING; }
declare                     { return DECLARE; }
include                     { return INCLUDE; }
[a-zA-Z_\$][a-zA-Z0-9_\$]*  { yylval.sval = strdup(yytext); return NAME; }

.                           { 
                                fprintf(stderr, "Tokenizing error: '%c'\n", *yytext); 
                                yyterminate(); 
                            }

%%
