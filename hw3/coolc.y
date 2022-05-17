%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYSTYPE char *
void yyerror(const char* msg) {}
%}

%token CLASS BLOCKSTART BLOCKOVER ITEMSTART ITEMOVER SYNTAX_OVER LETTER TYPE_ID IDENTIFIER_ID DOT DEFINE 
%token INHERITS SELF_TYPE ASSIGN BOOLEAN IF THEN ELSE FI NOT WHILE LOOP CASE POOL OF ESAC DO NEW ISVOID
%token LET IN END OPERATOR DIGIT NEXT AT INT_COMP
%right ASSIGN NOT ISVOID INT_COMP
%left AT DOT OPERATOR
%%

program :   clist       {printf("\nDone!\n");}
        ;

clist   :   clist class SYNTAX_OVER     {printf("clist 1 ");}
        |   class SYNTAX_OVER           {printf("clist 2 ");}
        ;

class   :   CLASS TYPE_ID BLOCKSTART flist_opt BLOCKOVER        {printf("class 1 ");}
        |   CLASS TYPE_ID INHERITS TYPE_ID BLOCKSTART flist_opt BLOCKOVER        {printf("class 2 ");}
        ;

flist_opt       :   flist       {printf("flist_opt 1 ");}
                |   /*empty*/

flist   :   flist feature SYNTAX_OVER   {printf("flist 1 ");}
        |   feature     {printf("flist 2 ");}
        ; 

feature :   IDENTIFIER_ID ITEMSTART formal_list ITEMOVER DEFINE TYPE_ID BLOCKSTART expr BLOCKOVER  {printf("feature 1 ");}
        |   IDENTIFIER_ID ITEMSTART ITEMOVER DEFINE TYPE_ID BLOCKSTART expr BLOCKOVER  {printf("feature 2 ");}
        |   IDENTIFIER_ID DEFINE TYPE_ID ASSIGN expr    {printf("feature 3 ");}
        |   IDENTIFIER_ID DEFINE TYPE_ID
        ;

formal_list     :   formal_list NEXT formal {printf("formal_list 1 ");}
                |   formal      {printf("formal_list 2");}
                ;

formal  :   IDENTIFIER_ID DEFINE TYPE_ID        {printf("formal 1");}
        ;

block_list      :   block_list expr SYNTAX_OVER         
                |   expr SYNTAX_OVER
                ;

arguments_list  :   arguments
                |   /*empty*/
                ;

arguments       :   arguments NEXT expr 
                |   expr
                ;

action_list     :   action_list action 
                |   action 
                ;

action  :   IDENTIFIER_ID DEFINE TYPE_ID DO expr SYNTAX_OVER
        ;

let_expr        :   LET IDENTIFIER_ID DEFINE TYPE_ID IN expr 
                |   nest_let NEXT LET IDENTIFIER_ID DEFINE TYPE_ID
                |   LET IDENTIFIER_ID DEFINE TYPE_ID ASSIGN expr IN expr 
                |   nest_let NEXT LET IDENTIFIER_ID DEFINE TYPE_ID ASSIGN expr 
                ;

nest_let        :   IDENTIFIER_ID DEFINE TYPE_ID IN expr 
                |   nest_let NEXT IDENTIFIER_ID DEFINE TYPE 
                |   IDENTIFIER_ID DEFINE TYPE_ID IN expr IN expr 
                |   nest_let NEXT IDENTIFIER_ID DEFINE TYPE_ID ASSIGN expr 
                ;

expr    :   IDENTIFIER_ID
        |   DIGIT
        |   BOOLEAN
        |   LETTER
        |   SELF 
        |   BLOCKSTART block_list BLOCKOVER
        |   IDENTIFIER_ID ASSIGN expr 
        |   expr DOT IDENTIFIER_ID ITEMSTART arguments_list ITEMOVER
        |   expr AT TYPE_ID DOT IDENTIFIER_ID ITEMSTART arguments_list ITEMOVER
        |   IDENTIFIER_ID ITEMSTART arguments_list ITEMOVER
        |   expr OPERATOR expr 
        |   ITEMSTART expr ITEMOVER
        |   IF expr THEN expr ELSE expr FI 
        |   WHILE expr LOOP expr POOL
        |   let_expr
        |   CASE expr OF action_list ESAC
        |   NEW TYPE_ID
        |   ISVOID expr 
        |   NOT expr 
        |   INT_COMP expr 
        ;

%%

int main() {
    return yyparse();
}