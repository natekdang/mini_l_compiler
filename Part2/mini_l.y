%{
 #include <stdio.h>
 #include <stdlib.h>
 void yyerror(const char *s);
 extern int row; 
 extern int column;
 int yylex(void);
 FILE* yyin;
%}

%union{
	int 		int_val;
	char* 		char_val;
}

%error-verbose 
%start program
%token <int_val> NUMBER
%token <char_val> IDENT
%token FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE READ WRITE TRUE FALSE RETURN SEMICOLON COLON COMMA
%right ASSIGN 
%left AND OR
%right NOT
%left EQ NEQ LT GT LTE GTE
%left ADD SUB
%left MULT DIV MOD
%left L_SQUARE_BRACKET R_SQUARE_BRACKET
%left L_PAREN R_PAREN

%%
program: 	
	/* empty */				{printf("program -> epsilon\n");}
|	program function 		{printf("program -> program function\n");}
;	

function:
	FUNCTION IDENT SEMICOLON BEGIN_PARAMS function1 END_PARAMS BEGIN_LOCALS function1 END_LOCALS BEGIN_BODY statement SEMICOLON function2 END_BODY	{printf("function -> FUNCTION IDENT SEMICOLON BEGIN_PARAMS function1 END_PARAMS BEGIN_LOCALS function1 END_LOCALS BEGIN_BODY statement SEMICOLON function2 END_BODY\n");}
;

function1: 
	/* empty */ 									{printf("function1 -> epsilon\n");}
| 	declaration	SEMICOLON function1					{printf("function1 -> declaration SEMICOLON function1\n");}
; 

function2: 
	/* empty */										{printf("function2 -> epsilon\n");}
| 	statement SEMICOLON function2 					{printf("function2 -> statement SEMICOLON function2\n");}
; 

declaration: 
	IDENT declaration1 COLON declaration2 INTEGER 		{printf("declaration -> IDENT %s declaration1 COLON declaration2 INTEGER\n", $1);}
;

declaration1: 
	/* empty */										{printf("declaration1 -> epsilon\n");}
| 	COMMA IDENT declaration1						{printf("declaration1 -> COMMA IDENT declaration1\n");}
;	

declaration2: 
	/* empty */												{printf("declaration2 -> epsilon\n");}
|	ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF 		{printf("declaration2 -> ARRAY L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET OF\n", $3);}					
;

statement: 
	/* empty */																{printf("statement -> epsilon\n");}
| 	var ASSIGN expression 													{printf("statement -> var ASSIGN expression\n");}
| 	IF bool_expr THEN statement SEMICOLON statement1 ENDIF					{printf("statement -> IF bool_expr THEN statement SEMICOLON statement1 ENDIF\n");}
| 	WHILE bool_expr BEGINLOOP statement SEMICOLON statement2 ENDLOOP		{printf("statement -> WHILE bool_expr BEGINLOOP statement SEMICOLON statement2 ENDLOOP\n");}	
| 	DO BEGINLOOP statement SEMICOLON statement2 ENDLOOP WHILE bool_expr 	{printf("statement -> DO BEGINLOOP statement SEMICOLON statement2 ENDLOOP WHILE bool_expr\n");}
|	READ var statement3														{printf("statement -> READ var statement3\n");}
|	WRITE var statement3													{printf("statement -> WRITE var statement3\n");}
|	CONTINUE																{printf("statement -> CONTINUE\n");}
|	RETURN expression 														{printf("statement -> RETURN expression\n");}
;

statement1: 
	/* empty */									{printf("statement1 -> epsilon\n");}
|	statement SEMICOLON statement1				{printf("statement1 -> statement SEMICOLON statement1\n");}		
|	ELSE statement SEMICOLON statement2			{printf("statement1 -> ELSE statement SEMICOLON statement2\n");}
;

statement2: 
	/* empty */									{printf("statement2 -> epsilon\n");}
| 	statement SEMICOLON statement2				{printf("statement2 -> statement SEMICOLON statement2\n");}
;

statement3: 
	/* empty */ 								{printf("statement3 -> epsilon\n");}
|	COMMA var statement3						{printf("statement3 -> COMMA var statement3\n");}
;

bool_expr:
	relation_and_expr bool_expr1				{printf("bool_expr -> relation_and_expr bool_expr1\n");}
;

bool_expr1: 
	/* empty */									{printf("bool_expr1 -> epsilon\n");}
|	OR relation_and_expr bool_expr1				{printf("bool_expr1 -> OR relation_and_expr bool_expr1\n");}
;

relation_and_expr: 
	relation_expr relation_and_expr1			{printf("relation_and_expr -> relation_expr relation_and_expr1\n");}
;

relation_and_expr1:
	/* empty */									{printf("relation_and_expr1 -> epsilon\n");}
|	AND relation_expr relation_and_expr1		{printf("relation_and_expr1 -> AND relation_expr relation_and_expr1\n");}
;

relation_expr:
	relation_expr1								{printf("relation_expr -> relation_expr1\n");}
|	NOT relation_expr1						{printf("relation_expr -> NOT relation_and_expr1\n");}
;

relation_expr1: 
	expression comp expression					{printf("relation_expr1 -> expression comp expression\n");}
|	TRUE										{printf("relation_expr1 -> TRUE\n");}
|	FALSE										{printf("relation_expr1 -> FALSE\n");}
|	L_PAREN bool_expr R_PAREN 					{printf("relation_expr1 -> L_PAREN bool_expr R_PAREN\n");}
;

comp: 
	EQ											{printf("comp -> EQ\n");}
|	NEQ											{printf("comp -> NEQ\n");}
|	LT											{printf("comp -> LT\n");}
|	GT											{printf("comp -> GT\n");}
|	LTE											{printf("comp -> LTE\n");}
|	GTE											{printf("comp -> GTE\n");}
;

expression: 
	multiplicative_expr expression1				{printf("expression -> multiplicative_expr expression1\n");}
;

expression1: 
	/* empty */									{printf("expression1 -> epsilon\n");}
|	ADD multiplicative_expr expression1			{printf("expression1 -> ADD multiplicative_expr expression1\n");}
|	SUB multiplicative_expr expression1			{printf("expression1 -> SUB multiplicative_expr expression1\n");}
;

multiplicative_expr:
	term multiplicative_expr1					{printf("multiplicative_expr -> term multiplicative_expr1\n");}
;

multiplicative_expr1:
	/* empty */									{printf("multiplicative_expr1 -> epsilon\n");}
|	MULT term multiplicative_expr1				{printf("multiplicative_expr1 -> MULT term multiplicative_expr1\n");}
|	DIV term multiplicative_expr1				{printf("multiplicative_expr1 -> DIV term multiplicative_expr1\n");}
|	MOD term multiplicative_expr1				{printf("multiplicative_expr1 -> MOD term multiplicative_expr1\n");}
;

term:
	term1										{printf("term -> term1\n");}
|	SUB term1									{printf("term -> SUB term1\n");}
|	IDENT L_PAREN term2 R_PAREN					{printf("term -> IDENT %s L_PAREN term2 R_PAREN\n", $1);} 
;

term1:
	var											{printf("term1 -> var\n");}
|	NUMBER										{printf("term1 -> NUMBER %d\n", $1);}
|	L_PAREN expression R_PAREN					{printf("term1 -> L_PAREN expression R_PAREN\n");}
;

term2:
	/* empty */									{printf("term2 -> epsilon\n");}
|	expression term3							{printf("term2 -> expression term3\n");}
;

term3: 
	/* empty */									{printf("term3 -> epsilon\n");}
|	COMMA term2									{printf("term3 -> COMMA term2\n");}
;

var:
	IDENT 												{printf("var -> IDENT %s var1\n", $1);}
|	IDENT L_SQUARE_BRACKET expression R_SQUARE_BRACKET 	{printf("var -> IDENT %s L_SQUARE_BRACKET expression R_SQUARE_BRACKET\n", $1);}
;

%%

int main (const int argc, const char** argv)
{
	if (argc > 1)
	{
		yyin = fopen(argv[1], "r");
		if (yyin == NULL)
		{
			printf("syntax: %s filename\n", argv[0]);
			exit(1);
		}
	}

	yyparse();
	return 0;
}


void yyerror(const char* s)
{
  printf("syntax error at line %d column %d: %s\n", row, column, s);
}



		

