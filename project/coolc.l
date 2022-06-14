%{
#include <stdio.h>
#include <string.h>
#define TEXT_LENGTH 80
void yyerror(const char *msg);
int cur_line = 1;

/* 以下為建立syntax tree的data structure */
struct tree_node {
        char type[TEXT_LENGTH];  //紀錄nonterminal,Class,TypeID....
        char text[TEXT_LENGTH];  //紀錄yytext
        char grammar_type[TEXT_LENGTH]; //紀錄用了哪個文法規則
        int grammar_number;     //紀錄用了文法規則的第幾個
        struct tree_node *child_head;   //記錄了所有子節點的開頭
        struct tree_node *next; //串接到下一個
};
typedef struct tree_node TreeNode;

#include "y.tab.h"
%}

%%

"-"             {strcpy(yylval.object.text,(yytext));return OPERATOR;}
[ \t\v\f\r]*  {}
\n              {cur_line++;}
"class"         {strcpy(yylval.object.text,(yytext));return CLASS;}
"inherits"	    {strcpy(yylval.object.text,(yytext));return INHERITS;}
"SELF_TYPE"	    {strcpy(yylval.object.text,(yytext));return SELF_TYPE;}
"{"             {strcpy(yylval.object.text,(yytext));return BLOCKSTART;}
"}"             {strcpy(yylval.object.text,(yytext));return BLOCKOVER;}
"("             {strcpy(yylval.object.text,(yytext));return ITEMSTART;}
")"             {strcpy(yylval.object.text,(yytext));return ITEMOVER;}
";"             {strcpy(yylval.object.text,(yytext));return SYNTAX_OVER;}
"<-"            {strcpy(yylval.object.text,(yytext));return ASSIGN;}
\".*\"          {strcpy(yylval.object.text,(yytext));return LETTER;}	
false|true      {strcpy(yylval.object.text,(yytext));return BOOLEAN;}
"if"            {strcpy(yylval.object.text,(yytext));return IF;}
"then"          {strcpy(yylval.object.text,(yytext));return THEN;}
"else"          {strcpy(yylval.object.text,(yytext));return ELSE;}
"fi"            {strcpy(yylval.object.text,(yytext));return FI;}
"not"   	    {strcpy(yylval.object.text,(yytext));return NOT;}
"while"     	{strcpy(yylval.object.text,(yytext));return WHILE;}
"loop"	    	{strcpy(yylval.object.text,(yytext));return LOOP;}
"case" 	        {strcpy(yylval.object.text,(yytext));return CASE;}
"pool"  		{strcpy(yylval.object.text,(yytext));return POOL;}
"of"	    	{strcpy(yylval.object.text,(yytext));return OF;}
"esac"	    	{strcpy(yylval.object.text,(yytext));return ESAC;}
"=>"		    {strcpy(yylval.object.text,(yytext));return DO;}
"new"	    	{strcpy(yylval.object.text,(yytext));return NEW;}
"isvoid"	    {strcpy(yylval.object.text,(yytext));return ISVOID;}
"let"   		{strcpy(yylval.object.text,(yytext));return LET;}
"in"	    	{strcpy(yylval.object.text,(yytext));return IN;}
"end"           {strcpy(yylval.object.text,(yytext));return END;}
"self"          {strcpy(yylval.object.text,(yytext));return SELF;}
"@"             {strcpy(yylval.object.text,(yytext));return AT;}
"~"             {strcpy(yylval.object.text,(yytext));return INT_COMP;}
"<="	        {strcpy(yylval.object.text,(yytext));return OPERATOR;}
"<"             {strcpy(yylval.object.text,(yytext));return OPERATOR;}
[*+/=]          {strcpy(yylval.object.text,(yytext));return OPERATOR;}
[0-9]+      	{strcpy(yylval.object.text,(yytext));return DIGIT;}
[A-Z][a-zA-Z0-9]*   {strcpy(yylval.object.text,(yytext));return TYPE_ID;}
[a-z][a-zA-Z0-9]*_[a-zA-Z0-9]*  {strcpy(yylval.object.text,(yytext));return IDENTIFIER_ID;}
[a-z][a-zA-Z0-9]*   {strcpy(yylval.object.text,(yytext));return IDENTIFIER_ID;}
"."             {strcpy(yylval.object.text,(yytext));return DOT;}
","             {strcpy(yylval.object.text,(yytext));return NEXT;}
":"             {strcpy(yylval.object.text,(yytext));return DEFINE;}
.               {yyerror(yytext);}

%%

int yywrap(void) { 
    return 1;
}

void yyerror(const char *msg) {
    printf("Error at line %d:\n\t%s\n", cur_line, msg);
    exit(1);
}