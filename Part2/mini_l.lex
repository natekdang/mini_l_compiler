 /* Nathan Dang
 	861222839
 	ndang008@ucr.edu
 */

%{
	#include <string.h>
	int row = 1;
	int column = 1; 
%}

Digit [0-9]
Number ({Digit})+
Letter [a-zA-Z]
Underscore [_]

Comment "##".*
Ident {Letter}((({Letter}|{Digit})|{Underscore})*({Letter}|{Digit})+)*

Error1 {Digit|Underscore}+{Letter}((({Letter}|{Digit})|{Underscore})*({Letter}|{Digit})+)*
Error2 {Letter}((({Letter}|{Digit})|{Underscore})*({Letter}|{Digit})+)*{Underscore}+


%%

" " 		{column = column + strlen(yytext);} 
"\t"		{column = column + strlen(yytext);}
"\n"		{row = row + 1; column = 1;}


	/* Reserved Keywords */

function	{printf("FUNCTION\n"); column = column + strlen(yytext);}
beginparams	{printf("BEGIN_PARAMS\n"); column = column + strlen(yytext);}
endparams	{printf("END_PARAMS\n"); column = column + strlen(yytext);}
beginlocals	{printf("BEGIN_LOCALS\n"); column = column + strlen(yytext);}
endlocals	{printf("END_LOCALS\n"); column = column + strlen(yytext);}
beginbody	{printf("BEGIN_BODY\n"); column = column + strlen(yytext);}
endbody		{printf("END_BODY\n"); column = column + strlen(yytext);}
integer		{printf("INTEGER\n"); column = column + strlen(yytext);}
array		{printf("ARRAY\n"); column = column + strlen(yytext);}
of			{printf("OF\n"); column = column + strlen(yytext);}
if			{printf("IF\n"); column = column + strlen(yytext);}
then		{printf("THEN\n"); column = column + strlen(yytext);}
endif		{printf("ENDIF\n"); column = column + strlen(yytext);}
else		{printf("ELSE\n"); column = column + strlen(yytext);}
while		{printf("WHILE\n"); column = column + strlen(yytext);}
do			{printf("DO\n"); column = column + strlen(yytext);}
beginloop	{printf("BEGINLOOP\n"); column = column + strlen(yytext);}
endloop		{printf("ENDLOOP\n"); column = column + strlen(yytext);}
continue	{printf("CONTINUE\n"); column = column + strlen(yytext);}
read		{printf("READ\n"); column = column + strlen(yytext);}
write		{printf("WRITE\n"); column = column + strlen(yytext);}
and			{printf("AND\n"); column = column + strlen(yytext);}
or			{printf("OR\n"); column = column + strlen(yytext);}
not			{printf("NOT\n"); column = column + strlen(yytext);}
true		{printf("TRUE\n"); column = column + strlen(yytext);}
false		{printf("FALSE\n"); column = column + strlen(yytext);}
return		{printf("RETURN\n"); column = column + strlen(yytext);}

	/* Arithmetic */

"-"			{printf("SUB\n"); column = column + strlen(yytext);}
"+"			{printf("ADD\n"); column = column + strlen(yytext);}
"*"			{printf("MULT\n"); column = column + strlen(yytext);}
"/"			{printf("DIV\n"); column = column + strlen(yytext);}
"%"			{printf("MOD\n"); column = column + strlen(yytext);}

	/* Comparison */

"=="		{printf("EQ\n"); column = column + strlen(yytext);}
"<>"		{printf("NEQ\n"); column = column + strlen(yytext);}
"<"			{printf("LT\n"); column = column + strlen(yytext);}
">"			{printf("GT\n"); column = column + strlen(yytext);}
"<="		{printf("LTE\n"); column = column + strlen(yytext);}
">="		{printf("GTE\n"); column = column + strlen(yytext);}

	/* Special Symbols */

";"			{printf("SEMICOLON\n"); column = column + strlen(yytext);}
":"			{printf("COLON\n"); column = column + strlen(yytext);}
","			{printf("COMMA\n"); column = column + strlen(yytext);}
"("			{printf("L_PAREN\n"); column = column + strlen(yytext);}
")"			{printf("R_PAREN\n"); column = column + strlen(yytext);}
"["			{printf("L_SQUARE_BRACKET\n"); column = column + strlen(yytext);}
"]"			{printf("R_SQUARE_BRACKET\n"); column = column + strlen(yytext);}
":="		{printf("ASSIGN\n"); column = column + strlen(yytext);}

	/* Identifiers and Error Handling has to be here or rest of rules don't match */

{Comment}	{row = row + 1; column = 1;}
{Number} 	{printf("NUMBER %s\n", yytext); column = column + strlen(yytext);}
{Ident}		{printf("IDENT %s\n", yytext); column = column + strlen(yytext);}
{Error1}	{printf("Error at line %d, column %d: Identifier \"%s\" must begin with a letter\n", row, column, yytext); column = column + strlen(yytext); exit(0);}
{Error2}	{printf("Error at line %d, column %d: Identifier \"%s\" cannot end with an underscore\n", row, column, yytext); column = column + strlen(yytext); exit(0);}
.			{printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", row, column, yytext);} 

%%