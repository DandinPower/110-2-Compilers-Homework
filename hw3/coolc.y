%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYSTYPE char *
void yyerror(const char* msg) {}
%}

%token CLASS BLOCKSTART BLOCKOVER ITEMSTART ITEMOVER SYNTAX_OVER LETTER TYPE_ID IDENTIFIER_ID DOT DEFINE 
%token INHERITS SELF_TYPE ASSIGN BOOLEAN IF THEN ELSE FI NOT WHILE LOOP CASE POOL OF ESAC DO NEW ISVOID
%token LET IN END OPERATOR DIGIT NEXT
%%

program :   clist       {printf("Done!\n");}
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
        |   IDENTIFIER_ID DEFINE TYPE_ID ASSIGN expr 
        ;

expr_list   :   expr_list expr SYNTAX_OVER
            |   expr SYNTAX_OVER 
            ;

expr    :   IDENTIFIER_ID DOT IDENTIFIER_ID ITEMSTART param_list ITEMOVER    { printf("%s\n",$5); }
        |   IF expr THEN expr ELSE expr FI
        |   LETTER 
        |   BOOLEAN
        |   IDENTIFIER_ID
        ;

param_list      :   param_list expr 
                |   param_list expr NEXT 
                |   /* empty */

%%

int main() {
    return yyparse();
}