/*  Name: Itish Agarwal (18CS30021) 
    Compilers Laboratory Assignment 3 
    Created on 24.9.2020  
*/

/* 	This file contains flex specifications */

/*  Defintions and declarations */


%{
	#define	KEYWORD				1
	#define	IDENTIFIER			2
	#define	STRING_LITERAL 		3
	#define	PUNCTUATOR			4
	#define COMMENT 			5
	#define INTEGER_CONST		6
	#define FLT_CONST			7
	#define CH_CONST			8
	#define SL_COMMENT			9
	#define ML_COMMENT			10
%}


NONZERODIGIT			[1-9]    
DIGIT 					[0-9]
ID_ND					[a-zA-Z_]
ZERO 					"0"
DOT 					"."

ID 						({ID_ND}(({ID_ND}|{DIGIT})*))

SINGLE_LINE_CMNT		"//"[^("\n")]*
MULT_LINE_CMNT			\/\*([^*]|\*+[^*\/])*\*\/
CMNT 					{SINGLE_LINE_CMNT}|{MULT_LINE_CMNT}

INT_CONST 				({NONZERODIGIT}({DIGIT}*|{ZERO}+))|{ZERO}

STR_LITERAL 			\"{S_CHAR_SEQ}?\"
S_CHAR_SEQ 				{S_CHAR}+
S_CHAR 					[^\"\\\n]|{ESCAPE_SEQ}

FLOAT_CONST 			({FRACTINAL_CONST}{EXP_PART}?)|({DIG_SEQ}{EXP_PART})
FRACTINAL_CONST 		({DIG_SEQ}?{DOT}{DIG_SEQ})|({DIG_SEQ}{DOT})
EXP_PART 				([eE]{SIGN}?{DIG_SEQ})
SIGN 					"+"|"-"
DIG_SEQ 				({DIGIT}+)

CHAR_CONST 				([']{C_CHAR_SEQ}['])
C_CHAR_SEQ 				{C_CHAR}+
C_CHAR 					[^\'\\\n]|{ESCAPE_SEQ}
ESCAPE_SEQ 				[\\][\'\"?\\abfnrtv]

WHITESPACE				[ \t\n]+

%%

"default"				{return KEYWORD; }
"do"					{return KEYWORD; }
"double"				{return KEYWORD; }
"else"					{return KEYWORD; }
"extern"				{return KEYWORD; }
"float"					{return KEYWORD; }
"for"					{return KEYWORD; }
"goto"					{return KEYWORD; }
"if"					{return KEYWORD; }
"int"					{return KEYWORD; }
"long"					{return KEYWORD; }
"return"				{return KEYWORD; }
"short"					{return KEYWORD; }
"sizeof"				{return KEYWORD; }
"static"				{return KEYWORD; }
"struct"				{return KEYWORD; }
"switch"				{return KEYWORD; }
"typedef"				{return KEYWORD; }
"union"					{return KEYWORD; }
"void"					{return KEYWORD; }
"while"					{return KEYWORD; }
"break"					{return KEYWORD; }
"case"					{return KEYWORD; }
"char"					{return KEYWORD; }
"continue"				{return KEYWORD; }

"~"						{return PUNCTUATOR; }
"!"						{return PUNCTUATOR; }
"/"						{return PUNCTUATOR; } 
"%"						{return PUNCTUATOR; }
"<<"					{return PUNCTUATOR; }
">>"					{return PUNCTUATOR; }
"<"						{return PUNCTUATOR; }
">"						{return PUNCTUATOR; }
"<="					{return PUNCTUATOR; }
">="					{return PUNCTUATOR; }
"=="					{return PUNCTUATOR; }
"!="					{return PUNCTUATOR; }
"^"						{return PUNCTUATOR; }
"|"						{return PUNCTUATOR; } 
"&&"					{return PUNCTUATOR; }
"||"					{return PUNCTUATOR; }
"?"						{return PUNCTUATOR; }
":"						{return PUNCTUATOR; }
";"						{return PUNCTUATOR; }
"..."					{return PUNCTUATOR; }
"="						{return PUNCTUATOR; }
"*="					{return PUNCTUATOR; } 
"/="					{return PUNCTUATOR; }
"%="					{return PUNCTUATOR; }
"+="					{return PUNCTUATOR; }
"-="					{return PUNCTUATOR; } 
"<<="					{return PUNCTUATOR; }
">>="					{return PUNCTUATOR; } 
"&="					{return PUNCTUATOR; }
"^="					{return PUNCTUATOR; }
"|="					{return PUNCTUATOR; }
","						{return PUNCTUATOR; }
"#"						{return PUNCTUATOR; }
"["						{return PUNCTUATOR; }
"]"						{return PUNCTUATOR; }
"("						{return PUNCTUATOR; }
")"						{return PUNCTUATOR; }
"{"						{return PUNCTUATOR; }
"}"						{return PUNCTUATOR; } 
"."						{return PUNCTUATOR; }
"->"					{return PUNCTUATOR; }
"++"					{return PUNCTUATOR; }
"--"					{return PUNCTUATOR; }
"&"						{return PUNCTUATOR; }
"*"						{return PUNCTUATOR; }
"+"						{return PUNCTUATOR; }
"-"						{return PUNCTUATOR; }

{WHITESPACE}			{}
{ID}					{return IDENTIFIER; }
{INT_CONST}				{return INTEGER_CONST; }
{FLOAT_CONST}			{return FLT_CONST; }
{CHAR_CONST}			{return CH_CONST; }
{STR_LITERAL}			{return STRING_LITERAL; }
{SINGLE_LINE_CMNT}		{return SL_COMMENT; }
{MULT_LINE_CMNT}		{return ML_COMMENT; }

%%
