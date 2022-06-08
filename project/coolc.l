%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}

%%

"-"             {strcpy(yylval.object.node.text,(yytext));return OPERATOR;}
[ \t\v\f\r\n]*  {}
"class"         {strcpy(yylval.object.node.text,(yytext));return CLASS;}
"inherits"	    {strcpy(yylval.object.node.text,(yytext));return INHERITS;}
"SELF_TYPE"	    {strcpy(yylval.object.node.text,(yytext));return SELF_TYPE;}
"{"             {strcpy(yylval.object.node.text,(yytext));return BLOCKSTART;}
"}"             {strcpy(yylval.object.node.text,(yytext));return BLOCKOVER;}
"("             {strcpy(yylval.object.node.text,(yytext));return ITEMSTART;}
")"             {strcpy(yylval.object.node.text,(yytext));return ITEMOVER;}
";"             {strcpy(yylval.object.node.text,(yytext));return SYNTAX_OVER;}
"<-"            {strcpy(yylval.object.node.text,(yytext));return ASSIGN;}
\".*\"          {strcpy(yylval.object.node.text,(yytext));return LETTER;}	
false|true      {strcpy(yylval.object.node.text,(yytext));return BOOLEAN;}
"if"            {strcpy(yylval.object.node.text,(yytext));return IF;}
"then"          {strcpy(yylval.object.node.text,(yytext));return THEN;}
"else"          {strcpy(yylval.object.node.text,(yytext));return ELSE;}
"fi"            {strcpy(yylval.object.node.text,(yytext));return FI;}
"not"   	    {strcpy(yylval.object.node.text,(yytext));return NOT;}
"while"     	{strcpy(yylval.object.node.text,(yytext));return WHILE;}
"loop"	    	{strcpy(yylval.object.node.text,(yytext));return LOOP;}
"case" 	        {strcpy(yylval.object.node.text,(yytext));return CASE;}
"pool"  		{strcpy(yylval.object.node.text,(yytext));return POOL;}
"of"	    	{strcpy(yylval.object.node.text,(yytext));return OF;}
"esac"	    	{strcpy(yylval.object.node.text,(yytext));return ESAC;}
"=>"		    {strcpy(yylval.object.node.text,(yytext));return DO;}
"new"	    	{strcpy(yylval.object.node.text,(yytext));return NEW;}
"isvoid"	    {strcpy(yylval.object.node.text,(yytext));return ISVOID;}
"let"   		{strcpy(yylval.object.node.text,(yytext));return LET;}
"in"	    	{strcpy(yylval.object.node.text,(yytext));return IN;}
"end"           {strcpy(yylval.object.node.text,(yytext));return END;}
"self"          {strcpy(yylval.object.node.text,(yytext));return SELF;}
"@"             {strcpy(yylval.object.node.text,(yytext));return AT;}
"~"             {strcpy(yylval.object.node.text,(yytext));return INT_COMP;}
"<="	        {strcpy(yylval.object.node.text,(yytext));return OPERATOR;}
"<"             {strcpy(yylval.object.node.text,(yytext));return OPERATOR;}
[*+/=]          {strcpy(yylval.object.node.text,(yytext));return OPERATOR;}
[0-9]+      	{strcpy(yylval.object.node.text,(yytext));return DIGIT;}
[A-Z][a-zA-Z0-9]*   {strcpy(yylval.object.node.text,(yytext));return TYPE_ID;}
[a-z][a-zA-Z0-9]*_[a-zA-Z0-9]*  {strcpy(yylval.object.node.text,(yytext));return IDENTIFIER_ID;}
[a-z][a-zA-Z0-9]*   {strcpy(yylval.object.node.text,(yytext));return IDENTIFIER_ID;}
"."             {strcpy(yylval.object.node.text,(yytext));return DOT;}
","             {strcpy(yylval.object.node.text,(yytext));return NEXT;}
":"             {strcpy(yylval.object.node.text,(yytext));return DEFINE;}

%%

int yywrap(void) { 
    return 1;
}