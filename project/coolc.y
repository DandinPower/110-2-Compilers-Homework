%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define TEXT_LENGTH 80
#define NONE "-99999"
void yyerror(const char* msg) {}

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

TreeNode *root;

TreeNode *MakeTreeNode(char *type, char *text, char *grammar_type, int grammar_number){
        TreeNode *newNode = malloc(sizeof(TreeNode));
        sprintf(newNode->type,"%s",type);
        sprintf(newNode->text,"%s",text);
        sprintf(newNode->grammar_type,"%s",grammar_type);
        newNode->grammar_number = grammar_number;
        newNode->child_head = NULL;
        newNode->next = NULL;
        return newNode;
}

void SetFatherNode(TreeNode *node, TreeNode *child_head){
        node = malloc(sizeof(TreeNode));
        node->child_head = child_head;
}

void SetTreeNode(TreeNode *node,char *type, char *text, char *grammar_type, int grammar_number){
        sprintf(node->type,"%s",type);
        sprintf(node->text,"%s",text);
        sprintf(node->grammar_type,"%s",grammar_type);
        node->grammar_number = grammar_number;
        node->next = NULL;
}

/* 以下為建立symbol table的data structure */

struct symbol_node {
        char text[TEXT_LENGTH];
        struct symbol_node *next;
};
typedef struct symbol_node SymbolNode;

SymbolNode *GetFirstNode(){
	SymbolNode *newNode = NULL;
	newNode = malloc(sizeof(SymbolNode));
	sprintf(newNode->text,"%s",NONE);
	newNode->next = NULL;
	return newNode;
}

SymbolNode *GetNewNode(char *data){
	SymbolNode *newNode = NULL;
	newNode = malloc(sizeof(SymbolNode));
	sprintf(newNode->text,"%s",data);
	newNode->next = NULL;
	return newNode;
}

int CheckData(SymbolNode *List,char *data){
	SymbolNode *ptr = List;
	int isSame = -1;
	int i=0;
	while(ptr!=NULL){
	  	if (strcmp(data,ptr->text)==0)isSame = i;
	  	ptr=ptr->next;
	  	i++;
	}
	return isSame;
}

void AddData(SymbolNode *List,char *text){
	SymbolNode *ptr = List;
	if (CheckData(List,text)!=-1)return;
	if (strcmp(ptr->text,NONE)==0){
		sprintf(ptr->text,"%s",text);
		ptr->next = NULL;
	}
	else{	
		while(ptr->next!=NULL){
	  		ptr=ptr->next;
	  	}
	  	SymbolNode *newNode = GetNewNode(text);
	  	ptr->next = newNode;
	}
}

void ShowList(SymbolNode *ptr,char *name){
	printf("%s: ",name);
	int i=0;
	while(ptr!=NULL && strcmp(ptr->text,NONE)){
		printf("[%d]: %s",i,ptr->text); //印出節點的資料 
		if (ptr->next!=NULL)printf(",");
		ptr=ptr->next;  //將ptr指向下一個節點 
		i++;
	}
	printf("\n");
}

SymbolNode *Identifiers;
SymbolNode *Strings;
SymbolNode *Booleans;
SymbolNode *Operators;
SymbolNode *Numbers;

%}

%union 
{
        struct yylvalNode {
                char text[TEXT_LENGTH];
                TreeNode *node;
        }object;
}
%token <object> LETTER
%token <object> CLASS BLOCKSTART BLOCKOVER ITEMSTART ITEMOVER SYNTAX_OVER TYPE_ID IDENTIFIER_ID DOT DEFINE 
%token <object> INHERITS SELF_TYPE ASSIGN BOOLEAN IF THEN ELSE FI NOT WHILE LOOP CASE POOL OF ESAC DO NEW ISVOID
%token <object> LET IN END OPERATOR DIGIT NEXT AT INT_COMP SELF
%type <object> program clist class flist_opt flist feature formal_list formal block_list arguments_list arguments action_list action let_action expr 
%right ASSIGN NOT ISVOID INT_COMP
%left AT DOT OPERATOR
%%

program :   clist       {printf("\nDone!\n");ShowList(Strings,"LETTER");}
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
        |   feature SYNTAX_OVER     {printf("flist 2 ");}
        ; 

feature :   IDENTIFIER_ID ITEMSTART formal_list ITEMOVER DEFINE TYPE_ID BLOCKSTART expr BLOCKOVER  {printf("feature 1 ");}
        |   IDENTIFIER_ID ITEMSTART ITEMOVER DEFINE TYPE_ID BLOCKSTART expr BLOCKOVER  {printf("feature 2 ");}
        |   IDENTIFIER_ID DEFINE TYPE_ID ASSIGN expr    {printf("feature 3 ");}
        |   IDENTIFIER_ID DEFINE TYPE_ID        {printf("feature 4 ");}
        ;

formal_list     :   formal_list NEXT formal {printf("formal_list 1 ");}
                |   formal      {printf("formal_list 2");}
                ;

formal  :   IDENTIFIER_ID DEFINE TYPE_ID        {printf("formal 1");}
        ;

block_list      :   block_list expr SYNTAX_OVER         {printf("block_list 1 ");}
                |   expr SYNTAX_OVER    {printf("block_list 2 ");}
                ;

arguments_list  :   arguments   {printf("arguments_list 1 ");}
                |   /*empty*/   {printf("arguments_list 2 ");}
                ;

arguments       :   arguments NEXT expr         {printf("arguments 1 ");}
                |   expr        {printf("arguments 2 ");}
                ;

action_list     :   action_list action  {printf("action_list 1 ");}
                |   action      {printf("action_list 2 ");}
                ;

action  :   IDENTIFIER_ID DEFINE TYPE_ID DO expr SYNTAX_OVER    {printf("action 1 ");}
        ;


//let_expr        :   LET IDENTIFIER_ID DEFINE TYPE_ID IN expr    
//                |   nest_let NEXT LET IDENTIFIER_ID DEFINE TYPE_ID
//                |   LET IDENTIFIER_ID DEFINE TYPE_ID ASSIGN expr IN expr 
//                |   nest_let NEXT LET IDENTIFIER_ID DEFINE TYPE_ID ASSIGN expr 
//                ;
/*
nest_let        :   IDENTIFIER_ID DEFINE TYPE_ID IN expr 
                |   nest_let NEXT IDENTIFIER_ID DEFINE TYPE_ID
                |   IDENTIFIER_ID DEFINE TYPE_ID IN expr IN expr 
                |   nest_let NEXT IDENTIFIER_ID DEFINE TYPE_ID ASSIGN expr 
                ;
*/

let_action      :   IDENTIFIER_ID DEFINE TYPE_ID IN BLOCKSTART block_list BLOCKOVER     {printf("let_action 1 ");}
                |   IDENTIFIER_ID DEFINE TYPE_ID ASSIGN expr IN BLOCKSTART block_list BLOCKOVER         {printf("let_action 2 ");}
                ;

expr    :   IDENTIFIER_ID       {printf("expr 1 ");}
        |   DIGIT               {printf("expr 2 ");}
        |   BOOLEAN             {printf("expr 3 ");}
        |   LETTER              {printf("expr 4 ");printf("%s \n",$1.text);AddData(Strings,$1.text);}
        |   SELF                {printf("expr 5 ");}
        |   BLOCKSTART block_list BLOCKOVER     {printf("expr 6 ");}
        |   IDENTIFIER_ID ASSIGN expr           {printf("expr 7 ");}
        |   expr DOT IDENTIFIER_ID ITEMSTART arguments_list ITEMOVER    {printf("expr 8 ");}
        |   expr AT TYPE_ID DOT IDENTIFIER_ID ITEMSTART arguments_list ITEMOVER         {printf("expr 9 ");}
        |   IDENTIFIER_ID ITEMSTART arguments_list ITEMOVER     {printf("expr 10 ");}
        |   expr OPERATOR expr          {printf("expr 11 ");}
        |   ITEMSTART expr ITEMOVER     {printf("expr 12 ");}
        |   IF expr THEN expr ELSE expr FI      {printf("expr 13 ");} 
        |   WHILE expr LOOP expr POOL   {printf("expr 14 ");}
//        |   let_expr
        |   LET let_action      {printf("expr 15 ");}
        |   CASE expr OF action_list ESAC       {printf("expr 16 ");}
        |   NEW TYPE_ID         {printf("expr 17 ");}
        |   ISVOID expr         {printf("expr 18 ");}
        |   NOT expr            {
                printf("expr 19 ");
                TreeNode *childHead = MakeTreeNode("NOT",$1.text,"expr",19);
                SetTreeNode($2.node,"expr","NonTerminal","expr",19);
                childHead->next = $2.node;
                SetFatherNode($$.node, child_head);
                                }
        |   INT_COMP expr       {
                printf("expr 20 ");
                TreeNode *childHead = MakeTreeNode("INT_COMP",$1.text,"expr",20);
                SetTreeNode($2.node,"expr","NonTerminal","expr",20);
                childHead->next = $2.node;
                SetFatherNode($$.node, child_head);
                                }
        ;

%%

int main() {
        Identifiers = GetFirstNode();
        Strings = GetFirstNode();
        Booleans = GetFirstNode();
        Operators = GetFirstNode();
        Numbers = GetFirstNode();
        return yyparse();
}