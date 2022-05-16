%{
#define YYSTYPE char *
#include "y.tab.h"
%}

%%

"class"         {return CLASS;}
"{"             {return BLOCKSTART;}
"}"             {return BLOCKOVER;}
"("             {return ITEMSTART;}
")"             {return ITEMOVER;}
";"             {return SYNTAX_OVER;}
\".*\"          {yylval = strdup(yytext);return LETTER;}	
[A-Z][a-zA-Z0-9]*   {yylval = strdup(yytext);return TYPE_ID;}
[a-z][a-zA-Z0-9]*_[a-zA-Z0-9]*  {yylval = strdup(yytext);return IDENTIFIER_ID;}
[a-z][a-zA-Z0-9]*   {yylval = strdup(yytext);return IDENTIFIER_ID;}
[ \t\v\f\r\n]*   {}
"."             {return DOT;}
":"             {return DEFINE;}

%%

int yywrap(void) { 
    return 1;
}