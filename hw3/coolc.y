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
        |   CLASS TYPE_ID INHERITS TYPE_ID BLOCKSTART
        |   CLASS TYPE_ID BLOCKSTART 
        ; 

feature :   IDENTIFIER_ID ITEMSTART formal_list ITEMOVER DEFINE TYPE_ID BLOCKSTART expr_list BLOCKOVER 
        |   IDENTIFIER_ID DEFINE TYPE_ID 
        |   IDENTIFIER_ID DEFINE TYPE_ID ASSIGN expr 
        ;

formal_list     :   formal_list NEXT formal 
                |   formal 
                ;

formal  :   IDENTIFIER_ID DEFINE TYPE_ID
        ;

expr_list   :   expr_list expr SYNTAX_OVER
            |   expr SYNTAX_OVER 
            ;

expr    :   expr DOT IDENTIFIER_ID ITEMSTART param_list ITEMOVER 
        |   IDENTIFIER_ID ITEMSTART param_list ITEMOVER 
        |   IDENTIFIER_ID ASSIGN expr
        |   IF expr THEN expr ELSE expr FI
        |   WHILE expr LOOP expr POOL
        |   LET let_list IN expr
        |   CASE expr OF case_list ESAC
        |   NEW TYPE_ID
        |   ISVOID expr
        |   expr OPERATOR expr 
        |   NOT expr
        |   LETTER 
        |   BOOLEAN
        |   ITEMSTART expr ITEMOVER
        |   IDENTIFIER_ID
        ;

let_list        :   let_list NEXT let 
                |   let 
                ;

let     :       IDENTIFIER_ID DEFINE TYPE_ID ASSIGN expr 
        |       IDENTIFIER_ID DEFINE TYPE_ID
        ;

case_list       :   case_list case SYNTAX_OVER
                |   case SYNTAX_OVER
                ;

case    :       IDENTIFIER_ID DEFINE TYPE_ID DO expr
        ;

param_list      :   param_list expr 
                |   param_list expr NEXT 
                |   /* empty */

%%

int main() {
    return yyparse();
}