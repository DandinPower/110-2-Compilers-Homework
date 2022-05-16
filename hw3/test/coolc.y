%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYSTYPE char *
void yyerror(const char* msg) {}
%}

%token CLASS BLOCKSTART BLOCKOVER ITEMSTART ITEMOVER SYNTAX_OVER LETTER TYPE_ID IDENTIFIER_ID DOT DEFINE 

%%

program :   clist
        ;

clist   :   clist class SYNTAX_OVER 
        |   class SYNTAX_OVER 
        ;

class   :   flist BLOCKOVER 
        ;

flist   :   flist feature SYNTAX_OVER 
        |   CLASS TYPE_ID BLOCKSTART 
        ; 

feature :   IDENTIFIER_ID ITEMSTART ITEMOVER DEFINE TYPE_ID BLOCKSTART expr_list BLOCKOVER 
        |   IDENTIFIER_ID DEFINE TYPE_ID 
        ;

expr_list   :   expr_list expr SYNTAX_OVER
            |   expr SYNTAX_OVER 
            ;

expr    :   IDENTIFIER_ID DOT IDENTIFIER_ID ITEMSTART LETTER ITEMOVER    { printf("%s\n",$5); }
        ;

%%

int main() {
    return yyparse();
}