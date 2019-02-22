 /* Nathan Dang
 	861222839
 	ndang008@ucr.edu
 */

%{
	#include "heading.h"
	#include "tok.h"
							/* put YYSTYPE here for now, doesn't work in .y */
	YYSTYPE yylval;
	int row = 1;
	int column = 1; 
%}

Digit [0-9]
Number ({Digit})+
Letter [a-zA-Z]
Underscore [_]

Comment "##".*
Ident {Letter}((({Letter}|{Digit})|{Underscore})*({Letter}|{Digit})+)*

Error1 ({Digit}|{Underscore})+{Letter}((({Letter}|{Digit})|{Underscore})*({Letter}|{Digit})+)*
Error2 {Letter}((({Letter}|{Digit})|{Underscore})*({Letter}|{Digit})+)*{Underscore}+


%%

" " 		{column = column + strlen(yytext);} 
"\t"		{column = column + strlen(yytext);}
"\n"		{row = row + 1; column = 1;}


	/* Reserved Keywords */

function	{column = column + strlen(yytext); return FUNCTION;}
beginparams	{column = column + strlen(yytext); return BEGIN_PARAMS;}
endparams	{column = column + strlen(yytext); return END_PARAMS;}
beginlocals	{column = column + strlen(yytext); return BEGIN_LOCALS;} 
endlocals	{column = column + strlen(yytext); return END_LOCALS;}
beginbody	{column = column + strlen(yytext); return BEGIN_BODY;}
endbody		{column = column + strlen(yytext); return END_BODY;}
integer		{column = column + strlen(yytext); return INTEGER;}
array		{column = column + strlen(yytext); return ARRAY;}
of			{column = column + strlen(yytext); return OF;}
if			{column = column + strlen(yytext); return IF;}
then		{column = column + strlen(yytext); return THEN;}
endif		{column = column + strlen(yytext); return ENDIF;}
else		{column = column + strlen(yytext); return ELSE;}
while		{column = column + strlen(yytext); return WHILE;}
do			{column = column + strlen(yytext); return DO;}
beginloop	{column = column + strlen(yytext); return BEGINLOOP;}
endloop		{column = column + strlen(yytext); return ENDLOOP;}
continue	{column = column + strlen(yytext); return CONTINUE;}
read		{column = column + strlen(yytext); return READ;}
write		{column = column + strlen(yytext); return WRITE;}
and			{column = column + strlen(yytext); return AND;}
or			{column = column + strlen(yytext); return OR;}
not			{column = column + strlen(yytext); return NOT;}
true		{column = column + strlen(yytext); return TRUE;}
false		{column = column + strlen(yytext); return FALSE;}
return		{column = column + strlen(yytext); return RETURN;}

	/* Arithmetic */

"-"			{column = column + strlen(yytext); return SUB;}
"+"			{column = column + strlen(yytext); return ADD;}
"*"			{column = column + strlen(yytext); return MULT;}
"/"			{column = column + strlen(yytext); return DIV;}
"%"			{column = column + strlen(yytext); return MOD;}

	/* Comparison */

"=="		{column = column + strlen(yytext); return EQ;}
"<>"		{column = column + strlen(yytext); return NEQ;}
"<"			{column = column + strlen(yytext); return LT;}
">"			{column = column + strlen(yytext); return GT;}
"<="		{column = column + strlen(yytext); return LTE;}
">="		{column = column + strlen(yytext); return GTE;}

	/* Special Symbols */

";"			{column = column + strlen(yytext); return SEMICOLON;}
":"			{column = column + strlen(yytext); return COLON;}
","			{column = column + strlen(yytext); return COMMA;}
"("			{column = column + strlen(yytext); return L_PAREN;}
")"			{column = column + strlen(yytext); return R_PAREN;}
"["			{column = column + strlen(yytext); return L_SQUARE_BRACKET;}
"]"			{column = column + strlen(yytext); return R_SQUARE_BRACKET;}
":="		{column = column + strlen(yytext); return ASSIGN;}

	/* Identifiers and Error Handling has to be here or rest of rules don't match */

{Comment}	{row = row + 1; column = 1;}
{Number} 	{column = column + strlen(yytext); yylval.int_val = atoi(yytext); return NUMBER;}
{Ident}		{column = column + strlen(yytext); yylval.string_val = new std::string(yytext); return IDENT;}
{Error1}	{printf("Error at line %d, column %d: Identifier \"%s\" must begin with a letter\n", row, column, yytext); column = column + strlen(yytext); exit(1);}
{Error2}	{printf("Error at line %d, column %d: Identifier \"%s\" cannot end with an underscore\n", row, column, yytext); column = column + strlen(yytext); exit(1);}
.			{printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", row, column, yytext); exit(1);} 

%%