#ifndef __LEXER_TAB_H__
#define __LEXER_TAB_H__

union YYLVAL
{
    int ival;
    double fval;
    char *sval;
};

extern union YYLVAL yylval;

extern int ymain();

#define YYSTYPE union YYLVAL

#endif