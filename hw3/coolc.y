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

program :   clist       {printf("\nDone!\n");}
        ;

clist   :   clist class SYNTAX_OVER     {printf("clist 1 ");}
        |   class SYNTAX_OVER           {printf("clist 2 ");}
        ;

class   :   flist BLOCKOVER             {printf("class 1 ");}
        ;

flist   :   flist feature SYNTAX_OVER   {printf("flist 1 ");}
        |   CLASS TYPE_ID INHERITS TYPE_ID BLOCKSTART   {printf("flist 2 ");}
        |   CLASS TYPE_ID BLOCKSTART    {printf("flist 3 ");}
        ; 

feature :   IDENTIFIER_ID ITEMSTART formal_list ITEMOVER DEFINE TYPE_ID BLOCKSTART expr_list BLOCKOVER  {printf("feature 1 ");}
        |   IDENTIFIER_ID DEFINE TYPE_ID        {printf("feature 2 ");}
        |   IDENTIFIER_ID DEFINE TYPE_ID ASSIGN expr    {printf("feature 3 ");}
        ;

formal_list     :   formal_list NEXT formal {printf("formal_list 1 ");}
                |   formal      {printf("formal_list 2");}
                |   /*empty*/   {printf("formal_list 3");}
                ;

formal  :   IDENTIFIER_ID DEFINE TYPE_ID        {printf("formal 1");}
        ;

expr_list   :   expr_list expr SYNTAX_OVER      {printf("expr_list 1");}
            |   expr SYNTAX_OVER        {printf("expr_list 2");}
            ;

expr    :   object DOT IDENTIFIER_ID ITEMSTART param_list ITEMOVER        {printf("expr 1");} 
        |   IDENTIFIER_ID ITEMSTART param_list ITEMOVER         {printf("expr 2");}
        |   IDENTIFIER_ID ASSIGN expr   {printf("expr 3");}
        |   IF expr THEN expr ELSE expr FI      {printf("expr 4");}
        |   WHILE expr LOOP expr POOL   {printf("expr 4");}
        |   LET let_list IN expr        {printf("expr 5");}
        |   CASE expr OF case_list ESAC {printf("expr 6");}
        |   NEW TYPE_ID {printf("expr 7");}
        |   ISVOID expr {printf("expr 8");}
        |   expr OPERATOR expr {printf("expr 9");}
        |   NOT expr    {printf("expr 10");}
        |   LETTER      {printf("expr 11");}
        |   BOOLEAN     {printf("expr 12");}
        |   ITEMSTART expr ITEMOVER     {printf("expr 13");}
        |   IDENTIFIER_ID       {printf("expr 14");}
        ;

object  :   IDENTIFIER_ID       {printf("object 1 ");}
        |   ITEMSTART NEW TYPE_ID ITEMOVER     {printf("object 2 ");}
        ;

let_list        :   let_list NEXT let {printf("let_list 1");}
                |   let         {printf("let_list 2");}
                ;       

let     :       IDENTIFIER_ID DEFINE TYPE_ID ASSIGN expr        {printf("let 1");}
        |       IDENTIFIER_ID DEFINE TYPE_ID    {printf("let 2");}
        ;

case_list       :   case_list case SYNTAX_OVER  {printf("case_list 1");}
                |   case SYNTAX_OVER    {printf("case_list 2");}
                ;

case    :       IDENTIFIER_ID DEFINE TYPE_ID DO expr    {printf("case 1");}
        ;

param_list      :   param_list expr     {printf("param_list 1");}
                |   param_list expr NEXT        {printf("param_list 2");}
                |   /* empty */ {printf("param_list 3");}

%%

int main() {
    return yyparse();
}