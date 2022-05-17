%{
#define YYSTYPE char *
#include "y.tab.h"
%}

%%

[ \t\v\f\r\n]*  {}
"class"         {return CLASS;}
"inherits"	    {return INHERITS;}
"SELF_TYPE"	    {return SELF_TYPE;}
"{"             {return BLOCKSTART;}
"}"             {return BLOCKOVER;}
"("             {return ITEMSTART;}
")"             {return ITEMOVER;}
";"             {return SYNTAX_OVER;}
"<-"            {return ASSIGN;}
\".*\"          {yylval = strdup(yytext);return LETTER;}	
false|true      {return BOOLEAN;}
"if"            {return IF;}
"then"          {return THEN;}
"else"          {return ELSE;}
"fi"            {return FI;}
"not"   	    {return NOT;}
"while"     	{return WHILE;}
"loop"	    	{return LOOP;}
"case" 	        {return CASE;}
"pool"  		{return POOL;}
"of"	    	{return OF;}
"esac"	    	{return ESAC;}
"=>"		    {return DO;}
"new"	    	{return NEW;}
"isvoid"	    {return ISVOID;}
"let"   		{return LET;}
"in"	    	{return IN;}
"end"           {return END;}
"@"             {return AT;}
"~"             {return INT_COMP;}
"<="	        {return OPERATOR;}
"<"             {return OPERATOR;}
[*-+/=]         {return OPERATOR;}
[0-9]+      	{return DIGIT;}
[A-Z][a-zA-Z0-9]*   {yylval = strdup(yytext);return TYPE_ID;}
[a-z][a-zA-Z0-9]*_[a-zA-Z0-9]*  {yylval = strdup(yytext);return IDENTIFIER_ID;}
[a-z][a-zA-Z0-9]*   {yylval = strdup(yytext);return IDENTIFIER_ID;}
"."             {return DOT;}
","             {return NEXT;}
":"             {return DEFINE;}

%%

int yywrap(void) { 
    return 1;
}