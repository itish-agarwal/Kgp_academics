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

%{ 
	#include <string.h>
	#include <stdio.h>
	extern int yylex();
	void yyerror(char *errorS);
%}

%union {
	int value;
}

%token DEFAULT
%token DO
%token CHAR
%token CONST
%token CONTINUE
%token GOTO
%token IF
%token INLINE
%token INT
%token LONG
%token RESTRICT
%token RETURN
%token SHORT
%token SIZEOF
%token STATIC
%token SWITCH
%token TYPEDEF
%token UNION
%token DOUBLE
%token ELSE
%token ENUM
%token EXTERN
%token REGISTER
%token FLOAT
%token FOR
%token AUTO
%token BREAK
%token CASE
%token UNSIGNED
%token VOID
%token VOLATILE
%token WHILE
%token BOOL

%token OPEN_SQ_BRAC
%token CLOSE_SQ_BRAC
%token OPEN_ROUND_BRAC
%token XOR
%token BITWISEOR
%token SHIFTLEFT_EQUATE
%token SHIFTRIGHT_EQUATE
%token AND_EQUATE
%token XOR_EQUATE
%token OR_EQUATE
%token ARROW
%token INCREMENT
%token DECREMENT
%token BITWISE_AND
%token CLOSE_ROUND_BRAC
%token OPEN_CURLY_BRAC
%token CLOSE_CURLY_BRAC
%token DOT
%token LESSTHAN
%token GREATERTHAN
%token LESSEQUAL
%token GREATEREQUAL
%token EQUAL
%token NOTEQUAL
%token AND
%token OR
%token QUES_MARK
%token COLON
%token SEMICOLON
%token ELLIPSIS
%token ASSIGN
%token MULTIPLY_EQUATE
%token DIVIDE_EQUATE
%token MODULO_EQUATE
%token PLUS_EQUATE
%token MINUS_EQUATE
%token STAR
%token PLUS 
%token MINUS
%token NOT
%token EXCLAMATION
%token DIVIDE
%token PERCENTAGE
%token LEFTSHIFT_OP
%token RIGHTSHIFT_OP
%token COMMA
%token HASH

%token IDENTIFIER

%token INT_CONST
%token FLOATING_CONST
%token CHARACTER_CONSTANT
%token STRING_LITERAL

%token SINGLE_LINE_COMMENT
%token MULTI_LINE_COMMENT

%nonassoc THEN
%nonassoc ELSE
%start translation_unit

%%

constant :                                              INT_CONST 
		                                                | FLOATING_CONST 
		                                                | CHARACTER_CONSTANT ;

primary_expression :                                    IDENTIFIER 
														{ printf("PRIMARY_EXPRESSION\n");};
														| constant 
														{ printf("PRIMARY_EXPRESSION\n");};
														| STRING_LITERAL 
														{ printf("PRIMARY_EXPRESSION\n");};
														| OPEN_ROUND_BRAC expression CLOSE_ROUND_BRAC 
														{ printf("PRIMARY_EXPRESSION\n");};

postfix_expression :             						primary_expression 
														{printf("POSTFIX_EXPRESSION\n");};
														| postfix_expression OPEN_SQ_BRAC expression CLOSE_SQ_BRAC 
														{printf("POSTFIX_EXPRESSION\n");};
														| postfix_expression OPEN_ROUND_BRAC CLOSE_ROUND_BRAC
														{printf("POSTFIX_EXPRESSION\n");}; 
														| postfix_expression OPEN_ROUND_BRAC argument_expression_list CLOSE_ROUND_BRAC 
														{printf("POSTFIX_EXPRESSION\n");};
														| postfix_expression DOT IDENTIFIER 
														{printf("POSTFIX_EXPRESSION\n");};
														| postfix_expression ARROW IDENTIFIER 
														{printf("POSTFIX_EXPRESSION\n");};
														| postfix_expression INCREMENT 
														{printf("POSTFIX_EXPRESSION\n");};
														| postfix_expression DECREMENT 
														{printf("POSTFIX_EXPRESSION\n");};
														| OPEN_ROUND_BRAC type_name CLOSE_ROUND_BRAC OPEN_CURLY_BRAC initializer_list CLOSE_CURLY_BRAC 
														{printf("POSTFIX_EXPRESSION\n");};
														|  OPEN_ROUND_BRAC type_name CLOSE_ROUND_BRAC OPEN_CURLY_BRAC initializer_list COMMA CLOSE_CURLY_BRAC 
														{printf("POSTFIX_EXPRESSION\n");};

unary_operator: 										BITWISE_AND 
														{printf("UNARY_OPERATOR\n");};
														| STAR 
														{printf("UNARY_OPERATOR\n");};
														| PLUS 
														{printf("UNARY_OPERATOR\n");};
														| MINUS 
														{printf("UNARY_OPERATOR\n");};
														| NOT 
														{printf("UNARY_OPERATOR\n");};
														| EXCLAMATION 
														{printf("UNARY_OPERATOR\n");};

cast_expression : 										unary_expression 
										                {printf("CAST_EXPRESSION\n");};
														| OPEN_ROUND_BRAC type_name CLOSE_ROUND_BRAC cast_expression 
														{printf("CAST_EXPRESSION\n");};


argument_expression_list : 								assignment_expression 
														 { printf("ARGUMENT_EXPRESSION_LIST\n");};
														 | argument_expression_list COMMA assignment_expression 
														 { printf("ARGUMENT_EXPRESSION_LIST\n");};

unary_expression : 										postfix_expression 
										                  {printf("UNARY_EXPRESSION\n");};
														  | INCREMENT unary_expression 
														  {printf("UNARY_EXPRESSION\n");};
														  | DECREMENT unary_expression 
														  {printf("UNARY_EXPRESSION\n");};
														  | unary_operator cast_expression 
														  {printf("UNARY_EXPRESSION\n");};
														  | SIZEOF unary_expression 
														  {printf("UNARY_EXPRESSION\n");};
														  | SIZEOF OPEN_ROUND_BRAC type_name CLOSE_ROUND_BRAC 
														  {printf("UNARY_EXPRESSION\n");};

multiplicative_expression : 								cast_expression 
															{printf("MULTIPLICATIVE_EXPRESSION\n");};
															| multiplicative_expression STAR cast_expression 
															{printf("MULTIPLICATIVE_EXPRESSION\n");};
															| multiplicative_expression DIVIDE cast_expression
															{printf("MULTIPLICATIVE_EXPRESSION\n");}; 
															| multiplicative_expression PERCENTAGE cast_expression 
															{printf("MULTIPLICATIVE_EXPRESSION\n");};

additive_expression :										 multiplicative_expression
										 					{printf("ADDITIVE_EXPRESSION\n");}; 
															| additive_expression PLUS multiplicative_expression
															{printf("ADDITIVE_EXPRESSION\n");}; 
															| additive_expression MINUS multiplicative_expression 
															{printf("ADDITIVE_EXPRESSION\n");};

shift_expression : 											additive_expression 
															  {printf("SHIFT_EXPRESSION\n");};
															  | shift_expression LEFTSHIFT_OP additive_expression 
															  {printf("SHIFT_EXPRESSION\n");};
															  | shift_expression RIGHTSHIFT_OP additive_expression 
															  {printf("SHIFT_EXPRESSION\n");};

relational_expression : 									shift_expression 
									                        {printf("RELATIONAL_EXPRESSION\n");};
															| relational_expression LESSTHAN shift_expression 
															{printf("RELATIONAL_EXPRESSION\n");};
															| relational_expression GREATERTHAN shift_expression 
															{printf("RELATIONAL_EXPRESSION\n");};
															| relational_expression LESSEQUAL shift_expression 
															{printf("RELATIONAL_EXPRESSION\n");};
															| relational_expression GREATEREQUAL shift_expression 
															{printf("RELATIONAL_EXPRESSION\n");};

equality_expression : 										relational_expression 
										                    {printf("EQUALITY_EXPRESSION\n");};
															| equality_expression EQUAL relational_expression 
															{printf("EQUALITY_EXPRESSION\n");};
															| equality_expression NOTEQUAL relational_expression 
															{printf("EQUALITY_EXPRESSION\n");};

and_expression :											 equality_expression 
											                {printf("AND_EXPRESSION\n");};
															| and_expression BITWISE_AND equality_expression 
															{printf("AND_EXPRESSION\n");};

exclusive_or_expression :									 and_expression 
															{printf("EXCLUSIVE_OR_EXPRESSION \n");};
															| exclusive_or_expression XOR and_expression 
															{printf("EXCLUSIVE_OR_EXPRESSION \n");}; 

inclusive_or_expression :									 exclusive_or_expression 
									                        {printf("INCLUSIVE_OR_EXPRESSION\n");};
															| inclusive_or_expression BITWISEOR exclusive_or_expression
															{printf("INCLUSIVE_OR_EXPRESSION\n");};

logical_and_expression :									 inclusive_or_expression 
															{printf("LOGICAL_AND_EXPRESSION\n");};
															| logical_and_expression AND inclusive_or_expression 
															{printf("LOGICAL_AND_EXPRESSION\n");};

logical_or_expression : 									logical_and_expression 
															{printf("LOGICAL_OR_EXPRESSION \n");};
															| logical_or_expression OR logical_and_expression 
															{printf("LOGICAL_OR_EXPRESSION \n");};

conditional_expression : 									logical_or_expression 
												            {printf("CONDITIONAL_EXPRESSION\n");};
															| logical_or_expression QUES_MARK expression COLON conditional_expression 
															{printf("CONDITIONAL_EXPRESSION\n");};

assignment_expression : 									conditional_expression 
															{printf("ASSIGNMENT_EXPRESSION\n");};
															| unary_expression assignment_operator assignment_expression 
															{printf("ASSIGNMENT_EXPRESSION\n");};

assignment_operator : 										ASSIGN 
															{printf("ASSIGNMENT_OPERATOR\n");};
															| MULTIPLY_EQUATE 
															{printf("ASSIGNMENT_OPERATOR\n");};
															| DIVIDE_EQUATE 
															{printf("ASSIGNMENT_OPERATOR\n");};
															| MODULO_EQUATE 
															{printf("ASSIGNMENT_OPERATOR\n");};
															| PLUS_EQUATE
															{printf("ASSIGNMENT_OPERATOR\n");}; 
															| MINUS_EQUATE
															{printf("ASSIGNMENT_OPERATOR\n");}; 
															| SHIFTLEFT_EQUATE 
															{printf("ASSIGNMENT_OPERATOR\n");};
															| SHIFTRIGHT_EQUATE 
															{printf("ASSIGNMENT_OPERATOR\n");};
															| AND_EQUATE 
															{printf("ASSIGNMENT_OPERATOR\n");};
															| XOR_EQUATE
															{printf("ASSIGNMENT_OPERATOR\n");}; 
															| OR_EQUATE 
															{printf("ASSIGNMENT_OPERATOR\n");};

expression : 												assignment_expression
															{printf("EXPRESSION\n");}; 
															| expression COMMA assignment_expression 
															{printf("EXPRESSION\n");};

constant_expression : 										conditional_expression {printf("CONSTANT_EXPRESSION\n");};


declaration : 												declaration_specifiers SEMICOLON
															{printf("DECLARATION\n");}; 
															| declaration_specifiers init_declarator_list SEMICOLON
															{printf("DECLARATION\n");};

declaration_specifiers : 									storage_class_specifier 
															{printf("DECLARATION_SPECIFIERS\n");};
															| storage_class_specifier declaration_specifiers 
															{printf("DECLARATION_SPECIFIERS\n");};
															| type_specifier 
															{printf("DECLARATION_SPECIFIERS\n");};
															| type_specifier declaration_specifiers 
															{printf("DECLARATION_SPECIFIERS\n");};
															| type_qualifier 
															{printf("DECLARATION_SPECIFIERS\n");};
															| type_qualifier declaration_specifiers 
															{printf("DECLARATION_SPECIFIERS\n");};
															| function_specifier  
															{printf("DECLARATION_SPECIFIERS\n");};
															| function_specifier declaration_specifiers 
															{printf("DECLARATION_SPECIFIERS\n");};

init_declarator_list : 										init_declarator 
															{printf("INIT_DECLARATOR_LIST\n");};
															| init_declarator_list COMMA init_declarator 
															{printf("INIT_DECLARATOR_LIST\n");};

init_declarator : 											declarator 
															{printf("INIT_DECLARATOR\n");};
															| declarator ASSIGN initializer 
															{printf("INIT_DECLARATOR\n");};

storage_class_specifier :									EXTERN 
															{printf("STORAGE_CLASS_SPECIFIER\n");};
															| STATIC 
															{printf("STORAGE_CLASS_SPECIFIER\n");};
															| AUTO 
															{printf("STORAGE_CLASS_SPECIFIER\n");};
															| REGISTER 
															{printf("STORAGE_CLASS_SPECIFIER\n");};

type_specifier : 											VOID 
															{printf("TYPE_SPECIFIER\n");};
															| CHAR 
															{printf("TYPE_SPECIFIER\n");};
															| SHORT 
															{printf("TYPE_SPECIFIER\n");};
															| INT 
															{printf("TYPE_SPECIFIER\n");};
															| LONG 
															{printf("TYPE_SPECIFIER\n");};
															| FLOAT 
															{printf("TYPE_SPECIFIER\n");};
															| DOUBLE 
															{printf("TYPE_SPECIFIER\n");};
															| BOOL 
															{printf("TYPE_SPECIFIER\n");};
															| enum_specifier 
															{printf("TYPE_SPECIFIER\n");};

specifier_qualifier_list :									 type_specifier specifier_qualifier_list 
															{printf("SPECIFIER_QUALIFIER_LIST\n");};
															| type_specifier 
															{printf("SPECIFIER_QUALIFIER_LIST\n");};
															| type_qualifier specifier_qualifier_list 
															{printf("SPECIFIER_QUALIFIER_LIST\n");};
															| type_qualifier 
															{printf("SPECIFIER_QUALIFIER_LIST\n");};

enum_specifier : 											ENUM OPEN_CURLY_BRAC enumerator_list CLOSE_CURLY_BRAC 
															{printf("ENUM_SPECIFIER\n");};
															| ENUM IDENTIFIER OPEN_CURLY_BRAC enumerator_list CLOSE_CURLY_BRAC 
															{printf("ENUM_SPECIFIER\n");};
															| ENUM OPEN_CURLY_BRAC enumerator_list COMMA CLOSE_CURLY_BRAC 
															{printf("ENUM_SPECIFIER\n");};
															| ENUM IDENTIFIER OPEN_CURLY_BRAC enumerator_list COMMA CLOSE_CURLY_BRAC 
															{printf("ENUM_SPECIFIER\n");};
															| ENUM IDENTIFIER 
															{printf("ENUM_SPECIFIER\n");};

enumerator_list : 											enumerator
														     {printf("ENUMERATOR_LIST\n");};
															 | enumerator_list COMMA enumerator
															 {printf("ENUMERATOR_LIST\n");};

enumerator : 												IDENTIFIER 
												            {printf("ENUMERATOR\n");};
															| IDENTIFIER ASSIGN constant_expression 
															{printf("ENUMERATOR\n");};

type_qualifier : 											CONST     
															{printf("TYPE_QUAIFIER \n");};
															| VOLATILE 
															{printf("TYPE_QUAIFIER \n");};
															| RESTRICT 
															{printf("TYPE_QUAIFIER \n");};

function_specifier : 										INLINE {printf("FUNCTION_SPECIFIER\n");};

declarator : 												pointer direct_declarator 
															{printf("DECLARATOR\n");};
															| direct_declarator 
															{printf("DECLARATOR\n");};

direct_declarator : 										IDENTIFIER 
															| OPEN_ROUND_BRAC declarator CLOSE_ROUND_BRAC
															{printf("DIRECT_DECLARATOR\n");};
															| direct_declarator OPEN_SQ_BRAC  type_qualifier_list_opt assignment_expression_opt CLOSE_SQ_BRAC 
															{printf("DIRECT_DECLARATOR\n");};
															| direct_declarator OPEN_SQ_BRAC STATIC type_qualifier_list_opt assignment_expression CLOSE_SQ_BRAC 
															{printf("DIRECT_DECLARATOR\n");};
															| direct_declarator OPEN_SQ_BRAC type_qualifier_list_opt STAR CLOSE_SQ_BRAC 
															{printf("DIRECT_DECLARATOR\n");};
															| direct_declarator OPEN_ROUND_BRAC parameter_type_list CLOSE_ROUND_BRAC 
															{printf("DIRECT_DECLARATOR\n");};
															| direct_declarator OPEN_ROUND_BRAC identifier_list_opt CLOSE_ROUND_BRAC 
															{printf("DIRECT_DECLARATOR\n");};
															| direct_declarator OPEN_SQ_BRAC type_qualifier_list STATIC assignment_expression CLOSE_SQ_BRAC {printf("DIRECT_DECLARATOR\n");};

type_qualifier_list_opt :   | type_qualifier_list
assignment_expression_opt :   | assignment_expression
identifier_list_opt :   | identifier_list

pointer : 													STAR type_qualifier_list_opt 
															  {printf("POINTER\n");};
															  | STAR type_qualifier_list_opt pointer 
															  {printf("POINTER\n");};

type_qualifier_list : 										type_qualifier 
														   {printf("TYPE_QUALIFIER_LIST\n");};
													       | type_qualifier_list type_qualifier 
													       {printf("TYPE_QUALIFIER_LIST\n");};

parameter_type_list : 										parameter_list 
															  {printf("PARAMETER_TYPE_LIST\n");};
													          | parameter_list COMMA ELLIPSIS 
													          {printf("PARAMETER_TYPE_LIST\n");};

parameter_list : 											parameter_declaration 
														    {printf("PARAMETER_LIST\n");};
														    | parameter_list COMMA parameter_declaration 
														    {printf("PARAMETER_LIST\n");};

parameter_declaration : 									declaration_specifiers declarator 
									                        {printf("PARAMETER_DECLARATION\n");};
															| declaration_specifiers 
															{printf("PARAMETER_DECLARATION\n");};

identifier_list: 											IDENTIFIER 
															{printf("IDENTIFIER_LIST\n");};
															| identifier_list COMMA IDENTIFIER 
															{printf("IDENTIFIER_LIST\n");};


type_name : specifier_qualifier_list {printf("TYPE_NAME\n");};

initializer : 												assignment_expression 
														     {printf("INITIALIZER\n");};
															 | OPEN_CURLY_BRAC initializer_list CLOSE_CURLY_BRAC 
															 {printf("INITIALIZER\n");};
															 | OPEN_CURLY_BRAC initializer_list COMMA CLOSE_CURLY_BRAC 
															 {printf("INITIALIZER\n");};

initializer_list : 											designation_opt initializer  
															  {printf("INITIALIZER_LIST\n");};
															  | initializer_list COMMA designation_opt initializer 
															  {printf("INITIALIZER_LIST\n");};

designation_opt :   | designation

designation : designator_list ASSIGN {printf("DESIGNATION\n");};

designator_list : 											designator 
															{printf("DESIGNATOR_LIST\n");};
															| designator_list designator 
															{printf("DESIGNATOR_LIST\n");};

designator : 												OPEN_SQ_BRAC constant_expression CLOSE_SQ_BRAC 
															{printf("DESIGNATOR\n");};
															| DOT IDENTIFIER 
															{printf("DESIGNATOR\n");};

statement : 												labeled_statement 
															{printf("STATEMENT\n");} ;
															| compound_statement 
															{printf("STATEMENT\n");} ;
															| expression_statement
															{printf("STATEMENT\n");} ; 
															| selection_statement 
															{printf("STATEMENT\n");} ;
															| iteration_statement 
															{printf("STATEMENT\n");} ;
															| jump_statement 
															{printf("STATEMENT\n");} ;

labeled_statement : 										IDENTIFIER COLON statement 
															{printf("LABELED_STATMENT\n");};
															| CASE constant_expression COLON statement 
															{printf("LABELED_STATMENT\n");};
															| DEFAULT COLON statement 
															{printf("LABELED_STATMENT\n");};

compound_statement : 										OPEN_CURLY_BRAC CLOSE_CURLY_BRAC 
															{printf("COMPOUND_STATEMENT\n");};
															| OPEN_CURLY_BRAC block_item_list CLOSE_CURLY_BRAC 
															{printf("COMPOUND_STATEMENT\n");};

block_item_list : 											block_item 
															{printf("BLOCK_ITEM_LIST\n");};
															| block_item_list block_item 
															{printf("BLOCK_ITEM_LIST\n");};

block_item : 												declaration 
															{printf("BLOCK_ITEM\n");};
															| statement 
															{printf("BLOCK_ITEM\n");};

expression_statement : 										SEMICOLON 
															{printf("EXPRESSION_STATEMENT\n");};
															| expression SEMICOLON 
															{printf("EXPRESSION_STATEMENT\n");};

selection_statement : 										IF OPEN_ROUND_BRAC expression CLOSE_ROUND_BRAC statement %prec THEN 
															{printf("SELECTION_STATEMENT\n");};
															| IF OPEN_ROUND_BRAC expression CLOSE_ROUND_BRAC statement ELSE statement 
															{printf("SELECTION_STATEMENT\n");};
															| SWITCH OPEN_ROUND_BRAC expression CLOSE_ROUND_BRAC statement 
															{printf("SELECTION_STATEMENT\n");};

iteration_statement : 										WHILE OPEN_ROUND_BRAC expression CLOSE_ROUND_BRAC statement
															 {printf("ITERATION_STATEMENT\n");};
															 | DO statement WHILE OPEN_ROUND_BRAC expression CLOSE_ROUND_BRAC SEMICOLON
															 {printf("ITERATION_STATEMENT\n");};
															 | FOR OPEN_ROUND_BRAC expression_opt SEMICOLON expression_opt SEMICOLON expression_opt CLOSE_ROUND_BRAC statement
															 {printf("ITERATION_STATEMENT\n");};

expression_opt :   | expression

jump_statement :											 GOTO IDENTIFIER SEMICOLON 
															{printf("JUMP_STATEMENT\n");} ;
															| CONTINUE SEMICOLON
															{printf("JUMP_STATEMENT\n");} ; 
															| BREAK SEMICOLON 
															{printf("JUMP_STATEMENT\n");} ;
															| RETURN SEMICOLON 
															{printf("JUMP_STATEMENT\n");} ;
															| RETURN expression SEMICOLON 
															{printf("JUMP_STATEMENT\n");} ;

translation_unit : 											external_declaration 
															{printf("TRANSLATION_UNIT\n");};
															| translation_unit external_declaration 
															{printf("TRANSLATION_UNIT\n");};

external_declaration : 										function_definition 
															  {printf("EXTERNAL_DECLARATION\n");};
															  | declaration 
															  {printf("EXTERNAL_DECLARATION\n");};

function_definition : 										declaration_specifiers declarator declaration_list compound_statement 
															{printf("FUNCTION DEFINITION\n");};
															| declaration_specifiers declarator compound_statement 
															{printf("FUNCTION DEFINITION\n");};

declaration_list : 											declaration 
														     {printf("DECLARATION LIST\n");};
															 | declaration_list declaration
															 {printf("DECLARATION LIST\n");};


%%

void yyerror(char *errorS) {
	printf ("ERROR :- %s",errorS);
}


//End of File
