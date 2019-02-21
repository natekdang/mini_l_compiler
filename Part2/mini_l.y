%{
 #include <stdio.h>
 #include <stdlib.h>
 void yyerror(const char *msg);
 extern int row;
 extern int column;
 FILE * yyin;
 YYSTYPE yylval; 
%}

%union{
	int int_val;
	char* char_val
}%

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
	/* empty */			{printf("program -> epsilon\n");}
|	program function 	{printf("program -> program function\n");}
;	

function:
	FUNCTION IDENT SEMICOLON BEGIN_PARAMS function' END_PARAMS BEGIN_LOCALS function' 

