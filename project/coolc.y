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

TreeNode *MakeTreeNode(char *type, char *text, char *grammar_type, int grammar_number);
TreeNode *SetFatherNode(TreeNode *child_head);
TreeNode *SetFatherEmpty();
void SetTreeNode(TreeNode *node,char *type, char *text, char *grammar_type, int grammar_number);
void TraverseTree(TreeNode *node);

TreeNode *root;

/* 以下為建立symbol table的data structure */

struct symbol_node {
        char text[TEXT_LENGTH];
        struct symbol_node *next;
};
typedef struct symbol_node SymbolNode;

SymbolNode *GetFirstNode();
SymbolNode *GetNewNode(char *data);
int CheckData(SymbolNode *List,char *data);
int AddData(SymbolNode *List,char *text);
void ShowList(SymbolNode *ptr,char *name);

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

program :   clist       {
                printf("\nDone!\n");
                ShowList(Identifiers,"ID");
                ShowList(Strings,"STRING");
                ShowList(Booleans,"BOOLEAN");
                ShowList(Operators,"OPERATOR");
                ShowList(Numbers,"NUMBER");
                SetTreeNode($1.node,"clist","NonTerminal","program",1);
                root = $1.node;
                TraverseTree(root);
                }
        ;

clist   :   clist class SYNTAX_OVER     {
                printf("clist 1 ");
                SetTreeNode($1.node,"clist","NonTerminal","clist",1);
                SetTreeNode($2.node,"class","NonTerminal","clist",1);
                TreeNode *tempChild = MakeTreeNode("SYNTAX_OVER",$3.text,"clist",1);
                $1.node->next = $2.node;
                $2.node->next = tempChild;
                $$.node = SetFatherNode($1.node);
                }
        |   class SYNTAX_OVER           {
                printf("clist 2 ");
                SetTreeNode($1.node,"class","NonTerminal","clist",2);
                TreeNode *tempChild = MakeTreeNode("SYNTAX_OVER",$2.text,"clist",2);
                $1.node->next = tempChild;
                $$.node = SetFatherNode($1.node);
                }
        ;

class   :   CLASS TYPE_ID BLOCKSTART flist_opt BLOCKOVER        {
                printf("class 1 ");
                TreeNode *tempChild = MakeTreeNode("CLASS",$1.text,"class",1);
                TreeNode *tempChild2 = MakeTreeNode("TYPE_ID",$2.text,"class",1);
                TreeNode *tempChild3 = MakeTreeNode("BLOCKSTART",$3.text,"class",1);
                SetTreeNode($4.node,"flist_opt","NonTerminal","class",1);
                TreeNode *tempChild4 = MakeTreeNode("BLOCKOVER",$5.text,"class",1);
                tempChild->next = tempChild2;
                tempChild2->next = tempChild3;
                tempChild3->next = $4.node;
                $4.node->next = tempChild4;
                $$.node = SetFatherNode(tempChild);
                }
        |   CLASS TYPE_ID INHERITS TYPE_ID BLOCKSTART flist_opt BLOCKOVER        {
                printf("class 2 ");
                TreeNode *tempChild = MakeTreeNode("CLASS",$1.text,"class",2);
                TreeNode *tempChild2 = MakeTreeNode("TYPE_ID",$2.text,"class",2);
                TreeNode *tempChild3 = MakeTreeNode("INHERITS",$3.text,"class",2);
                TreeNode *tempChild4 = MakeTreeNode("TYPE_ID",$4.text,"class",2);
                TreeNode *tempChild5 = MakeTreeNode("BLOCKSTART",$5.text,"class",2);
                SetTreeNode($6.node,"flist_opt","NonTerminal","class",2);
                TreeNode *tempChild6 = MakeTreeNode("BLOCKOVER",$7.text,"class",2);
                tempChild->next = tempChild2;
                tempChild2->next = tempChild3;
                tempChild3->next = tempChild4;
                tempChild4->next = tempChild5;
                tempChild5->next = $6.node;
                $6.node->next = tempChild6;
                $$.node = SetFatherNode(tempChild);
                }
        ;

flist_opt       :   flist       {
                        printf("flist_opt 1 ");
                        SetTreeNode($1.node,"flist","NonTerminal","flist_opt",1);
                        $$.node = SetFatherNode($1.node);
                }
                |   /*empty*/   {
                        printf("flist_opt 2 ");
                        $$.node = SetFatherEmpty();
                }

flist   :   flist feature SYNTAX_OVER   {
                printf("flist 1 ");
                SetTreeNode($1.node,"flist","NonTerminal","flist",1);
                SetTreeNode($2.node,"feature","NonTerminal","flist",1);
                TreeNode *tempChild = MakeTreeNode("SYNTAX_OVER",$3.text,"flist",1);
                $1.node->next = $2.node;
                $2.node->next = tempChild;
                $$.node = SetFatherNode($1.node);
                }
        |   feature SYNTAX_OVER     {
                printf("flist 2 ");
                SetTreeNode($1.node,"feature","NonTerminal","flist",2);
                TreeNode *tempChild = MakeTreeNode("SYNTAX_OVER",$2.text,"flist",2);
                $1.node->next = tempChild;
                $$.node = SetFatherNode($1.node);
                }
        ; 

feature :   IDENTIFIER_ID ITEMSTART formal_list ITEMOVER DEFINE TYPE_ID BLOCKSTART expr BLOCKOVER  {
                printf("feature 1 ");
                TreeNode *tempChild = MakeTreeNode("IDENTIFIER_ID",$1.text,"feature",1);
                TreeNode *tempChild2 = MakeTreeNode("ITEMSTART",$2.text,"feature",1);
                SetTreeNode($3.node,"formal_list","NonTerminal","feature",1);
                TreeNode *tempChild3 = MakeTreeNode("ITEMOVER",$4.text,"feature",1);
                TreeNode *tempChild4 = MakeTreeNode("DEFINE",$5.text,"feature",1);
                TreeNode *tempChild5 = MakeTreeNode("TYPE_ID",$6.text,"feature",1);
                TreeNode *tempChild6 = MakeTreeNode("BLOCKSTART",$7.text,"feature",1);
                SetTreeNode($8.node,"expr","NonTerminal","feature",1);
                TreeNode *tempChild7 = MakeTreeNode("BLOCKOVER",$9.text,"feature",1);
                tempChild->next = tempChild2;
                tempChild2->next = $3.node;
                $3.node->next = tempChild3;
                tempChild3->next = tempChild4;
                tempChild4->next = tempChild5;
                tempChild5->next = tempChild6;
                tempChild6->next = $8.node;
                $8.node->next = tempChild7;
                $$.node = SetFatherNode(tempChild);
                }
        |   IDENTIFIER_ID ITEMSTART ITEMOVER DEFINE TYPE_ID BLOCKSTART expr BLOCKOVER  {
                printf("feature 2 ");
                TreeNode *tempChild = MakeTreeNode("IDENTIFIER_ID",$1.text,"feature",2);
                TreeNode *tempChild2 = MakeTreeNode("ITEMSTART",$2.text,"feature",2);
                TreeNode *tempChild3 = MakeTreeNode("ITEMOVER",$3.text,"feature",2);
                TreeNode *tempChild4 = MakeTreeNode("DEFINE",$4.text,"feature",2);
                TreeNode *tempChild5 = MakeTreeNode("TYPE_ID",$5.text,"feature",2);
                TreeNode *tempChild6 = MakeTreeNode("BLOCKSTART",$6.text,"feature",2);
                SetTreeNode($7.node,"expr","NonTerminal","feature",2);
                TreeNode *tempChild7 = MakeTreeNode("BLOCKOVER",$8.text,"feature",2);
                tempChild->next = tempChild2;
                tempChild2->next = tempChild3;
                tempChild3->next = tempChild4;
                tempChild4->next = tempChild5;
                tempChild5->next = tempChild6;
                tempChild6->next = $7.node;
                $7.node->next = tempChild7;
                $$.node = SetFatherNode(tempChild);
                }
        |   IDENTIFIER_ID DEFINE TYPE_ID ASSIGN expr    {
                printf("feature 3 ");
                TreeNode *tempChild = MakeTreeNode("IDENTIFIER_ID",$1.text,"feature",3);
                TreeNode *tempChild2 = MakeTreeNode("DEFINE",$2.text,"feature",3);
                TreeNode *tempChild3 = MakeTreeNode("TYPE_ID",$3.text,"feature",3);
                TreeNode *tempChild4 = MakeTreeNode("ASSIGN",$4.text,"feature",3);
                SetTreeNode($5.node,"expr","NonTerminal","feature",3);
                tempChild->next = tempChild2;
                tempChild2->next = tempChild3;
                tempChild3->next = tempChild4;
                tempChild4->next = $5.node;
                $$.node = SetFatherNode(tempChild);
                }
        |   IDENTIFIER_ID DEFINE TYPE_ID        {
                printf("feature 4 ");
                TreeNode *tempChild = MakeTreeNode("IDENTIFIER_ID",$1.text,"feature",4);
                TreeNode *tempChild2 = MakeTreeNode("DEFINE",$2.text,"feature",4);
                TreeNode *tempChild3 = MakeTreeNode("TYPE_ID",$3.text,"feature",4);
                tempChild->next = tempChild2;
                tempChild2->next = tempChild3;
                $$.node = SetFatherNode(tempChild);
                }
        ;

formal_list     :   formal_list NEXT formal {
                        printf("formal_list 1 ");
                        SetTreeNode($1.node,"formal_list","NonTerminal","formal_list",1);
                        TreeNode *tempChild = MakeTreeNode("NEXT",$2.text,"formal_list",1);
                        SetTreeNode($3.node,"formal","NonTerminal","formal_list",1);
                        $1.node->next = tempChild;
                        tempChild->next = $3.node;
                        $$.node = SetFatherNode($1.node);
                        }
                |   formal      {
                        printf("formal_list 2");
                        SetTreeNode($1.node,"formal","NonTerminal","formal_list",2);
                        $$.node = SetFatherNode($1.node);
                        }
                ;

formal  :   IDENTIFIER_ID DEFINE TYPE_ID        {
                printf("formal 1");
                TreeNode *tempChild = MakeTreeNode("IDENTIFIER_ID",$1.text,"formal",1);
                TreeNode *tempChild2 = MakeTreeNode("DEFINE",$2.text,"formal",1);
                TreeNode *tempChild3 = MakeTreeNode("TYPE_ID",$3.text,"formal",1);
                tempChild->next = tempChild2;
                tempChild2->next = tempChild3;
                $$.node = SetFatherNode(tempChild);
                }
        ;

block_list      :   block_list expr SYNTAX_OVER         {
                        printf("block_list 1 ");
                        SetTreeNode($1.node,"block_list","NonTerminal","block_list",1);
                        SetTreeNode($2.node,"expr","NonTerminal","block_list",1);
                        TreeNode *tempChild = MakeTreeNode("SYNTAX_OVER",$3.text,"block_list",1);
                        $1.node->next = $2.node;
                        $2.node->next = tempChild;
                        $$.node = SetFatherNode($1.node);
                        }
                |   expr SYNTAX_OVER    {
                        printf("block_list 2 ");
                        SetTreeNode($1.node,"expr","NonTerminal","block_list",2);
                        TreeNode *tempChild = MakeTreeNode("SYNTAX_OVER",$2.text,"block_list",2);
                        $1.node->next = tempChild;
                        $$.node = SetFatherNode($1.node);
                        }
                ;

arguments_list  :   arguments   {
                        printf("arguments_list 1 ");
                        SetTreeNode($1.node,"arguments","NonTerminal","arguments_list",1);
                        $$.node = SetFatherNode($1.node);
                        }
                |   /*empty*/   {
                        printf("arguments_list 2 ");
                        $$.node = SetFatherEmpty();
                        }
                ;

arguments       :   arguments NEXT expr         {
                        printf("arguments 1 ");
                        SetTreeNode($1.node,"arguments","NonTerminal","arguments",1);     
                        TreeNode *tempChild = MakeTreeNode("NEXT",$2.text,"arguments",1);
                        SetTreeNode($3.node,"expr","NonTerminal","arguments",1);  
                        $1.node->next = tempChild;
                        tempChild->next = $3.node;
                        $$.node = SetFatherNode($1.node);
                        }
                |   expr        {
                        printf("arguments 2 ");
                        SetTreeNode($1.node,"expr","NonTerminal","arguments",1);     
                        $$.node = SetFatherNode($1.node);
                        }
                ;

action_list     :   action_list action  {
                        printf("action_list 1 ");
                        SetTreeNode($1.node,"action_list","NonTerminal","action_list",1);     
                        SetTreeNode($2.node,"action","NonTerminal","action_list",1); 
                        $1.node->next = $2.node;
                        $$.node = SetFatherNode($1.node);
                        }
                |   action      {
                        printf("action_list 2 ");
                        SetTreeNode($1.node,"action","NonTerminal","action_list",2);     
                        $$.node = SetFatherNode($1.node);
                        }
                ;

action  :   IDENTIFIER_ID DEFINE TYPE_ID DO expr SYNTAX_OVER    {
                printf("action 1 ");
                TreeNode *tempChild = MakeTreeNode("IDENTIFIER_ID",$1.text,"action",1);
                TreeNode *tempChild2 = MakeTreeNode("DEFINE",$2.text,"action",1);
                TreeNode *tempChild3 = MakeTreeNode("TYPE_ID",$3.text,"action",1);
                TreeNode *tempChild4 = MakeTreeNode("DO",$4.text,"action",1);
                SetTreeNode($5.node,"expr","NonTerminal","action",1);     
                TreeNode *tempChild5 = MakeTreeNode("SYNTAX_OVER",$6.text,"action",1);
                tempChild->next = tempChild2;
                tempChild2->next = tempChild3;
                tempChild3->next = tempChild4;
                tempChild4->next = $5.node;
                $5.node->next = tempChild5;
                $$.node = SetFatherNode(tempChild);                
                }
        ;

let_action      :   IDENTIFIER_ID DEFINE TYPE_ID IN BLOCKSTART block_list BLOCKOVER     {
                        printf("let_action 1 ");
                        TreeNode *tempChild = MakeTreeNode("IDENTIFIER_ID",$1.text,"let_action",1);
                        TreeNode *tempChild2 = MakeTreeNode("DEFINE",$2.text,"let_action",1);
                        TreeNode *tempChild3 = MakeTreeNode("TYPE_ID",$3.text,"let_action",1);
                        TreeNode *tempChild4 = MakeTreeNode("IN",$4.text,"let_action",1);
                        TreeNode *tempChild5 = MakeTreeNode("BLOCKSTART",$5.text,"let_action",1);
                        SetTreeNode($6.node,"block_list","NonTerminal","let_action",1);
                        TreeNode *tempChild6 = MakeTreeNode("BLOCKOVER",$7.text,"let_action",1);
                        tempChild->next = tempChild2;
                        tempChild2->next = tempChild3;
                        tempChild3->next = tempChild4;
                        tempChild4->next = tempChild5;
                        tempChild5->next = $6.node;
                        $6.node->next = tempChild6;
                        $$.node = SetFatherNode(tempChild);      
                        }
                |   IDENTIFIER_ID DEFINE TYPE_ID ASSIGN expr IN BLOCKSTART block_list BLOCKOVER         {
                        printf("let_action 2 ");
                        TreeNode *tempChild = MakeTreeNode("IDENTIFIER_ID",$1.text,"let_action",2);
                        TreeNode *tempChild2 = MakeTreeNode("DEFINE",$2.text,"let_action",2);
                        TreeNode *tempChild3 = MakeTreeNode("TYPE_ID",$3.text,"let_action",2);
                        TreeNode *tempChild4 = MakeTreeNode("ASSIGN",$4.text,"let_action",2);
                        SetTreeNode($5.node,"expr","NonTerminal","let_action",2);
                        TreeNode *tempChild5 = MakeTreeNode("IN",$6.text,"let_action",2);
                        TreeNode *tempChild6 = MakeTreeNode("BLOCKSTART",$7.text,"let_action",2);
                        SetTreeNode($8.node,"block_list","NonTerminal","let_action",2);
                        TreeNode *tempChild7 = MakeTreeNode("BLOCKOVER",$9.text,"let_action",2);
                        tempChild->next = tempChild2;
                        tempChild2->next = tempChild3;
                        tempChild3->next = tempChild4;
                        tempChild4->next = $5.node;
                        $5.node->next = tempChild5;
                        tempChild5->next = tempChild6;
                        tempChild6->next = $8.node;
                        $8.node->next = tempChild7;
                        $$.node = SetFatherNode(tempChild);
                        }
                ;

expr    :   IDENTIFIER_ID       {
                printf("expr 1 ");
                int index = AddData(Identifiers,$1.text);
                char newText[TEXT_LENGTH];
                sprintf(newText,"%s[%d]","ID",index);
                TreeNode *tempChild = MakeTreeNode(newText,$1.text,"expr",1);
                $$.node = SetFatherNode(tempChild);
                }
        |   DIGIT               {
                printf("expr 2 ");
                int index = AddData(Numbers,$1.text);
                char newText[TEXT_LENGTH];
                sprintf(newText,"%s[%d]","DIGIT",index);
                TreeNode *tempChild = MakeTreeNode(newText,$1.text,"expr",2);
                $$.node = SetFatherNode(tempChild);
                }
        |   BOOLEAN             {
                printf("expr 3 ");
                int index = AddData(Booleans,$1.text);
                char newText[TEXT_LENGTH];
                sprintf(newText,"%s[%d]","BOOLEAN",index);
                TreeNode *tempChild = MakeTreeNode(newText,$1.text,"expr",3);
                $$.node = SetFatherNode(tempChild);
                }
        |   LETTER              {
                printf("expr 4 ");
                int index = AddData(Strings,$1.text);
                char newText[TEXT_LENGTH];
                sprintf(newText,"%s[%d]","STRING",index);
                TreeNode *tempChild = MakeTreeNode(newText,$1.text,"expr",4);
                $$.node = SetFatherNode(tempChild);
                }
        |   SELF                {
                printf("expr 5 ");
                TreeNode *tempChild = MakeTreeNode("SELF",$1.text,"expr",5);
                $$.node = SetFatherNode(tempChild);
                }
        |   BLOCKSTART block_list BLOCKOVER     {
                printf("expr 6 ");
                TreeNode *tempChild = MakeTreeNode("BLOCKSTART",$1.text,"expr",6);
                SetTreeNode($2.node,"block_list","NonTerminal","expr",6);
                TreeNode *tempChild2 = MakeTreeNode("BLOCKOVER",$3.text,"expr",6);
                tempChild->next = $2.node;
                $2.node->next = tempChild2;
                $$.node = SetFatherNode(tempChild);
                }
        |   IDENTIFIER_ID ASSIGN expr           {
                printf("expr 7 ");
                TreeNode *tempChild = MakeTreeNode("IDENTIFIER_ID",$1.text,"expr",7);
                TreeNode *tempChild2 = MakeTreeNode("ASSIGN",$2.text,"expr",7);
                SetTreeNode($3.node,"expr","NonTerminal","expr",7);
                tempChild->next = tempChild2;
                tempChild2->next = $3.node;
                $$.node = SetFatherNode(tempChild);
                }
        |   expr DOT IDENTIFIER_ID ITEMSTART arguments_list ITEMOVER    {
                printf("expr 8 ");
                SetTreeNode($1.node,"expr","NonTerminal","expr",8);
                TreeNode *tempChild = MakeTreeNode("DOT",$2.text,"expr",8);
                TreeNode *tempChild2 = MakeTreeNode("IDENTIFIER_ID",$3.text,"expr",8);
                TreeNode *tempChild3 = MakeTreeNode("ITEMSTART",$4.text,"expr",8);
                SetTreeNode($5.node,"arguments_list","NonTerminal","expr",8);
                TreeNode *tempChild4 = MakeTreeNode("ITEMOVER",$6.text,"expr",8);
                $1.node->next = tempChild;
                tempChild->next = tempChild2;
                tempChild2->next = tempChild3;
                tempChild3->next = $5.node;
                $5.node->next = tempChild4;
                $$.node = SetFatherNode($1.node);
                }
        |   expr AT TYPE_ID DOT IDENTIFIER_ID ITEMSTART arguments_list ITEMOVER         {
                printf("expr 9 ");
                SetTreeNode($1.node,"expr","NonTerminal","expr",9);
                TreeNode *tempChild = MakeTreeNode("AT",$2.text,"expr",9);
                TreeNode *tempChild2 = MakeTreeNode("TYPE_ID",$3.text,"expr",9);
                TreeNode *tempChild3 = MakeTreeNode("DOT",$4.text,"expr",9);
                TreeNode *tempChild4 = MakeTreeNode("IDENTIFIER_ID",$5.text,"expr",9);
                TreeNode *tempChild5 = MakeTreeNode("ITEMSTART",$6.text,"expr",9);
                SetTreeNode($7.node,"arguments_list","NonTerminal","expr",9);
                TreeNode *tempChild6 = MakeTreeNode("ITEMOVER",$8.text,"expr",9);
                tempChild->next = tempChild2;
                tempChild2->next = tempChild3;
                tempChild3->next = tempChild4;
                tempChild4->next = tempChild5;
                tempChild5->next = $7.node;
                $7.node->next = tempChild6;
                $$.node = SetFatherNode(tempChild);
                }
        |   IDENTIFIER_ID ITEMSTART arguments_list ITEMOVER     {
                printf("expr 10 ");
                TreeNode *tempChild = MakeTreeNode("IDENTIFIER_ID",$1.text,"expr",10);
                TreeNode *tempChild2 = MakeTreeNode("ITEMSTART",$2.text,"expr",10);
                SetTreeNode($3.node,"arguments_list","NonTerminal","expr",10);
                TreeNode *tempChild3 = MakeTreeNode("ITEMOVER",$4.text,"expr",10);
                tempChild->next = tempChild2;
                tempChild2->next = $3.node;
                $3.node->next = tempChild3;
                $$.node = SetFatherNode(tempChild);
                }
        |   expr OPERATOR expr          {
                printf("expr 11 ");
                SetTreeNode($1.node,"expr","NonTerminal","expr",11);
                int index = AddData(Operators,$2.text);
                char newText[TEXT_LENGTH];
                sprintf(newText,"%s[%d]","OPERATOR",index);
                TreeNode *tempChild = MakeTreeNode(newText,$2.text,"expr",11);
                SetTreeNode($3.node,"expr","NonTerminal","expr",11);
                $1.node->next = tempChild;
                tempChild->next = $3.node;
                $$.node = SetFatherNode(tempChild);
                }
        |   ITEMSTART expr ITEMOVER     {
                printf("expr 12 ");
                TreeNode *tempChild = MakeTreeNode("ITEMSTART",$1.text,"expr",12);
                SetTreeNode($2.node,"expr","NonTerminal","expr",12);
                TreeNode *tempChild2 = MakeTreeNode("ITEMOVER",$3.text,"expr",12);
                tempChild->next = $2.node;
                $2.node->next = tempChild2;
                $$.node = SetFatherNode(tempChild);
                }
        |   IF expr THEN expr ELSE expr FI      {
                printf("expr 13 ");
                TreeNode *tempChild = MakeTreeNode("IF",$1.text,"expr",13);
                SetTreeNode($2.node,"expr","NonTerminal","expr",13);
                TreeNode *tempChild2 = MakeTreeNode("THEN",$3.text,"expr",13);
                SetTreeNode($4.node,"expr","NonTerminal","expr",13);
                TreeNode *tempChild3 = MakeTreeNode("ELSE",$5.text,"expr",13);
                SetTreeNode($6.node,"expr","NonTerminal","expr",13);
                TreeNode *tempChild4 = MakeTreeNode("FI",$7.text,"expr",13);
                tempChild->next = $2.node;
                $2.node->next = tempChild2;
                tempChild2->next = $4.node;
                $4.node->next = tempChild3;
                tempChild3->next = $6.node;
                $6.node->next = tempChild4;
                $$.node = SetFatherNode(tempChild);     
                } 
        |   WHILE expr LOOP expr POOL   {
                printf("expr 14 ");
                TreeNode *tempChild = MakeTreeNode("WHILE",$1.text,"expr",14);
                SetTreeNode($2.node,"expr","NonTerminal","expr",14);
                TreeNode *tempChild2 = MakeTreeNode("LOOP",$3.text,"expr",14);
                SetTreeNode($4.node,"expr","NonTerminal","expr",14);
                TreeNode *tempChild3 = MakeTreeNode("POOL",$5.text,"expr",14);
                tempChild->next = $2.node;
                $2.node->next = tempChild2;
                tempChild2->next = $4.node;
                $4.node->next = tempChild3;
                $$.node = SetFatherNode(tempChild);     
                }
        |   LET let_action      {
                printf("expr 15 ");
                TreeNode *childHead = MakeTreeNode("LET",$1.text,"expr",15);
                SetTreeNode($2.node,"let_action","NonTerminal","expr",15);
                childHead->next = $2.node;
                $$.node = SetFatherNode(childHead);
                }
        |   CASE expr OF action_list ESAC       {
                printf("expr 16 ");
                TreeNode *childHead = MakeTreeNode("CASE",$1.text,"expr",16);
                SetTreeNode($2.node,"expr","NonTerminal","expr",16);
                childHead->next = $2.node;
                TreeNode *tempChild = MakeTreeNode("OF",$3.text,"expr",16);
                $2.node->next = tempChild;
                SetTreeNode($4.node,"action_list","NonTerminal","expr",16);
                tempChild->next = $4.node;
                TreeNode *tempChild2 = MakeTreeNode("ESAC",$5.text,"expr",16);
                $4.node->next = tempChild2;
                $$.node = SetFatherNode(childHead);
                        }
        |   NEW TYPE_ID         {
                printf("expr 17 ");
                TreeNode *childHead = MakeTreeNode("NEW",$1.text,"expr",17);
                TreeNode *tempChild = MakeTreeNode("TYPE_ID",$2.text,"expr",17);
                childHead->next = tempChild;
                $$.node = SetFatherNode(childHead);
                }
        |   ISVOID expr         {
                printf("expr 18 ");
                TreeNode *childHead = MakeTreeNode("ISVOID",$1.text,"expr",18);
                SetTreeNode($2.node,"expr","NonTerminal","expr",18);
                childHead->next = $2.node;
                $$.node = SetFatherNode(childHead);
                }
        |   NOT expr            {
                printf("expr 19 ");
                TreeNode *childHead = MakeTreeNode("NOT",$1.text,"expr",19);
                SetTreeNode($2.node,"expr","NonTerminal","expr",19);
                childHead->next = $2.node;
                $$.node = SetFatherNode(childHead);
                                }
        |   INT_COMP expr       {
                printf("expr 20 ");
                TreeNode *childHead = MakeTreeNode("INT_COMP",$1.text,"expr",20);
                SetTreeNode($2.node,"expr","NonTerminal","expr",20);
                childHead->next = $2.node;
                $$.node = SetFatherNode(childHead);
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

TreeNode *MakeTreeNode(char *type, char *text, char *grammar_type, int grammar_number){
        TreeNode *newNode = (TreeNode *)malloc(sizeof(TreeNode));
        sprintf(newNode->type,"%s",type);
        sprintf(newNode->text,"%s",text);
        sprintf(newNode->grammar_type,"%s",grammar_type);
        newNode->grammar_number = grammar_number;
        newNode->child_head = NULL;
        newNode->next = NULL;
        return newNode;
}

TreeNode* SetFatherNode(TreeNode *child_head){
        TreeNode *node = (TreeNode *)malloc(sizeof(TreeNode));
        node->child_head = child_head;
        return node;
}

TreeNode* SetFatherEmpty(){
        TreeNode *node = (TreeNode *)malloc(sizeof(TreeNode));
        node->child_head = NULL;
        return node;
}

void SetTreeNode(TreeNode *node,char *type, char *text, char *grammar_type, int grammar_number){
        sprintf(node->type,"%s",type);
        sprintf(node->text,"%s",text);
        sprintf(node->grammar_type,"%s",grammar_type);
        node->grammar_number = grammar_number;
        node->next = NULL;
}

void TraverseTree(TreeNode *node){
        printf("%s ", node->type);
        if(node->next != NULL) TraverseTree(node->next);
        else {
                printf("reduce(%s%d) ",node->grammar_type,node->grammar_number);
                printf("\n");
        }
        if(node->child_head != NULL) {
                TraverseTree(node->child_head);
        }
        
}

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

int AddData(SymbolNode *List,char *text){
	SymbolNode *ptr = List;
        int index = CheckData(List,text);
	if (index!=-1)return index;
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
        return CheckData(List,text);
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

