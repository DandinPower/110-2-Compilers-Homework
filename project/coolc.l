%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}

%%

"-"             {yylval.string = strdup(yytext);return OPERATOR;}
[ \t\v\f\r\n]*  {}
"class"         {yylval.string = strdup(yytext);return CLASS;}
"inherits"	    {yylval.string = strdup(yytext);return INHERITS;}
"SELF_TYPE"	    {yylval.string = strdup(yytext);return SELF_TYPE;}
"{"             {yylval.string = strdup(yytext);return BLOCKSTART;}
"}"             {yylval.string = strdup(yytext);return BLOCKOVER;}
"("             {yylval.string = strdup(yytext);return ITEMSTART;}
")"             {yylval.string = strdup(yytext);return ITEMOVER;}
";"             {yylval.string = strdup(yytext);return SYNTAX_OVER;}
"<-"            {yylval.string = strdup(yytext);return ASSIGN;}
\".*\"          {yylval.string = strdup(yytext);return LETTER;}	
false|true      {yylval.string = strdup(yytext);return BOOLEAN;}
"if"            {yylval.string = strdup(yytext);return IF;}
"then"          {yylval.string = strdup(yytext);return THEN;}
"else"          {yylval.string = strdup(yytext);return ELSE;}
"fi"            {yylval.string = strdup(yytext);return FI;}
"not"   	    {yylval.string = strdup(yytext);return NOT;}
"while"     	{yylval.string = strdup(yytext);return WHILE;}
"loop"	    	{yylval.string = strdup(yytext);return LOOP;}
"case" 	        {yylval.string = strdup(yytext);return CASE;}
"pool"  		{yylval.string = strdup(yytext);return POOL;}
"of"	    	{yylval.string = strdup(yytext);return OF;}
"esac"	    	{yylval.string = strdup(yytext);return ESAC;}
"=>"		    {yylval.string = strdup(yytext);return DO;}
"new"	    	{yylval.string = strdup(yytext);return NEW;}
"isvoid"	    {yylval.string = strdup(yytext);return ISVOID;}
"let"   		{yylval.string = strdup(yytext);return LET;}
"in"	    	{yylval.string = strdup(yytext);return IN;}
"end"           {yylval.string = strdup(yytext);return END;}
"self"          {yylval.string = strdup(yytext);return SELF;}
"@"             {yylval.string = strdup(yytext);return AT;}
"~"             {yylval.string = strdup(yytext);return INT_COMP;}
"<="	        {yylval.string = strdup(yytext);return OPERATOR;}
"<"             {yylval.string = strdup(yytext);return OPERATOR;}
[*+/=]          {yylval.string = strdup(yytext);return OPERATOR;}
[0-9]+      	{yylval.string = strdup(yytext);return DIGIT;}
[A-Z][a-zA-Z0-9]*   {yylval.string = strdup(yytext);return TYPE_ID;}
[a-z][a-zA-Z0-9]*_[a-zA-Z0-9]*  {yylval.string = strdup(yytext);return IDENTIFIER_ID;}
[a-z][a-zA-Z0-9]*   {yylval.string = strdup(yytext);return IDENTIFIER_ID;}
"."             {yylval.string = strdup(yytext);return DOT;}
","             {yylval.string = strdup(yytext);return NEXT;}
":"             {yylval.string = strdup(yytext);return DEFINE;}

%%

int yywrap(void) { 
    return 1;
}