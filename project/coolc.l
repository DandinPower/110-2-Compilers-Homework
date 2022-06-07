%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}

%%

"-"             {yylval.AstNode.text = strdup(yytext);return OPERATOR;}
[ \t\v\f\r\n]*  {}
"class"         {yylval.AstNode.text = strdup(yytext);return CLASS;}
"inherits"	    {yylval.AstNode.text = strdup(yytext);return INHERITS;}
"SELF_TYPE"	    {yylval.AstNode.text = strdup(yytext);return SELF_TYPE;}
"{"             {yylval.AstNode.text = strdup(yytext);return BLOCKSTART;}
"}"             {yylval.AstNode.text = strdup(yytext);return BLOCKOVER;}
"("             {yylval.AstNode.text = strdup(yytext);return ITEMSTART;}
")"             {yylval.AstNode.text = strdup(yytext);return ITEMOVER;}
";"             {yylval.AstNode.text = strdup(yytext);return SYNTAX_OVER;}
"<-"            {yylval.AstNode.text = strdup(yytext);return ASSIGN;}
\".*\"          {yylval.AstNode.text = strdup(yytext);return LETTER;}	
false|true      {yylval.AstNode.text = strdup(yytext);return BOOLEAN;}
"if"            {yylval.AstNode.text = strdup(yytext);return IF;}
"then"          {yylval.AstNode.text = strdup(yytext);return THEN;}
"else"          {yylval.AstNode.text = strdup(yytext);return ELSE;}
"fi"            {yylval.AstNode.text = strdup(yytext);return FI;}
"not"   	    {yylval.AstNode.text = strdup(yytext);return NOT;}
"while"     	{yylval.AstNode.text = strdup(yytext);return WHILE;}
"loop"	    	{yylval.AstNode.text = strdup(yytext);return LOOP;}
"case" 	        {yylval.AstNode.text = strdup(yytext);return CASE;}
"pool"  		{yylval.AstNode.text = strdup(yytext);return POOL;}
"of"	    	{yylval.AstNode.text = strdup(yytext);return OF;}
"esac"	    	{yylval.AstNode.text = strdup(yytext);return ESAC;}
"=>"		    {yylval.AstNode.text = strdup(yytext);return DO;}
"new"	    	{yylval.AstNode.text = strdup(yytext);return NEW;}
"isvoid"	    {yylval.AstNode.text = strdup(yytext);return ISVOID;}
"let"   		{yylval.AstNode.text = strdup(yytext);return LET;}
"in"	    	{yylval.AstNode.text = strdup(yytext);return IN;}
"end"           {yylval.AstNode.text = strdup(yytext);return END;}
"self"          {yylval.AstNode.text = strdup(yytext);return SELF;}
"@"             {yylval.AstNode.text = strdup(yytext);return AT;}
"~"             {yylval.AstNode.text = strdup(yytext);return INT_COMP;}
"<="	        {yylval.AstNode.text = strdup(yytext);return OPERATOR;}
"<"             {yylval.AstNode.text = strdup(yytext);return OPERATOR;}
[*+/=]          {yylval.AstNode.text = strdup(yytext);return OPERATOR;}
[0-9]+      	{yylval.AstNode.text = strdup(yytext);return DIGIT;}
[A-Z][a-zA-Z0-9]*   {yylval.AstNode.text = strdup(yytext);return TYPE_ID;}
[a-z][a-zA-Z0-9]*_[a-zA-Z0-9]*  {yylval.AstNode.text = strdup(yytext);return IDENTIFIER_ID;}
[a-z][a-zA-Z0-9]*   {yylval.AstNode.text = strdup(yytext);return IDENTIFIER_ID;}
"."             {yylval.AstNode.text = strdup(yytext);return DOT;}
","             {yylval.AstNode.text = strdup(yytext);return NEXT;}
":"             {yylval.AstNode.text = strdup(yytext);return DEFINE;}

%%

int yywrap(void) { 
    return 1;
}