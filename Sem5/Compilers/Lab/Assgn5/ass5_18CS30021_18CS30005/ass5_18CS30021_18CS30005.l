/* Compiler lab assignment 5
   Group number 47
   Itish Agarwal - 18CS30021
   Aditya Singh  - 18CS30005 
*/

%{
	#include <stdio.h>
	#include <string.h>
	#include "ass5_18CS30021_18CS30005_translator.h"
	#include "y.tab.h"
%}

/* Define regular expressions now */

%option noyywrap


KEYWORD 					"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"inline"|"int"|"long"|"register"|"restrict"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"|"_Bool"|"_Complex"|"_Imaginary"

DIG							[0-9]
ID_NONDIG 					[a-zA-Z]|"_"
IDENTIFIER 					{ID_NONDIG}({ID_NONDIG}|{DIG})*

INTEGER_CONST				{NONZERO_INTEGER_CONST}|"0"
NONZERO_INTEGER_CONST		{NONZERO_DIG}({NONZERO_DIG}|{DIG})*
NONZERO_DIG					[1-9]

SIGN 						"+"|"-"
DIG_SEQUALUENCE				{DIG}({DIG})*
EXPONENT_PART				("e"{SIGN}?{DIG_SEQUALUENCE})|("E"{SIGN}?{DIG_SEQUALUENCE})
FRACTIONAL_CONST			({DIG_SEQUALUENCE}?"."{DIG_SEQUALUENCE})|({DIG_SEQUALUENCE}".")
FLOATING_CONST				({FRACTIONAL_CONST}{EXPONENT_PART}?)|({DIG_SEQUALUENCE}{EXPONENT_PART})

ENUMERATION_CONST			{IDENTIFIER}

ESCAPE_SEQUAL				"\'"|"\""|"\?"|"\\"|"\a"|"\b"|"\f"|"\n"|"\r"|"\t"|"\v"
C_CHAR 						{ESCAPE_SEQUAL}|[^("\'"|"\\"|"\n")]
C_CHAR_SEQUAL				{C_CHAR}+
CHAR_CONST					'(\\[tvrnafb\\]|[^\\'])'

S_CHAR  					{ESCAPE_SEQUAL}|[^("\""|"\\"|"\n")]
S_CHAR_SEQUAL				{S_CHAR}+
STRING_LIT 					"\""{S_CHAR_SEQUAL}?"\""

PUNCTUATOR 					"["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"

%x single_line_comment multi_line_comment

%%

"//"			{BEGIN(single_line_comment);}
<single_line_comment>[^\n]	{}
<single_line_comment>"\n"		{BEGIN(INITIAL);}
<single_line_comment><<EOF>>	{BEGIN(INITIAL);}

"/*"			{BEGIN(multi_line_comment);}
<multi_line_comment>[^*]	{}
<multi_line_comment>"*"[^/]	{}
<multi_line_comment>"*/"	{BEGIN(INITIAL);}

{KEYWORD}		{

	if (strcmp(yytext, "auto") == 0)			{return AUTO; }
	if (strcmp(yytext, "break") == 0)			{return BREAK; }
	if (strcmp(yytext, "default") == 0)		{return DEFAULT; }
	if (strcmp(yytext, "do") == 0)			{return DO; }
	if (strcmp(yytext, "double") == 0)		{return DOUBLE; }
	if (strcmp(yytext, "struct") == 0)	    {return STRUCT; }
	if (strcmp(yytext, "short") == 0)			{return SHORT; }
	if (strcmp(yytext, "register") == 0)		{return REGISTER; }
	if (strcmp(yytext, "void") == 0)			{return VOID; }
	if (strcmp(yytext, "restrict") == 0)		{return RESTRICT; } 
	if (strcmp(yytext, "unsigned") == 0)		{return UNSIGNED; }
	if (strcmp(yytext, "return") == 0)		{return RETURN; }
	if (strcmp(yytext, "else") == 0)			{return ELSE; }
	if (strcmp(yytext, "enum") == 0)			{return ENUM; }
	if (strcmp(yytext, "extern") == 0)		{return EXTERN; }
	if (strcmp(yytext, "float") == 0)			{return FLOAT; }
	if (strcmp(yytext, "for") == 0)			{return FOR; }
	if (strcmp(yytext, "goto") == 0)			{return GOTO; }
	if (strcmp(yytext, "signed") == 0)		{return SIGNED; }
	if (strcmp(yytext, "volatile") == 0)		{return VOLATILE; }
	if (strcmp(yytext, "while") == 0)			{return WHILE; }
	if (strcmp(yytext, "sizeof") == 0)		{return SIZEOF; }
	if (strcmp(yytext, "_Bool") == 0)			{return _BOOL; }
	if (strcmp(yytext, "if") == 0)			{return IF; }
	if (strcmp(yytext, "static") == 0)		{return STATIC; }
	if (strcmp(yytext, "inline") == 0)		{return INLINE; }
	if (strcmp(yytext, "case") == 0)			{return CASE; }
	if (strcmp(yytext, "char") == 0)		  	{return CHAR; }
	if (strcmp(yytext, "const") == 0)			{return CONST; }
	if (strcmp(yytext, "continue") == 0)		{return CONTINUE; }
	if (strcmp(yytext, "int") == 0)			{return INT; }
	if (strcmp(yytext, "switch") == 0)		{return SWITCH; }
	if (strcmp(yytext, "long") == 0)			{return LONG; }
	if (strcmp(yytext, "typedef") == 0)		{return TYPEDEF; }
	if (strcmp(yytext, "union") == 0)			{return UNION; }

}

{PUNCTUATOR}	{

	if (strcmp(yytext, "[") == 0)  			{return SQ_BRAC_OPEN; }
	if (strcmp(yytext, "]") == 0) 			{return SQ_BRAC_CLOSE; }
	if (strcmp(yytext, "(") == 0) 			{return ROUND_BRAC_OPEN; }
	if (strcmp(yytext, ")") == 0)				{return ROUND_BRAC_CLOSE; }
	if (strcmp(yytext, "{") == 0) 			{return CURLY_BRAC_OPEN; }
	if (strcmp(yytext, "}") == 0) 			{return CURLY_BRAC_CLOSE; }
	if (strcmp(yytext, ".") == 0) 			{return DOT; }
	if (strcmp(yytext, "->") == 0) 			{return IMPLIES; }
	if (strcmp(yytext, "-=") == 0) 			{return SUBTRACT_EQUAL; }
	if (strcmp(yytext, "--") == 0) 			{return DEC; }
	if (strcmp(yytext, "&") == 0)   			{return BITWISE_AND; } 
	if (strcmp(yytext, "*") == 0) 			{return MULTIPLY; }
	if (strcmp(yytext, "+") == 0) 			{return ADD; }
	if (strcmp(yytext, "-") == 0) 			{return SUBTRACT; }
	if (strcmp(yytext, "~") == 0) 			{return BITWISE_NOT; }
	if (strcmp(yytext, "!") == 0) 			{return EXCLAIM; }
	if (strcmp(yytext, "/") == 0) 			{return DIVISION; }
	if (strcmp(yytext, "%") == 0) 			{return MOD; }
	if (strcmp(yytext, "<<") == 0) 			{return LEFT_SHIFT; }
	if (strcmp(yytext, ">>") == 0) 			{return RIGHT_SHIFT; }
	if (strcmp(yytext, "<") == 0) 			{return BIT_SL; }
	if (strcmp(yytext, ">") == 0) 			{return BIT_SR; }
	if (strcmp(yytext, "<=") == 0) 			{return LESS_OR_EQUAL; }
	if (strcmp(yytext, ">=") == 0) 			{return GREATER_OR_EQUAL; }
	if (strcmp(yytext, "++") == 0) 			{return INC; }
	if (strcmp(yytext, "==") == 0) 			{return EQUAL; }
	if (strcmp(yytext, "!=") == 0) 			{return NEQUAL; }
	if (strcmp(yytext, "^") == 0) 			{return BITWISE_XOR; }
	if (strcmp(yytext, "|") == 0) 			{return BITWISE_OR; }
	if (strcmp(yytext, "&&") == 0) 			{return AND; }
	if (strcmp(yytext, "||") == 0) 			{return OR; }
	if (strcmp(yytext, "?") == 0) 			{return QUESTION; }
	if (strcmp(yytext, ":") == 0) 			{return COLON; }
	if (strcmp(yytext, ";") == 0) 			{return SEMICOLON; }
	if (strcmp(yytext, "...") == 0) 			{return DOTS; }
	if (strcmp(yytext, "=") == 0) 			{return ASSIGN; }
	if (strcmp(yytext, "*=") == 0) 			{return STAR_EQUAL; }
	if (strcmp(yytext, "/=") == 0) 			{return DIVISION_EQUAL; }
	if (strcmp(yytext, "%=") == 0) 			{return MOD_EQUAL; }
	if (strcmp(yytext, "+=") == 0) 			{return ADD_EQUAL; }	
	if (strcmp(yytext, "<<=") == 0) 			{return SL_EQUAL; }
	if (strcmp(yytext, ">>=") == 0) 			{return SR_EQUAL; }
	if (strcmp(yytext, "&=") == 0) 			{return BITWISE_AND_EQUAL; }
	if (strcmp(yytext, "^=") == 0) 			{return BITWISE_XOR_EQUAL; }
	if (strcmp(yytext, "|=") == 0) 			{return BITWISE_OR_EQUAL; }
	if (strcmp(yytext, ",") == 0) 			{return COMMA; }
	if (strcmp(yytext, "#") == 0) 			{return HASH; }

}

{IDENTIFIER}		{

	yylval.symp = ST->lookup(yytext);
	return IDENTIFIER;

}

{INTEGER_CONST}		{

	yylval.intVal = atoi(yytext);
	return INTEGER_CONST;

}

{FLOATING_CONST}	{

	yylval.char_value = yytext;
	return FLOATING_CONST;

}

{CHAR_CONST}		{

	yylval.char_value = yytext;
	return CHAR_CONST;

}

{STRING_LIT}			{

	yylval.char_value = yytext;
	return STRING_LIT;

}

"\n"|" "|"\t"	{

}

%%
		
