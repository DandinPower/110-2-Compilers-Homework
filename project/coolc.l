%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}

%%

"-"             {yylval.node.text = strdup(yytext);return OPERATOR;}
[ \t\v\f\r\n]*  {}
"class"         {yylval.node.text = strdup(yytext);return CLASS;}
"inherits"	    {yylval.node.text = strdup(yytext);return INHERITS;}
"SELF_TYPE"	    {yylval.node.text = strdup(yytext);return SELF_TYPE;}
"{"             {yylval.node.text = strdup(yytext);return BLOCKSTART;}
"}"             {yylval.node.text = strdup(yytext);return BLOCKOVER;}
"("             {yylval.node.text = strdup(yytext);return ITEMSTART;}
")"             {yylval.node.text = strdup(yytext);return ITEMOVER;}
";"             {yylval.node.text = strdup(yytext);return SYNTAX_OVER;}
"<-"            {yylval.node.text = strdup(yytext);return ASSIGN;}
\".*\"          {yylval.node.text = strdup(yytext);return LETTER;}	
false|true      {yylval.node.text = strdup(yytext);return BOOLEAN;}
"if"            {yylval.node.text = strdup(yytext);return IF;}
"then"          {yylval.node.text = strdup(yytext);return THEN;}
"else"          {yylval.node.text = strdup(yytext);return ELSE;}
"fi"            {yylval.node.text = strdup(yytext);return FI;}
"not"   	    {yylval.node.text = strdup(yytext);return NOT;}
"while"     	{yylval.node.text = strdup(yytext);return WHILE;}
"loop"	    	{yylval.node.text = strdup(yytext);return LOOP;}
"case" 	        {yylval.node.text = strdup(yytext);return CASE;}
"pool"  		{yylval.node.text = strdup(yytext);return POOL;}
"of"	    	{yylval.node.text = strdup(yytext);return OF;}
"esac"	    	{yylval.node.text = strdup(yytext);return ESAC;}
"=>"		    {yylval.node.text = strdup(yytext);return DO;}
"new"	    	{yylval.node.text = strdup(yytext);return NEW;}
"isvoid"	    {yylval.node.text = strdup(yytext);return ISVOID;}
"let"   		{yylval.node.text = strdup(yytext);return LET;}
"in"	    	{yylval.node.text = strdup(yytext);return IN;}
"end"           {yylval.node.text = strdup(yytext);return END;}
"self"          {yylval.node.text = strdup(yytext);return SELF;}
"@"             {yylval.node.text = strdup(yytext);return AT;}
"~"             {yylval.node.text = strdup(yytext);return INT_COMP;}
"<="	        {yylval.node.text = strdup(yytext);return OPERATOR;}
"<"             {yylval.node.text = strdup(yytext);return OPERATOR;}
[*+/=]          {yylval.node.text = strdup(yytext);return OPERATOR;}
[0-9]+      	{yylval.node.text = strdup(yytext);return DIGIT;}
[A-Z][a-zA-Z0-9]*   {yylval.node.text = strdup(yytext);return TYPE_ID;}
[a-z][a-zA-Z0-9]*_[a-zA-Z0-9]*  {yylval.node.text = strdup(yytext);return IDENTIFIER_ID;}
[a-z][a-zA-Z0-9]*   {yylval.node.text = strdup(yytext);return IDENTIFIER_ID;}
"."             {yylval.node.text = strdup(yytext);return DOT;}
","             {yylval.node.text = strdup(yytext);return NEXT;}
":"             {yylval.node.text = strdup(yytext);return DEFINE;}

%%

int yywrap(void) { 
    return 1;
}