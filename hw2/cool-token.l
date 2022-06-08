%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define NONE "-99999"
#define MAX_LEN 80
#define KEY 1
#define IDENTIFIER 2
#define TYPE 3
#define OPERATORS 4
#define LETTERS 5
#define DIGITS 6
#define CLASS 7
#define MAIN 8
#define INHERITS 9
#define BLOCKSTART 10
#define BLOCKOVER 11
#define DEFINE 12
#define ASSIGN 13
#define DOT 14
#define NEXT 15
#define ITEMSTART 16
#define ITEMOVER 17
#define SYNTAX_OVER 18
#define SELF_TYPE 19
#define IF 20
#define THEN 21
#define ELSE 22
#define FI 23
#define NOT 24
#define WHILE 25
#define LOOP 26
#define CASE 27
#define POOL 28
#define OF 29
#define ESAC 30
#define DO 31
#define NEW 32
#define ISVOID 33
#define LET 34
#define IN 35
#define BOOLEAN 36
int commentNum = 0;

struct node{
	char data[MAX_LEN];
	struct node *next;
};
typedef struct node Node;

Node *GetFirstNode(){
	Node *newNode = NULL;
	newNode = malloc(sizeof(Node));
	sprintf(newNode->data,"%s",NONE);
	newNode->next = NULL;
	return newNode;

}

Node *GetNewNode(char *data){
	Node *newNode = NULL;
	newNode = malloc(sizeof(Node));
	sprintf(newNode->data,"%s",data);
	newNode->next = NULL;
	return newNode;
}

int CheckData(Node *List,char *data){
	Node *ptr = List;
	int isSame = -1;
	int i=0;
	while(ptr!=NULL){
	  	if (strcmp(data,ptr->data)==0)isSame = i;
	  	ptr=ptr->next;
	  	i++;
	}
	return isSame;
}

void AddText(Node *List,char *data){
	Node *ptr = List;
	if (strcmp(ptr->data,NONE)==0){
		sprintf(ptr->data,"%s",data);
		ptr->next = NULL;
	}
	else{	
		while(ptr->next!=NULL){
	  		ptr=ptr->next;
	  	}
	  	Node *newNode = GetNewNode(data);
	  	ptr->next = newNode;
	}
}

void AddData(Node *List,char *data){
	Node *ptr = List;
	if (CheckData(List,data)!=-1)return;
	if (strcmp(ptr->data,NONE)==0){
		sprintf(ptr->data,"%s",data);
		ptr->next = NULL;
	}
	else{	
		while(ptr->next!=NULL){
	  		ptr=ptr->next;
	  	}
	  	Node *newNode = GetNewNode(data);
	  	ptr->next = newNode;
	}
}

void ShowList(Node *ptr,char *name){
	printf("%s: ",name);
	int i=0;
	while(ptr!=NULL && strcmp(ptr->data,NONE)){
		printf("[%d]: %s",i,ptr->data); //印出節點的資料 
		if (ptr->next!=NULL)printf(",");
		ptr=ptr->next;  //將ptr指向下一個節點 
		i++;
	}
	printf("\n");
}

void ShowText(Node *ptr){
	int i=0;
	while(ptr!=NULL && strcmp(ptr->data,NONE)){
		printf("%s ",ptr->data); //印出節點的資料 
		ptr=ptr->next;  //將ptr指向下一個節點 
		i++;
	}
	printf("\n");
}

%}

MAIN		Main
CLASS		class
INHERITS	inherits
BLOCKSTART	"{"
BLOCKOVER	"}"
DEFINE		":"
ASSIGN		"<-"
SELF		self
DOT		"."
NEXT		","
ITEMSTART	"("
ITEMOVER	")"
SYNTAX_OVER	";"
SELF_TYPE	SELF_TYPE
SPACE		[ \t\v\f\r_]*
NEW_LINE	\n
DIGIT   	[0-9]+
LETTER		\".*\"
BOOLEAN	false|true
IF		"if"
THEN		"then"
ELSE		"else"
FI		"fi"
NOT   		"not"
WHILE		"while"
LOOP		"loop"
POOL		"pool"
CASE 		"case"
OF		"of"
ESAC		"esac"
DO		"=>"
NEW		"new"
ISVOID		"isvoid"
LET 		"let"
IN		"in"
COMMANT	--[^\n]*
TYPE_ID	[A-Z][a-zA-Z0-9]*
IDENTIFIER_ID	[a-z][a-zA-Z0-9]*
OPERATOR	<=|[*-+/=]|<
END		"end"
COMMENT_START  "(*"
COMMENT_OVER    "*)"
COMMENT_BODY 	([^\*\(\n]|\([^\*]|\*[^\)\*])*

%x COMMENT
%%

<INITIAL,COMMENT>{
	
}

<INITIAL>{
	{LETTER}	{return LETTERS;}
	{END}		{return 0;}
	{NEW_LINE}	{}
	{SPACE}	{}
	{COMMANT}	{}
	{COMMENT_START} {
		if (commentNum == 0) BEGIN(COMMENT);
		commentNum++;
	}
	{COMMENT_OVER} {
		printf("ERROR:unmatched (*\n");
		{return 0;}
	}
	<<EOF>>	{return 0;}
	{BOOLEAN}	{return BOOLEAN;}
	{CLASS}	{return CLASS;}
	{MAIN}		{return MAIN;}
	{INHERITS}	{return INHERITS;}
	{BLOCKSTART}	{return BLOCKSTART;}
	{BLOCKOVER}	{return BLOCKOVER;}
	{DEFINE}	{return DEFINE;}
	{ASSIGN}	{return ASSIGN;}
	{DOT}		{return DOT;}
	{NEXT}		{return NEXT;}
	{ITEMSTART}	{return ITEMSTART;}
	{ITEMOVER}	{return ITEMOVER;}
	{SYNTAX_OVER}	{return SYNTAX_OVER;}
	{SELF_TYPE}	{return SELF_TYPE;}
	{IF}		{return IF;}
	{THEN}		{return THEN;}
	{ELSE}		{return ELSE;}
	{FI}		{return FI;}
	{NOT}   	{return NOT;}
	{WHILE}	{return WHILE;}
	{LOOP}		{return LOOP;}
	{CASE} 	{return CASE;}
	{POOL}		{return POOL;}
	{OF}		{return OF;}
	{ESAC}		{return ESAC;}
	{DO}		{return DO;}
	{NEW}		{return NEW;}
	{ISVOID}	{return ISVOID;}
	{LET} 		{return LET;}
	{IN}		{return IN;}	
	{TYPE_ID}	{return TYPE;}
	{IDENTIFIER_ID} 	{return IDENTIFIER;}
	{OPERATOR}	{return OPERATORS;}
	{DIGIT}	{return DIGITS;}
	.		{
				printf("ERROR:unmatched token\n");
				{return 0;}
			}
}


<COMMENT>{
	{NEW_LINE}	{}
	{SPACE}	{}
	{COMMENT_BODY} { }

	<<EOF>> {
		BEGIN(INITIAL);
		printf("ERROR:EOF in comment body\n");
		{return 0;}
	}

	{COMMENT_OVER} {
		commentNum--;
		if (commentNum == 0) BEGIN(INITIAL);
	}
}


%%

int yywrap(void){
	return 1;
}	

int main(int argc, char **argv){
	Node *textList = GetFirstNode();
	Node *typeList = GetFirstNode();
	Node *idList = GetFirstNode();
	Node *opList = GetFirstNode();
	Node *digitList = GetFirstNode();
	Node *letterList = GetFirstNode();
	Node *boolList = GetFirstNode();
	int token;
	int i=0;
	while(token = yylex()){
		if (token == CLASS) {
			AddText(textList,"CLASS");
			i++;
		}
		else if (token == MAIN) {
			AddText(textList,"MAIN");
			i++;
		}
		else if (token == INHERITS) {
			AddText(textList,"INHERITS");
			i++;
		}
		else if (token == BLOCKSTART) {
			AddText(textList,"BLOCKSTART");
			i++;
		}
		else if (token == BLOCKOVER) {
			AddText(textList,"BLOCKOVER");
			i++;
		}
		else if (token == DEFINE) {
			AddText(textList,"DEFINE");
			i++;
		}
		else if (token == ASSIGN) {
			AddText(textList,"ASSIGN");
			i++;
		}
		else if (token == DOT) {
			AddText(textList,"DOT");
			i++;
		}
		else if (token == NEXT) {
			AddText(textList,"NEXT");
			i++;
		}
		else if (token == ITEMSTART) {
			AddText(textList,"ITEMSTART");
			i++;
		}
		else if (token == ITEMOVER) {
			AddText(textList,"ITEMOVER");
			i++;
		}
		else if (token == SYNTAX_OVER) {
			AddText(textList,"SYNTAX_OVER");
			i++;
		}
		else if (token == SELF_TYPE) {
			AddText(textList,"SELF_TYPE");
			i++;
		}
		else if (token == IF) {
			AddText(textList,"IF");
			i++;
		}
		else if (token == THEN) {
			AddText(textList,"THEN");
			i++;
		}
		else if (token == ELSE) {
			AddText(textList,"ELSE");
			i++;
		}
		else if (token == FI) {
			AddText(textList,"FI");
			i++;
		}
		else if (token == NOT) {
			AddText(textList,"NOT");
			i++;
		}
		else if (token == WHILE) {
			AddText(textList,"WHILE");
			i++;
		}
		else if (token == LOOP) {
			AddText(textList,"LOOP");
			i++;
		}
		else if (token == CASE) {
			AddText(textList,"CASE");
			i++;
		}
		else if (token == POOL) {
			AddText(textList,"POOL");
			i++;
		}
		else if (token == OF) {
			AddText(textList,"OF");
			i++;
		}
		else if (token == ESAC) {
			AddText(textList,"ESAC");
			i++;
		}
		else if (token == DO) {
			AddText(textList,"DO");
			i++;
		}
		else if (token == NEW) {
			AddText(textList,"NEW");
			i++;
		}
		else if (token == ISVOID) {
			AddText(textList,"ISVOID");
			i++;
		}
		else if (token == LET) {
			AddText(textList,"LET");
			i++;
		}
		else if (token == IN) {
			AddText(textList,"IN");
			i++;
		}
		else if (token == TYPE) {
			AddData(typeList,yytext);
			char temp[MAX_LEN];
			sprintf(temp,"TYPE(%d)",CheckData(typeList,yytext));
			AddData(textList,temp);
			i++;
		}
		else if (token == IDENTIFIER) {
			AddData(idList,yytext);
			char temp[MAX_LEN];
			sprintf(temp,"ID(%d)",CheckData(idList,yytext));
			AddData(textList,temp);
			i++;
		
		}
		else if (token == OPERATORS) {
			AddData(opList,yytext);
			char temp[MAX_LEN];
			sprintf(temp,"OP(%d)",CheckData(opList,yytext));
			AddData(textList,temp);
			i++;
		}
		else if (token == DIGITS) {
			AddData(digitList,yytext);
			char temp[MAX_LEN];
			sprintf(temp,"NUMBER(%d)",CheckData(digitList,yytext));
			AddData(textList,temp);
			i++;
		}
		else if (token == LETTERS) {
			AddData(letterList,yytext);
			char temp[MAX_LEN];
			sprintf(temp,"STRING(%d)",CheckData(letterList,yytext));
			AddData(textList,temp);
			i++;
		}
		else if (token == BOOLEAN){
			AddData(boolList,yytext);
			char temp[MAX_LEN];
			sprintf(temp,"BOOL(%d)",CheckData(boolList,yytext));
			AddData(textList,temp);
			i++;
		}
	}
	printf("-Token:\n");
	ShowText(textList);
	printf("-Symbol table:\n");	
	ShowList(typeList,"Types");
	ShowList(idList,"Identifiers");
	ShowList(opList,"Operators");
	ShowList(digitList,"Numbers");
	ShowList(letterList,"Strings");
	ShowList(boolList,"Bools");
	return 0; 
}
