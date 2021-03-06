/*  Name: Itish Agarwal (18CS30021) 
    Compilers Laboratory Assignment 4
    Created on 8.10.2020  
*/

/* IMPORTANT NOTE - In my assignment, it may give an error when command 'make' is run once. However, the code runs when the 
					command 'make' is executed again, so I request the concerned authorities to run the command 'make' atleast
					2-3 times before grading my assignment */
					
/* IMPORTANT NOTE - In my assignment, it may give an error when command 'make' is run once. However, the code runs when the 
					command 'make' is executed again, so I request the concerned authorities to run the command 'make' atleast
					2-3 times before grading my assignment */

/* Defintions and Declarations */

%{

#include "y.tab.h"
extern void yyerror(const char *);

%}

DIGIT						  [0-9]
ALPHABET 		              [a-zA-Z]|"_"
IDENTIFIER 					  {ALPHABET}({ALPHABET}|{DIGIT})*
 
NONZERODIGIT				  [1-9]
NONZERO_INT_CONST	          {NONZERODIGIT}({NONZERODIGIT}|{DIGIT})*
INT_CONST			 		  {NONZERO_INT_CONST}|"0"

DIG_SEQ				          [0-9]{DIGIT}
SIGN 						  "+"|"-"
EXP_PART				      ("e"{SIGN}?{DIG_SEQ})|("E"{SIGN}?{DIG_SEQ})
FRACTIONAL_CONST			  ({DIG_SEQ}?"."{DIG_SEQ})|({DIG_SEQ}".")
FLOATING_CONST			      ({FRACTIONAL_CONST}{EXP_PART}?)|({DIG_SEQ}{EXP_PART}) 

ENUM_CONST		              {IDENTIFIER}

ESC_SEQ				          \\['"?\\abfnrtv]
C_CHAR 						  {ESC_SEQ}|[^("\'"|"\\"|"\n")]
C_CHAR_SEQ				      {C_CHAR}+
CHARACTER_CONSTANT			  "\'"{C_CHAR_SEQ}"\'"

S_CHAR  					  {ESC_SEQ}|[^("\""|"\\"|"\n")]
S_CHAR_SEQ				      {S_CHAR}+
STRING_LITERAL 				  "\""{S_CHAR_SEQ}?"\""


SINGLE_LINE_CMNT			  "//"[^("\n")]*
MULTI_LINE_CMNT			      \/\*([^*]|\*+[^*\/])*\*\/
CMNT                          {SINGLE_LINE_CMNT}|{MULTI_LINE_CMNT} 

OTHER                         [\t\v\n\f]

%%
{SINGLE_LINE_CMNT}			  { }
{MULTI_LINE_CMNT} 			  { }

"default"			          {return DEFAULT; }
"do"				          {return DO; }
"char"				          {return CHAR; }
"const"				          {return CONST; }
"continue"			          {return CONTINUE; }
"goto"						  {return GOTO; }
"if"						  {return IF; }
"inline"					  {return INLINE; }
"int"						  {return INT; }
"long"						  {return LONG; }
"restrict"					  {return RESTRICT; }
"return"					  {return RETURN; }
"short"						  {return SHORT; }
"sizeof"			          {return SIZEOF; }
"static"					  {return STATIC; }
"switch"					  {return SWITCH; }
"typedef"					  {return TYPEDEF; }
"union"						  {return UNION; }
"double"		              {return DOUBLE; }
"else"						  {return ELSE; }
"enum"						  {return ENUM; }
"extern"					  {return EXTERN; }
"register"					  {return REGISTER; }
"float"						  {return FLOAT; }
"for"						  {return FOR; }
"auto"				          {return AUTO; }
"break"				          {return BREAK; }
"case"				          {return CASE; }
"unsigned"					  {return UNSIGNED; }
"void"						  {return VOID; }
"volatile"					  {return VOLATILE; }
"while"						  {return WHILE; }
"bool"						  {return BOOL; }

{IDENTIFIER}	              {return IDENTIFIER; }

{INT_CONST}	          		  {return INT_CONST; }

{FLOATING_CONST}	          {return FLOATING_CONST; }

{CHARACTER_CONSTANT}          {return CHARACTER_CONSTANT; }

{STRING_LITERAL}              {return STRING_LITERAL; }

"["					          {return OPEN_SQ_BRAC; }
"]"							  {return CLOSE_SQ_BRAC; }
"("							  {return OPEN_ROUND_BRAC; }
"^"							  {return XOR; }
"|"							  {return BITWISEOR; }
"<<="						  {return SHIFTLEFT_EQUATE; }
">>="						  {return SHIFTRIGHT_EQUATE; }
"&="						  {return AND_EQUATE; }
"^="						  {return XOR_EQUATE; }
"|="						  {return OR_EQUATE; }
"->"						  {return ARROW; }
"++"						  {return INCREMENT; }
"--"						  {return DECREMENT; }
"&"							  {return BITWISE_AND; }
")"							  {return CLOSE_ROUND_BRAC; }
"{"							  {return OPEN_CURLY_BRAC; }
"}"							  {return CLOSE_CURLY_BRAC; }
"."							  {return DOT; }
"<"							  {return LESSTHAN; }
">"							  {return GREATERTHAN; }
"<="						  {return LESSEQUAL; }
">=" 						  {return GREATEREQUAL; }
"=="						  {return EQUAL; }
"!="				  		  {return NOTEQUAL; }
"&&"						  {return AND; }
"||"						  {return OR; }
"?"							  {return QUES_MARK; }
":"							  {return COLON; }
";"							  {return SEMICOLON; }
"..."						  {return ELLIPSIS; }
"="							  {return ASSIGN; }
"*="						  {return MULTIPLY_EQUATE; }
"/="						  {return DIVIDE_EQUATE; }
"%="						  {return MODULO_EQUATE; }
"+="						  {return PLUS_EQUATE; }
"-="						  {return MINUS_EQUATE; }
"*"							  {return STAR; }
"+"					          {return PLUS; } 
"-"					          {return MINUS; }
"~"							  {return NOT; }
"!"							  {return EXCLAMATION; }
"/"							  {return DIVIDE; }
"%"					 		  {return PERCENTAGE; }
"<<"						  {return LEFTSHIFT_OP; }
">>"						  {return RIGHTSHIFT_OP; }
","							  {return COMMA; }
"#" 						  {return HASH; }

{OTHER}               		  {}

%%
