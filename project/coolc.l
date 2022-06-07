%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}

%%

"-"             {strcpy(yylval.node.text,(yytext));return OPERATOR;}
[ \t\v\f\r\n]*  {}
"class"         {strcpy(yylval.node.text,(yytext));return CLASS;}
"inherits"	    {strcpy(yylval.node.text,(yytext));return INHERITS;}
"SELF_TYPE"	    {strcpy(yylval.node.text,(yytext));return SELF_TYPE;}
"{"             {strcpy(yylval.node.text,(yytext));return BLOCKSTART;}
"}"             {strcpy(yylval.node.text,(yytext));return BLOCKOVER;}
"("             {strcpy(yylval.node.text,(yytext));return ITEMSTART;}
")"             {strcpy(yylval.node.text,(yytext));return ITEMOVER;}
";"             {strcpy(yylval.node.text,(yytext));return SYNTAX_OVER;}
"<-"            {strcpy(yylval.node.text,(yytext));return ASSIGN;}
\".*\"          {strcpy(yylval.node.text,(yytext));return LETTER;}	
false|true      {strcpy(yylval.node.text,(yytext));return BOOLEAN;}
"if"            {strcpy(yylval.node.text,(yytext));return IF;}
"then"          {strcpy(yylval.node.text,(yytext));return THEN;}
"else"          {strcpy(yylval.node.text,(yytext));return ELSE;}
"fi"            {strcpy(yylval.node.text,(yytext));return FI;}
"not"   	    {strcpy(yylval.node.text,(yytext));return NOT;}
"while"     	{strcpy(yylval.node.text,(yytext));return WHILE;}
"loop"	    	{strcpy(yylval.node.text,(yytext));return LOOP;}
"case" 	        {strcpy(yylval.node.text,(yytext));return CASE;}
"pool"  		{strcpy(yylval.node.text,(yytext));return POOL;}
"of"	    	{strcpy(yylval.node.text,(yytext));return OF;}
"esac"	    	{strcpy(yylval.node.text,(yytext));return ESAC;}
"=>"		    {strcpy(yylval.node.text,(yytext));return DO;}
"new"	    	{strcpy(yylval.node.text,(yytext));return NEW;}
"isvoid"	    {strcpy(yylval.node.text,(yytext));return ISVOID;}
"let"   		{strcpy(yylval.node.text,(yytext));return LET;}
"in"	    	{strcpy(yylval.node.text,(yytext));return IN;}
"end"           {strcpy(yylval.node.text,(yytext));return END;}
"self"          {strcpy(yylval.node.text,(yytext));return SELF;}
"@"             {strcpy(yylval.node.text,(yytext));return AT;}
"~"             {strcpy(yylval.node.text,(yytext));return INT_COMP;}
"<="	        {strcpy(yylval.node.text,(yytext));return OPERATOR;}
"<"             {strcpy(yylval.node.text,(yytext));return OPERATOR;}
[*+/=]          {strcpy(yylval.node.text,(yytext));return OPERATOR;}
[0-9]+      	{strcpy(yylval.node.text,(yytext));return DIGIT;}
[A-Z][a-zA-Z0-9]*   {strcpy(yylval.node.text,(yytext));return TYPE_ID;}
[a-z][a-zA-Z0-9]*_[a-zA-Z0-9]*  {strcpy(yylval.node.text,(yytext));return IDENTIFIER_ID;}
[a-z][a-zA-Z0-9]*   {strcpy(yylval.node.text,(yytext));return IDENTIFIER_ID;}
"."             {strcpy(yylval.node.text,(yytext));return DOT;}
","             {strcpy(yylval.node.text,(yytext));return NEXT;}
":"             {strcpy(yylval.node.text,(yytext));return DEFINE;}

%%

int yywrap(void) { 
    return 1;
}