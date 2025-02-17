%option noyywrap nodefault stack debug

%x COMMENT
%x INCLUDE
%x QUOTE_STRING
%x APOSTROPHE_STRING

%{
#include <stdio.h>
#include <ast.h>
#include "bison_parser.h"

#define MAX_INCLUDE_DEPTH 10
YY_BUFFER_STATE include_stack[MAX_INCLUDE_DEPTH];
int include_stack_top = 0;
%}


%%

[ \t\n]                     ;
\/\*                        BEGIN(COMMENT); // Change a state and ignore multiline comments
<COMMENT>{
    [^*\n]*                 ;
    \n                      ;
    \*+[^*/\n]*             ;
    \*+\/                   BEGIN(INITIAL);
}
#.*                         ; // Ignore a comment in a single line
[0-9]+\.[0-9]*              { yylval.fval = atof(yytext); return FLOAT; }
[0-9]+                      { yylval.ival = atoi(yytext); return INTEGER; }
\"                          { 
                                yylval.sval = strdup("");
                                BEGIN(QUOTE_STRING); 
                            }
\'                          { 
                                yylval.sval = strdup("");
                                BEGIN(APOSTROPHE_STRING);
                            }
<QUOTE_STRING,APOSTROPHE_STRING>\\. {
                                char *sval;
                                switch (yytext[1]) {
                                    case 'n': {
                                        sval = ssprintf("%s\n", yylval.sval);
                                        break;
                                    }
                                    case 't': {
                                        sval = ssprintf("%s\t", yylval.sval);
                                        break;
                                    }
                                    case 'r': {
                                        sval = ssprintf("%s\r", yylval.sval);
                                        break;
                                    }
                                    case '0': {
                                        sval = ssprintf("%s\0", yylval.sval);
                                        break;
                                    }
                                    default: {
                                        sval = ssprintf("%s%c", yylval.sval, yytext[1]);
                                    }

                                }
                                free(yylval.sval);
                                yylval.sval = sval;
                            }
<QUOTE_STRING>[^\\"]*       {
                                char *sval = ssprintf("%s%s", yylval.sval, yytext);
                                free(yylval.sval);
                                yylval.sval = sval;
                            }
<APOSTROPHE_STRING>[^\\']*  {
                                char *sval = ssprintf("%s%s", yylval.sval, yytext);
                                free(yylval.sval);
                                yylval.sval = sval;
                            }
<QUOTE_STRING>\"            { BEGIN(INITIAL); return STRING; }
<APOSTROPHE_STRING>\'       { BEGIN(INITIAL); return STRING; }
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
include                     { BEGIN(INCLUDE); }
<INCLUDE>{
    [ \t]                   ;
    [a-zA-Z0-9_\/\-\.]+     { 
                                if (include_stack_top >= MAX_INCLUDE_DEPTH) {
                                    fprintf(stderr, "Include depth is too deep\n");
                                    yyterminate();
                                }
                                include_stack[include_stack_top++] = YY_CURRENT_BUFFER;
                                yyin = fopen(yytext, "r");
                                if (!yyin) {
                                    fprintf(stderr, "Cannot open include file: %s\n", yytext);
                                    yyterminate();
                                }
                                yy_switch_to_buffer(yy_create_buffer( yyin, YY_BUF_SIZE));
                                BEGIN(INITIAL);
                            }
}


[a-zA-Z_\$][a-zA-Z0-9_\$]*  { yylval.sval = strdup(yytext); return NAME; }

.                           { 
                                fprintf(stderr, "Tokenizing error: '%c'\n", *yytext); 
                                yyterminate(); 
                            }
<<EOF>>                     {
                                if (include_stack_top > 0) {
                                    fclose(yyin);
                                    yy_delete_buffer(YY_CURRENT_BUFFER);
                                    yy_switch_to_buffer(include_stack[--include_stack_top]);
                                } else 
                                    yyterminate();
                            }

%%
