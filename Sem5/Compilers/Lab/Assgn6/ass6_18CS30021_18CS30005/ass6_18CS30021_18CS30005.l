%option noyywrap

%{
    #include "ass6_18CS30021_18CS30005_translator.h"
	#include "y.tab.h"
	// extern "C" int yylex();
	extern void yyerror(const char *);
	static void comment(void);
%}

DIG 									[0-9]
NON_ZERO_DIG 							[1-9]
IDENTIFIER_ND 							[A-Za-z_]
IDENTIFIER 								({IDENTIFIER_ND}({IDENTIFIER_ND}|{DIG})*)
WHITESPACE								[ \n\t]
SIGN 									"+"|"-"
DIG_SEQ 								{DIG}+
EXP_PART 								([eE]{SIGN}?{DIG_SEQ})
ZERO 									"0"
INT_CONST 								(({NON_ZERO_DIG}({DIG}*))|{ZERO}+)
DOT 									"."
FRACT_CONST 							(({DIG_SEQ}?{DOT}{DIG_SEQ})|({DIG_SEQ}{DOT}))
FLOAT_CONST 							(({FRACT_CONST}{EXP_PART}?)|({DIG_SEQ}{EXP_PART}))
ENUM_CONST 								{IDENTIFIER}
ESCAPE_SEQ 								([\\][\'\"\?\\abfnrtv])
C_CHAR 									[^\'\\\n]|{ESCAPE_SEQ}
C_CHAR_SEQ 								{C_CHAR}+
C_CHAR_CONST 							(\'{C_CHAR_SEQ}\')
CONST 									({INT_CONST}|{FLOAT_CONST}|{ENUM_CONST}|{C_CHAR_CONST})
S_CHAR 									[^\"\\\n]|{ESCAPE_SEQ}
S_CHAR_SEQ 								{S_CHAR}+
STRING_LITERAL 							(\"{S_CHAR_SEQ}*\")
SINGLE_LINE_CMNT 						[/][/].*
MULTI_END 								[\*]+[/]
MULTI_START 							[/][\*]+
NON_STAR 								(([^\*]).*)
NON_FS 									([^/].*)
AVOID_MULTI_END 						(NON_STAR|([\*]{NON_FS}))
MULTI_LINE_CMNT 						({MULTI_START}(([^\*])|((\*)+[^/\*]))*{MULTI_END})
COMMENT 								{SINGLE_LINE_CMNT}|{MULTI_LINE_CMNT}

%%

"["                 { return '['; }
"]"                 { return ']'; }
"("                 { return '('; }
")"                 { return ')'; }
"{"                 { return '{'; }
"}"                 { return '}'; }
"."                 { return '.'; }
"&"                 { return '&'; }
"*"                 { return '*'; }
"+"                 { return '+'; }
"-"                 { return '-'; }
"~"                 { return '~'; }
"^"                 { return '^'; }
"|"                 { return '|'; }
"!"                 { return '!'; }
"/"                 { return '/'; }
"||"                { return (OR); }
"?"                 { return '?'; }
":"                 { return ':'; }
";"                 { return ';'; }
"%"                 { return '%'; }
"<"                 { return '<'; }
">"                 { return '>'; }
"->"                { return (POINTER); }
"++"                { return (INCREMENT); }
"--"                { return (DECREMENT); }
"<<"                { return (LEFT_SHIFT); }
">>"                { return (RIGHT_SHIFT); }
"<="                { return (LESS_EQUAL); }
">="                { return (GREATER_EQUAL); }
"=="                { return (EQUAL); }
"!="                { return (NOT_EQUAL); }
"&&"                { return (AND); }
"..."               { return (ELLIPSIS); }
"="                 { return '='; }
"*="                { return MUL_AND_ASSIGN; }
"/="                { return DIV_AND_ASSIGN; }
"%="                { return MODULO_ASSIGN; }
"+="                { return ADD_ASSIGN; }
"-="                { return SUBTRACT_ASSIGN; }
"<<="               { return LEFT_SHIFT_ASSIGN; }
">>="               { return RIGHT_SHIFT_ASSIGN; }
"&="                { return AND_ASSIGN; }
"short"             { return SHORT;}
"volatile"          { return VOLATILE;}
"_Bool"             { return BOOL;}
"if"                { return IF;}
"static"            { return STATIC;}
"_Complex"          { return COMPLEX;}
"default"           { return DEFAULT;}
"inline"            { return INLINE;}
"struct"            { return STRUCT;}
","                 { return ','; }
"#"                 { return '#'; }
"auto"              { return AUTO;}
"enum"              { return ENUM;}
"_Imaginary"        { return IMAGINARY;}
"do"                { return DO;}
"int"               { return INT;}
"typedef"           { return TYPEDEF;}
"continue"          { return CONTINUE;}
"^="                { return XOR_ASSIGN; }
"|="                { return OR_ASSIGN; }
"restrict"          { return RESTRICT;} 
"unsigned"          { return UNSIGNED;}
"break"             { return BREAK;}
"extern"            { return EXTERN;}
"return"            { return RETURN;}
"void"              { return VOID;}
"char"              { return CHAR;}
"for"              	{ return FOR;}
"else"              { return ELSE;}
"register"          { return REGISTER;}
"union"             { return UNION;}
"signed"            { return SIGNED;}
"while"             { return WHILE;}
"const"             { return CONST;}
"goto"              { return GOTO;}
"sizeof"            { return SIZEOF;}
"case"              { return CASE;}
"float"             { return FLOAT;}
"switch"            { return SWITCH;}
"double"            { return DOUBLE;}
"long"              { return LONG;}

{IDENTIFIER}        { yylval.idl.name=new string(yytext);return IDENTIFIER;}

{INT_CONST}         { yylval.intVAL=atoi(yytext); return INTEGER_CONSTANT;}
{FLOAT_CONST}		{ yylval.floatVAL=atof(yytext); return FLOATING_CONSTANT;}
{ENUM_CONST}		{ return(ENUMERATION_CONSTANT);}
{C_CHAR_CONST}		{ yylval.charVAL=yytext[1]; return CHAR_CONST;}

{STRING_LITERAL}    { yylval.strVAL = new string(yytext);return STRING_LITERAL;}

{COMMENT}           {;}

{WHITESPACE}        {;}

%%
