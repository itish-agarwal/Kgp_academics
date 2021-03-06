/* Compiler lab assignment 5
   Group number 47
   Itish Agarwal - 18CS30021
   Aditya Singh  - 18CS30005 
*/

%{

// -------------------- Header Files ---------------------------//

#include <iostream>              
#include <cstdlib>
#include <string>
#include <stdio.h>
#include <sstream>

// -------------------- Translator File ---------------------------//

#include "ass5_18CS30021_18CS30005_translator.h"

extern int yylex();
void yyerror(string s);
extern string var_type;

using namespace std;
%}


%union {           

	char unary;					//unary operator
	char* char_value;			//char value

	int instrNo;				//instruction number: for backpatching
	int intVal;					//integer value	
	int numParams;				//number of parameters

	Expression* expr;			//expression
	Statement* stat;			//statement		

	symboltype* symType;		//symbol type  
	sym* symp;					//symbol
	Array* A;  					//Array type
		
} 

// -------------------- Tokens ---------------------------//

%token AUTO 
%token BREAK
%token CASE 
%token CHAR
%token IF
%token INLINE
%token INT
%token LONG
%token RETURN
%token SHORT
%token SIGNED
%token SIZEOF
%token STATIC
%token STRUCT
%token SWITCH
%token TYPEDEF
%token UNION
%token ENUM
%token EXTERN
%token REGISTER
%token RESTRICT
%token UNSIGNED
%token VOID
%token CONST
%token CONTINUE
%token DEFAULT
%token DO
%token DOUBLE
%token ELSE
%token FLOAT
%token FOR
%token GOTO
%token VOLATILE
%token WHILE
%token _BOOL
%token _COMPLEX
%token _IMAGINARY 
%token <char_value> CHAR_CONST				
%token <char_value> STRING_LIT 		
%token SQ_BRAC_OPEN SQ_BRAC_CLOSE
%token ROUND_BRAC_OPEN ROUND_BRAC_CLOSE
%token CURLY_BRAC_OPEN CURLY_BRAC_CLOSE			
%token DOT IMPLIES INC DEC BITWISE_AND MULTIPLY ADD SUBTRACT BITWISE_NOT EXCLAIM DIVISION MOD LEFT_SHIFT RIGHT_SHIFT BIT_SL BIT_SR 
%token LESS_OR_EQUAL GREATER_OR_EQUAL EQUAL NEQUAL BITWISE_XOR BITWISE_OR AND OR
%token QUESTION COLON SEMICOLON DOTS ASSIGN 
%token STAR_EQUAL DIVISION_EQUAL MOD_EQUAL ADD_EQUAL SUBTRACT_EQUAL SL_EQUAL SR_EQUAL BITWISE_AND_EQUAL BITWISE_XOR_EQUAL BITWISE_OR_EQUAL 
%token COMMA HASH 		
%token <symp> IDENTIFIER 		 		
%token <intVal> INTEGER_CONST			
%token <char_value> FLOATING_CONST

%start translationUnit

%type <unary> unaryOp

%type <numParams> argExpList argExpListOpt


// -------------------- Expressions ---------------------------//

%type <expr>
	expression
	primaryExp 
	multExp
	addExp
	shiftExp
	relationalExp
	equalityExp
	andExp
	xorExp
	inclusiveOrExp
	logicalAndExp
	logicalOrExp
	conditionalExp
	assignmentExp
	expressionStatement

// -------------------- Statement types ---------------------------//

%type <stat>  statement
	compoundStatement
	selectionStatement
	iterationStatement
	labeledStatement 
	jumpStatement
	blockItem
	blockItemList
	blockItemListOpt

// -------------------- Symbol Type ---------------------------//

%type <symType> pointer

// -------------------- Symbols ---------------------------//

%type <symp> initializer
%type <symp> directDeclarator initDeclarator declarator

// -------------------- arr1s ---------------------------//

%type <A> postfixExp
	unaryExp
	castExp

// -------------------- Auxiliary Non Terminals ---------------------------//

%type <instrNo> M
%type <stat> N



%%

M
	: %empty 
	{
		$$=nextinstr();
	}   
	;

N
	: %empty
	{
		$$ =new Statement();            
		$$->nextlist=makelist(nextinstr());
		emit("goto","");
	}
	;

primaryExp
	: IDENTIFIER                     					  
	{ 
		
		$$=new Expression();                      // Creates new expression and stores pointer to ST entry in the location			
				 
		$$->loc=$1;
		
		$$->type="not-boolean";
		
		
	}
	| INTEGER_CONST          					    
	{ 
		   
		$$=new Expression();	
		
		string p=IntToString($1);
		
		$$->loc=gentemp(new symboltype("int"),p);
		
		emit("=",$$->loc->name,p);
		
		
	}
	| FLOATING_CONST        	  			
	{    
		
		$$=new Expression();
		
		$$->loc=gentemp(new symboltype("float"),$1);
		
		emit("=",$$->loc->name,string($1));
		
		
	}
	| CHAR_CONST       	  					  
	{    
		
		$$=new Expression();
		
		$$->loc=gentemp(new symboltype("char"),$1);
		
		emit("=",$$->loc->name,string($1));
		
		
	}
	| STRING_LIT        					  
	{   
		
		$$=new Expression();
		
		$$->loc=gentemp(new symboltype("ptr"),$1);
		
		$$->loc->type->arrtype=new symboltype("char");
		
		
	}
	| ROUND_BRAC_OPEN expression ROUND_BRAC_CLOSE        
	{ $$=$2;}
	;


postfixExp
	: primaryExp      				       // Creates new Array and stores the location of primary expression in it
	{ 
		
		$$=new Array();
		
		$$->Array=$1->loc;	
		
		$$->type=$1->loc->type;	
		
		$$->loc=$$->Array;
		
		
	}
	| postfixExp SQ_BRAC_OPEN expression SQ_BRAC_CLOSE 
	{ 	
		
		$$=new Array();
		
		$$->type=$1->type->arrtype;				// type=type of element	
					
		$$->Array=$1->Array;						// copy the base
		
		$$->loc=gentemp(new symboltype("int"));		// store computed address
		
		$$->atype="arr";						//atype is arr.
		
		if($1->atype=="arr") 
		{			// if already arr, multiply the size of the SUBTRACT-type of Array with the expression value and add
			
			sym* t=gentemp(new symboltype("int"));
			
			int p=computeSize($$->type);
			
			string str=IntToString(p);
			
			emit("*",t->name,$3->loc->name,str);
				
			
			emit("+",$$->loc->name,$1->loc->name,t->name);
			
			
		}
		else 
		{                        //if a 1D Array, simply calculate size
			int p=computeSize($$->type);
			
			string str=IntToString(p);
			
			emit("*",$$->loc->name,$3->loc->name,str);
			
			
		}
	}
	| postfixExp ROUND_BRAC_OPEN argExpListOpt ROUND_BRAC_CLOSE       
	//call the function with number of parameters from argExpListOpt
	{
		
		$$=new Array();	
		
		$$->Array=gentemp($1->type);
		
		string str=IntToString($3);
		
		emit("call",$$->Array->name,$1->Array->name,str);
		
		
	}
	| postfixExp DOT IDENTIFIER {  }
	| postfixExp IMPLIES IDENTIFIER  {  }
	| postfixExp INC               //generate new temporary, EQUALuate it to old one and then add 1
	{ 
		
		$$=new Array();
		
		$$->Array=gentemp($1->Array->type);
			
		emit("=",$$->Array->name,$1->Array->name);
		
		
		emit("+",$1->Array->name,$1->Array->name,"1");
		
		
	}
	| postfixExp DEC                //generate new temporary, EQUALuate it to old one and then SUBTRACTtract 1
	{
		
		$$=new Array();	
		
		$$->Array=gentemp($1->Array->type);
		
		emit("=",$$->Array->name,$1->Array->name);
		
		
		emit("-",$1->Array->name,$1->Array->name,"1");
		
		
	}
	| ROUND_BRAC_OPEN typeName ROUND_BRAC_CLOSE CURLY_BRAC_OPEN initializerList CURLY_BRAC_CLOSE {  }
	| ROUND_BRAC_OPEN typeName ROUND_BRAC_CLOSE CURLY_BRAC_OPEN initializerList COMMA CURLY_BRAC_CLOSE {  }
	;

argExpListOpt
	: argExpList    { $$=$1; }   //EQUALuate $$ and $1
	| %empty { $$=0; }            //No arguments
	;

argExpList
	: assignmentExp    
	{
		
		$$=1;                                      //one argument and emit param
		
		emit("param",$1->loc->name);	
		
		
	}
	| argExpList COMMA assignmentExp     
	{
		
		$$=$1+1;                                  //one more argument and emit param	
			 
		emit("param",$3->loc->name);
		
		
	}
	;

unaryExp
	: postfixExp   { $$=$1; } 					  //simply EQUALuate
	| INC unaryExp                           //simply add 1
	{  	
		
		emit("+",$2->Array->name,$2->Array->name,"1");
		
		
		$$=$2;
		
	}
	| DEC unaryExp                           //simply SUBTRACTtract 1
	{
		
		emit("-",$2->Array->name,$2->Array->name,"1");
		
		
		$$=$2;
		
	}
	| unaryOp castExp                       //if it is of this type, where unary operator is involved
	{			
				  	
		$$=new Array();
		
		switch($1)
		{	  
			case '&':                                       //address of something, then generate a pointer temporary and emit the quad
				
				$$->Array=gentemp((new symboltype("ptr")));
				
				$$->Array->type->arrtype=$2->Array->type; 
				
				emit("=&",$$->Array->name,$2->Array->name);
				
				
				break;
			case '*':                          //value of something, then generate a temporary of the corresponding type and emit the quad	
				$$->atype="ptr";
				
				$$->loc=gentemp($2->Array->type->arrtype);
				
				$$->Array=$2->Array;
				
				emit("=*",$$->loc->name,$2->Array->name);
				
				
				break;
			case '+':  
				$$=$2;
				
				break;                    //unary plus, do nothing
			case '-':				   //unary minus, generate new temporary of the same base type and make it negative of current one
				$$->Array=gentemp(new symboltype($2->Array->type->type));
				
				emit("uminus",$$->Array->name,$2->Array->name);
				
				
				break;
			case '~':                   //bitwise not, generate new temporary of the same base type and make it negative of current one
				$$->Array=gentemp(new symboltype($2->Array->type->type));
				
				emit("~",$$->Array->name,$2->Array->name);
				
				
				break;
			case '!':				//logical not, generate new temporary of the same base type and make it negative of current one
				$$->Array=gentemp(new symboltype($2->Array->type->type));
				
				emit("!",$$->Array->name,$2->Array->name);
				
				
				break;
		}
	}
	| SIZEOF unaryExp  {  }
	| SIZEOF ROUND_BRAC_OPEN typeName ROUND_BRAC_CLOSE   {  }
	;

unaryOp
	: BITWISE_AND 	
	{ 
		$$='&'; 
		
		
	}        //simply EQUALuate to the corresponding operator
	| MULTIPLY		
	{
		$$='*'; 
		
		
	}
	| ADD  		
	{ 
		$$='+'; 
		
		
	}
	| SUBTRACT  		
	{ 
		$$='-'; 
		
		
	}
	| BITWISE_NOT  
	{ 
		$$='~'; 
		
		
	} 
	| EXCLAIM  
	{
		$$='!'; 
		
		
	}
	;

castExp
	: unaryExp  { $$=$1; }                       //unary expression, simply EQUALuate
	| ROUND_BRAC_OPEN typeName ROUND_BRAC_CLOSE castExp          //if cast type is given
	{ 
		
		$$=new Array();	
		
		$$->Array=convertType($4->Array,var_type);             //generate a new symbol of the given type
		
		
	}
	;

multExp
	: castExp  
	{
		
		$$ = new Expression();             //generate new expression	
								    
		if($1->atype=="arr") 			   //if it is of type arr
		{
			$$->loc = gentemp($1->loc->type);	
			
			emit("=[]", $$->loc->name, $1->Array->name, $1->loc->name);     //emit with Array right
			
			
		}
		else if($1->atype=="ptr")         //if it is of type ptr
		{ 
			$$->loc = $1->loc;        //EQUALuate the locs
			
			
		}
		else
		{
			$$->loc = $1->Array;
			
			
		}
	}
	| multExp MULTIPLY castExp           //if we have multiplication
	{ 
		
		if(!compareSymbolType($1->loc, $3->Array))         
			cout<<"Type Error in Program"<< endl;	// error
		else 								 //if types are compatible, generate new temporary and EQUALuate to the product
		{
			$$ = new Expression();	
			
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			
			emit("*", $$->loc->name, $1->loc->name, $3->Array->name);
			
			
		}
	}
	| multExp DIVISION castExp      //if we have DIVISIONision
	{
		
		if(!compareSymbolType($1->loc, $3->Array))
			cout << "Type Error in Program"<< endl;
		else    //if types are compatible, generate new temporary and EQUALuate to the quotient
		{
			$$ = new Expression();
			
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			
			emit("/", $$->loc->name, $1->loc->name, $3->Array->name);
				
									
		}
	}
	| multExp MOD castExp    //if we have mod
	{
		
		if(!compareSymbolType($1->loc, $3->Array))
			cout << "Type Error in Program"<< endl;		
		else 		 //if types are compatible, generate new temporary and EQUALuate to the quotient
		{
			$$ = new Expression();
			
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			
			emit("%", $$->loc->name, $1->loc->name, $3->Array->name);	
				
				
		}
	}
	;

addExp
	: multExp   { $$=$1; }            //simply EQUALuate
	| addExp ADD multExp      //if we have addition
	{
		
		if(!compareSymbolType($1->loc, $3->loc))
			cout << "Type Error in Program"<< endl;
		else    	//if types are compatible, generate new temporary and EQUALuate to the sum
		{
			$$ = new Expression();	
			
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			
			emit("+", $$->loc->name, $1->loc->name, $3->loc->name);
			
			
		}
	}
	| addExp SUBTRACT multExp    //if we have SUBTRACTtraction
	{
		
		if(!compareSymbolType($1->loc, $3->loc))
			cout << "Type Error in Program"<< endl;		
		else        //if types are compatible, generate new temporary and EQUALuate to the difference
		{	
			$$ = new Expression();	
			
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			
			emit("-", $$->loc->name, $1->loc->name, $3->loc->name);
			
			
		}
	}
;

shiftExp
	: addExp   { $$=$1; }              //simply EQUALuate
	| shiftExp LEFT_SHIFT addExp   
	{ 
		
		if(!($3->loc->type->type == "int"))
			cout << "Type Error in Program"<< endl; 		
		else            //if base type is int, generate new temporary and EQUALuate to the shifted value
		{		
			$$ = new Expression();	
			
			$$->loc = gentemp(new symboltype("int"));
			
			emit("<<", $$->loc->name, $1->loc->name, $3->loc->name);
			
			
		}
	}
	| shiftExp RIGHT_SHIFT addExp
	{ 	
		if(!($3->loc->type->type == "int"))
		{
			
			cout << "Type Error in Program"<< endl; 		
		}
		else  		//if base type is int, generate new temporary and EQUALuate to the shifted value
		{		
			
			$$ = new Expression();	
			
			$$->loc = gentemp(new symboltype("int"));
			
			emit(">>", $$->loc->name, $1->loc->name, $3->loc->name);
			
			
		}
	}
	;

relationalExp
	: shiftExp   { $$=$1; }              //simply EQUALuate
	| relationalExp BIT_SL shiftExp
	{
		if(!compareSymbolType($1->loc, $3->loc)) 
		{
			
			cout << "Type Error in Program"<< endl;
		}
		else 
		{      //check compatible types		
										
			$$ = new Expression();
			
			$$->type = "bool";                         //new type is boolean
					
			$$->truelist = makelist(nextinstr());     //makelist for truelist and falselist
			
			$$->falselist = makelist(nextinstr()+1);
			
			emit("<", "", $1->loc->name, $3->loc->name);     //emit statement if a<b goto .. 
			
			
			emit("goto", "");	//emit statement goto ..
			
			
		}
	}
	| relationalExp BIT_SR shiftExp          //similar to above, check compatible types,make new lists and emit
	{
		if(!compareSymbolType($1->loc, $3->loc)) 
		{
			
			cout << "Type Error in Program"<< endl;
		}
		else 
		{
			
			$$ = new Expression();	
			
			$$->type = "bool";
			
			$$->truelist = makelist(nextinstr());
			
			$$->falselist = makelist(nextinstr()+1);
			
			emit(">", "", $1->loc->name, $3->loc->name);
			
			
			emit("goto", "");
			
			
		}	
	}
	| relationalExp LESS_OR_EQUAL shiftExp			 //similar to above, check compatible types,make new lists and emit
	{
		if(!compareSymbolType($1->loc, $3->loc)) 
		{
			
			cout << "Type Error in Program"<< endl;
		}
		else 
		{		
			
			$$ = new Expression();		
			
			$$->type = "bool";
			
			$$->truelist = makelist(nextinstr());
			
			$$->falselist = makelist(nextinstr()+1);
			
			emit("<=", "", $1->loc->name, $3->loc->name);
			
			
			emit("goto", "");
			
			
		}		
	}
	| relationalExp GREATER_OR_EQUAL shiftExp 			 //similar to above, check compatible types,make new lists and emit
	{
		if(!compareSymbolType($1->loc, $3->loc))
		{
			 
			cout << "Type Error in Program"<< endl;
		}
		else 
		{
			
			$$ = new Expression();
			
			$$->type = "bool";
			
			$$->truelist = makelist(nextinstr());
			
			$$->falselist = makelist(nextinstr()+1);
			
			emit(">=", "", $1->loc->name, $3->loc->name);
			
			
			emit("goto", "");
			
			
		}
	}
	;

equalityExp
	: relationalExp  { $$=$1; }						//simply EQUALuate
	| equalityExp EQUAL relationalExp 
	{
		if(!compareSymbolType($1->loc, $3->loc))                //check compatible types
		{
			
			cout << "Type Error in Program"<< endl;
		}
		else 
		{
			
			BooltoInt($1);                  //convert bool to int
				
			BooltoInt($3);
			
			$$ = new Expression();
			
			$$->type = "bool";
			
			$$->truelist = makelist(nextinstr());            //make lists for new expression
			
			$$->falselist = makelist(nextinstr()+1); 
			
			emit("==", "", $1->loc->name, $3->loc->name);      //emit if a==b goto ..
			
			
			emit("goto", "");				//emit goto ..
			
			
		}
		
	}

	| equalityExp NEQUAL relationalExp   //Similar to above, check compatibility, convert bool to int, make list and emit
	{
		if(!compareSymbolType($1->loc, $3->loc)) 
		{
			
			cout << "Type Error in Program"<< endl;
		}
		else 
		{			
			
			BooltoInt($1);	
			
			BooltoInt($3);
			
			$$ = new Expression();                 //result is boolean
			
			$$->type = "bool";
			
			$$->truelist = makelist(nextinstr());
			
			$$->falselist = makelist(nextinstr()+1);
			
			emit("!=", "", $1->loc->name, $3->loc->name);
			
			
			emit("goto", "");
			
			
		}
	}
	;

andExp
	: equalityExp  { $$=$1; }						//simply EQUALuate
	| andExp BITWISE_AND equalityExp 
	{
		if(!compareSymbolType($1->loc, $3->loc))         //check compatible types 
		{
					
			cout << "Type Error in Program"<< endl;
		}
		else 
		{
			              
			BooltoInt($1);                             //convert bool to int
			
			BooltoInt($3);
			
			$$ = new Expression();
			
			$$->type = "not-boolean";                   //result is not boolean
			
			$$->loc = gentemp(new symboltype("int"));
			
			emit("&", $$->loc->name, $1->loc->name, $3->loc->name);               //emit the quad
			
			
		}
	}
	;

xorExp
	: andExp  { $$=$1; }				//simply EQUALuate
	| xorExp BITWISE_XOR andExp    
	{
		if(!compareSymbolType($1->loc, $3->loc))    //same as andExp: check compatible types, make non-boolean expression and convert bool to int and emit
		{
			
			cout << "Type Error in Program"<< endl;
		}
		else 
		{
			
			BooltoInt($1);	
			
			BooltoInt($3);
			
			$$ = new Expression();
			
			$$->type = "not-boolean";
			
			$$->loc = gentemp(new symboltype("int"));
			
			emit("^", $$->loc->name, $1->loc->name, $3->loc->name);
			
			
		}
	}
	;

inclusiveOrExp
	: xorExp { $$=$1; }			//simply EQUALuate
	| inclusiveOrExp BITWISE_OR xorExp          
	{ 
		if(!compareSymbolType($1->loc, $3->loc))   //same as andExp: check compatible types, make non-boolean expression and convert bool to int and emit
		{
			
			cout << "Type Error in Program"<< endl;
		}
		else 
		{
			
			BooltoInt($1);		
			
			BooltoInt($3);
			
			$$ = new Expression();
			
			$$->type = "not-boolean";
			
			$$->loc = gentemp(new symboltype("int"));
			
			emit("|", $$->loc->name, $1->loc->name, $3->loc->name);
			
			
		} 
	}
	;

logicalAndExp
	: inclusiveOrExp  { $$=$1; }				//simply EQUALuate
	| logicalAndExp N AND M inclusiveOrExp      //backpatching involved here
	{ 
		
		InttoBool($5);         //convert inclusiveOrExp int to bool
		
		backpatch($2->nextlist, nextinstr());        //$2->nextlist goes to next instruction
		
		InttoBool($1);                  //convert logicalAndExp to bool
		
		$$ = new Expression();     //make new boolean expression 
		
		$$->type = "bool";
		
		backpatch($1->truelist, $4);        //if $1 is true, we move to $5
		
		$$->truelist = $5->truelist;        //if $5 is also true, we get truelist for $$
		
		$$->falselist = merge($1->falselist, $5->falselist);    //merge their falselists
		
		
	}
	;

logicalOrExp
	: logicalAndExp   { $$=$1; }				//simply EQUALuate
	| logicalOrExp N OR M logicalAndExp        //backpatching involved here
	{ 
		
		InttoBool($5);			 //convert logicalAndExp int to bool
		
		backpatch($2->nextlist, nextinstr());	//$2->nextlist goes to next instruction
		
		InttoBool($1);			//convert logicalOrExp to bool
		
		$$ = new Expression();			//make new boolean expression
		
		$$->type = "bool";
		
		backpatch($1->falselist, $4);		//if $1 is true, we move to $5
		
		$$->truelist = merge($1->truelist, $5->truelist);		//merge their truelists
		
		$$->falselist = $5->falselist;		 	//if $5 is also false, we get falselist for $$
		
		
	}
	;

conditionalExp 
	: logicalOrExp {$$=$1;}       //simply EQUALuate
	| logicalOrExp N QUESTION M expression N COLON M conditionalExp 
	{
		
		//normal conversion method to get conditional expressions
		$$->loc = gentemp($5->loc->type);       //generate temporary for expression
		
		$$->loc->update($5->loc->type);
		
		emit("=", $$->loc->name, $9->loc->name);      //make it EQUALual to sconditionalExp
		
		
		list<int> l = makelist(nextinstr());        //makelist next instruction
		emit("goto", "");              //prevent fallthrough
		
		
		backpatch($6->nextlist, nextinstr());        //after N, go to next instruction
		
		emit("=", $$->loc->name, $5->loc->name);
		
		
		list<int> m = makelist(nextinstr());         //makelist next instruction
		
		l = merge(l, m);						//merge the two lists
		
		emit("goto", "");						//prevent fallthrough
		
		
		backpatch($2->nextlist, nextinstr());   //backpatching
		
		InttoBool($1);                   //convert expression to boolean
		
		backpatch($1->truelist, $4);           //$1 true goes to expression
		
		backpatch($1->falselist, $8);          //$1 false goes to conditionalExp
		
		backpatch(l, nextinstr());
		
		
	}
	;

assignmentExp
	: conditionalExp {$$=$1;}         //simply EQUALuate
	| unaryExp assignmentOperator assignmentExp 
	 {
		if($1->atype=="arr")       //if type is arr, simply check if we need to convert and emit
		{
			
			$3->loc = convertType($3->loc, $1->type->type);
			
			emit("[]=", $1->Array->name, $1->loc->name, $3->loc->name);		
			
			
		}
		else if($1->atype=="ptr")     //if type is ptr, simply emit
		{
			
			emit("*=", $1->Array->name, $3->loc->name);		
			
			
		}
		else                              //otherwise assignment
		{
			
			$3->loc = convertType($3->loc, $1->Array->type->type);
			emit("=", $1->Array->name, $3->loc->name);
			
			
		}
		
		$$ = $3;
		
		
	}
	;


assignmentOperator
	: ASSIGN   				{}
	| STAR_EQUAL    		{}
	| DIVISION_EQUAL    	{}
	| MOD_EQUAL    			{}
	| ADD_EQUAL    			{}
	| SUBTRACT_EQUAL    	{}
	| SL_EQUAL    			{}
	| SR_EQUAL    			{}
	| BITWISE_AND_EQUAL    	{}
	| BITWISE_XOR_EQUAL    	{}
	| BITWISE_OR_EQUAL    	{}
	;

expression
	: assignmentExp {  $$=$1;  }
	| expression COMMA assignmentExp {   }
	;

constantExpression
	: conditionalExp {   }
	;

decl
	: decalarationSpecifiers initDeclaratorList SEMICOLON {	}
	| decalarationSpecifiers SEMICOLON {  	}
	;


decalarationSpecifiers
	: storageClassSpecifier decalarationSpecifiers {	}
	| storageClassSpecifier {	}
	| typeSpecifier decalarationSpecifiers {	}
	| typeSpecifier {	}
	| typeQualifier decalarationSpecifiers {	}
	| typeQualifier {	}
	| functionSpecifier decalarationSpecifiers {	}
	| functionSpecifier {	}
	;

initDeclaratorList
	: initDeclarator {	}
	| initDeclaratorList COMMA initDeclarator {	}
	;

initDeclarator
	: declarator {$$=$1;}
	| declarator ASSIGN initializer 
	{
		
		if($3->val!="") $1->val=$3->val;        //get the initial value and  emit it
		emit("=", $1->name, $3->name);
		
		
	}
	;

storageClassSpecifier
	: EXTERN  { }
	| STATIC  { }
	| AUTO   { }
	| REGISTER   { }
	;

typeSpecifier
	: VOID   { var_type="void"; }           //store the latest type in var_type
	| CHAR   { var_type="char"; }
	| SHORT  { }
	| INT   { var_type="int"; }
	| LONG   {  }
	| FLOAT   { var_type="float"; }
	| DOUBLE   { }
	| SIGNED   {  }
	| UNSIGNED   { }
	| _BOOL   {  }
	| _COMPLEX   {  }
	| _IMAGINARY   {  }
	| enumSpecifier   {  }
	;

specifierQualifierList
	: typeSpecifier specifierQualifierList_opt   {  }
	| typeQualifier specifierQualifierList_opt  {  }
	;

specifierQualifierList_opt
	: %empty {  }
	| specifierQualifierList  {  }
	;

enumSpecifier
	: ENUM identifierOpt CURLY_BRAC_OPEN enumeratorList CURLY_BRAC_CLOSE   {  }
	| ENUM identifierOpt CURLY_BRAC_OPEN enumeratorList COMMA CURLY_BRAC_CLOSE   {  }
	| ENUM IDENTIFIER {  }
	;

identifierOpt
	: %empty  {  }
	| IDENTIFIER   {  }
	;

typeQualifier
	: CONST   {  }
	| RESTRICT   {  }
	| VOLATILE   {  }
	;

enumeratorList
	: enumerator   {  }
	| enumeratorList COMMA enumerator   {  }
	;			  						    							  
enumerator
	: IDENTIFIER   {  }
	| IDENTIFIER ASSIGN constantExpression   {  }
	;

functionSpecifier
	: INLINE   {  }
	;

declarator
	: pointer directDeclarator 
	{
		
		symboltype *t = $1;
		
		while(t->arrtype!=NULL) t = t->arrtype;           //for multidimensional arr1s, move in depth till you get the base type
		
		t->arrtype = $2->type;                //add the base type 
		
		$$ = $2->update($1);                  //update
		
		
	}
	| directDeclarator {   }
	;

directDeclarator
	: IDENTIFIER                 //if ID, simply add a new variable of var_type
	{
		
		$$ = $1->update(new symboltype(var_type));
		
		currSymbolPtr = $$;
		
		
		
	}
	| ROUND_BRAC_OPEN declarator ROUND_BRAC_CLOSE {$$=$2;}        //simply EQUALuate
	| directDeclarator SQ_BRAC_OPEN typeQualifierList assignmentExp SQ_BRAC_CLOSE {	}
	| directDeclarator SQ_BRAC_OPEN typeQualifierList SQ_BRAC_CLOSE {	}
	| directDeclarator SQ_BRAC_OPEN assignmentExp SQ_BRAC_CLOSE 
	{
		
		symboltype *t = $1 -> type;
		
		symboltype *prev = NULL;
		
		while(t->type == "arr") 
		{
			prev = t;	
			t = t->arrtype;      //keep moving recursively to get basetype
			
		}
		if(prev==NULL) 
		{
			
			int temp = atoi($3->loc->val.c_str());      //get initial value
			
			symboltype* s = new symboltype("arr", $1->type, temp);        //create new symbol with that initial value
			
			$$ = $1->update(s);   //update the symbol table
			
			
		}
		else 
		{
			
			prev->arrtype =  new symboltype("arr", t, atoi($3->loc->val.c_str()));     //similar arguments as above		
			
			$$ = $1->update($1->type);
			
			
		}
	}
	| directDeclarator SQ_BRAC_OPEN SQ_BRAC_CLOSE 
	{
		
		symboltype *t = $1 -> type;
		
		symboltype *prev = NULL;
		
		while(t->type == "arr") 
		{
			prev = t;	
			t = t->arrtype;         //keep moving recursively to base type
			
		}
		if(prev==NULL) 
		{
			
			symboltype* s = new symboltype("arr", $1->type, 0);    //no initial values, simply keep 0
			
			$$ = $1->update(s);
			
				
		}
		else 
		{
			
			prev->arrtype =  new symboltype("arr", t, 0);
			
			$$ = $1->update($1->type);
			
			
		}
	}
	| directDeclarator SQ_BRAC_OPEN STATIC typeQualifierList assignmentExp SQ_BRAC_CLOSE {	}
	| directDeclarator SQ_BRAC_OPEN STATIC assignmentExp SQ_BRAC_CLOSE {	}
	| directDeclarator SQ_BRAC_OPEN typeQualifierList MULTIPLY SQ_BRAC_CLOSE {	}
	| directDeclarator SQ_BRAC_OPEN MULTIPLY SQ_BRAC_CLOSE {	}
	| directDeclarator ROUND_BRAC_OPEN changetable paramsTypeList ROUND_BRAC_CLOSE 
	{
		
		ST->name = $1->name;
		
		if($1->type->type !="void") 
		{
			sym *s = ST->lookup("return");         //lookup for return value	
			s->update($1->type);
			
			
		}
		$1->nested=ST;       
			
		ST->parent = globalST;
		
		changeTable(globalST);				// Come back to globalsymbol table
		
		currSymbolPtr = $$;
		
		
	}
	| directDeclarator ROUND_BRAC_OPEN identifierList ROUND_BRAC_CLOSE {	}
	| directDeclarator ROUND_BRAC_OPEN changetable ROUND_BRAC_CLOSE 
	{        //similar as above
		
		ST->name = $1->name;
		
		if($1->type->type !="void") 
		{
			sym *s = ST->lookup("return");
			s->update($1->type);
			
						
		}
		$1->nested=ST;
		
		ST->parent = globalST;
		
		changeTable(globalST);				// Come back to globalsymbol table
		
		currSymbolPtr = $$;
		
		
	}
	;

changetable
	: %empty 
	{ 														// Used for changing to symbol table for a function
		if(currSymbolPtr->nested==NULL) 
		{
			
			changeTable(new symboltable(""));	// Function symbol table doesn't already exist
			
		}
		else 
		{
			
			changeTable(currSymbolPtr ->nested);						// Function symbol table already exists
			
			emit("label", ST->name);
			
			
		}
	}
	;

typeQualifierListOpt
	: %empty   {  }
	| typeQualifierList      {  }
	;

pointer
	: MULTIPLY typeQualifierListOpt   
	{ 
		$$ = new symboltype("ptr");
		
		  
	}          //create new pointer
	| MULTIPLY typeQualifierListOpt pointer 
	{ 
		$$ = new symboltype("ptr",$3);
		
		 
	}
	;

typeQualifierList
	: typeQualifier   {  }
	| typeQualifierList typeQualifier   {  }
	;

paramsTypeList
	: paramsList   {  }
	| paramsList COMMA DOTS   {  }
	;

paramsList
	: paramsDeclaration   {  }
	| paramsList COMMA paramsDeclaration    {  }
	;

paramsDeclaration
	: decalarationSpecifiers declarator   {  }
	| decalarationSpecifiers    {  }
	;

identifierList
	: IDENTIFIER	{  }		  
	| identifierList COMMA IDENTIFIER   {  }
	;

typeName
	: specifierQualifierList   {  }
	;

initializer
	: assignmentExp   { $$=$1->loc; }    //assignment
	| CURLY_BRAC_OPEN initializerList CURLY_BRAC_CLOSE  {  }
	| CURLY_BRAC_OPEN initializerList COMMA CURLY_BRAC_CLOSE  {  }
	;

initializerList
	: designationOpt initializer  {  }
	| initializerList COMMA designationOpt initializer   {  }
	;

designationOpt
	: %empty   {  }
	| designation   {  }
	;

designation
	: designatorList ASSIGN   {  }
	;

designatorList
	: designator    {  }
	| designatorList designator   {  }
	;

designator
	: SQ_BRAC_OPEN constantExpression SQ_BRAC_CLOSE   {  }
	| DOT IDENTIFIER {  }
	;

// -------------------- Statements ---------------------------//

statement
	: labeledStatement   {  }
	| compoundStatement   { $$=$1; }
	| expressionStatement   
	{ 
		$$=new Statement();              //create new statement with same nextlist
		$$->nextlist=$1->nextlist; 
	}
	| selectionStatement   { $$=$1; }
	| iterationStatement   { $$=$1; }
	| jumpStatement   { $$=$1; }
	;

labeledStatement
	: IDENTIFIER COLON statement   {  }
	| CASE constantExpression COLON statement   {  }
	| DEFAULT COLON statement   {  }
	;

compoundStatement
	: CURLY_BRAC_OPEN blockItemListOpt CURLY_BRAC_CLOSE   { $$=$2; }  //EQUALuate
	;

blockItemListOpt
	: %empty  { $$=new Statement(); }      //create new statement
	| blockItemList   { $$=$1; }        //simply EQUALuate
	;

blockItemList
	: blockItem   { $$=$1; }			//simply EQUALuate
	| blockItemList M blockItem    
	{ 
		$$=$3;
		backpatch($1->nextlist,$2);     //after $1, move to blockItem via $2
	}
	;

blockItem
	: decl   { $$=new Statement(); }          //new statement
	| statement   { $$=$1; }				//simply EQUALuate
	;

expressionStatement
	: expression SEMICOLON {$$=$1;}			//simply EQUALuate
	| SEMICOLON {$$ = new Expression();}      //new  expression
	;

selectionStatement
	: IF ROUND_BRAC_OPEN expression N ROUND_BRAC_CLOSE M statement N %prec "then"      // if statement without else
	{
		
		backpatch($4->nextlist, nextinstr());        //nextlist of N goes to nextinstr
		
		InttoBool($3);         //convert expression to bool
		
		$$ = new Statement();        //make new statement
		
		backpatch($3->truelist, $6);        //is expression is true, go to M i.e just before statement body
		
		list<int> temp = merge($3->falselist, $7->nextlist);   //merge falselist of expression, nextlist of statement and second N
		
		$$->nextlist = merge($8->nextlist, temp);
		
		
	}
	| IF ROUND_BRAC_OPEN expression N ROUND_BRAC_CLOSE M statement N ELSE M statement   //if statement with else
	{
		
		backpatch($4->nextlist, nextinstr());		//nextlist of N goes to nextinstr
		
		InttoBool($3);        //convert expression to bool
		
		$$ = new Statement();       //make new statement
		
		backpatch($3->truelist, $6);    //when expression is true, go to M1 else go to M2
		
		backpatch($3->falselist, $10);
		
		list<int> temp = merge($7->nextlist, $8->nextlist);       //merge the nextlists of the statements and second N
		
		$$->nextlist = merge($11->nextlist,temp);	
		
			
	}
	| SWITCH ROUND_BRAC_OPEN expression ROUND_BRAC_CLOSE statement {	}       //not to be modelled
	;

iterationStatement	
	: WHILE M ROUND_BRAC_OPEN expression ROUND_BRAC_CLOSE M statement      //while statement
	{
		
		$$ = new Statement();    //create statement
		
		InttoBool($4);     //convert expression to bool
		
		backpatch($7->nextlist, $2);	// M1 to go back to expression again
		
		backpatch($4->truelist, $6);	// M2 to go to statement if the expression is true
		
		$$->nextlist = $4->falselist;   //when expression is false, move out of loop
		
		// Emit to prevent fallthrough
		string str=IntToString($2);			
		
		emit("goto", str);
		
		
			
	}
	| DO M statement M WHILE ROUND_BRAC_OPEN expression ROUND_BRAC_CLOSE SEMICOLON      //do statement
	{
		
		$$ = new Statement();     //create statement
		
		InttoBool($7);      //convert to bool
		
		backpatch($7->truelist, $2);						// M1 to go back to statement if expression is true
		
		backpatch($3->nextlist, $4);						// M2 to go to check expression if statement is complete
		
		$$->nextlist = $7->falselist;                       //move out if statement is false
		
				
	}
	| FOR ROUND_BRAC_OPEN expressionStatement M expressionStatement ROUND_BRAC_CLOSE M statement      //for loop
	{
		
		$$ = new Statement();   //create new statement
		
		InttoBool($5);    //convert check expression to boolean
		
		backpatch($5->truelist,$7);        //if expression is true, go to M2
		
		backpatch($8->nextlist,$4);        //after statement, go back to M1
		
		string str=IntToString($4);
		
		emit("goto", str);                 //prevent fallthrough
		
		
		$$->nextlist = $5->falselist;      //move out if statement is false
		
		
	}
	| FOR ROUND_BRAC_OPEN expressionStatement M expressionStatement M expression N ROUND_BRAC_CLOSE M statement
	{
		
		$$ = new Statement();		 //create new statement
		
		InttoBool($5);  //convert check expression to boolean
		
		backpatch($5->truelist, $10);	//if expression is true, go to M2
		
		backpatch($8->nextlist, $4);	//after N, go back to M1
		
		backpatch($11->nextlist, $6);	//statement go back to expression
		
		string str=IntToString($6);
		
		emit("goto", str);				//prevent fallthrough
		
		
		$$->nextlist = $5->falselist;	//move out if statement is false	
		
			
	}
	;

jumpStatement
	: GOTO IDENTIFIER SEMICOLON { $$ = new Statement(); }          
	| CONTINUE SEMICOLON { $$ = new Statement(); }			  
	| BREAK SEMICOLON { $$ = new Statement(); }				
	| RETURN expression SEMICOLON               
	{
		
		$$ = new Statement();
		
		emit("return",$2->loc->name);               //emit return with the name of the return value
		
		
		
	}
	| RETURN SEMICOLON 
	{
		
		$$ = new Statement();
		
		emit("return","");                         //simply emit return
		
		
	}
	;

// -------------------- External Definitions ---------------------------//

translationUnit
	: externalDecl { }
	| translationUnit externalDecl { } 
	;

externalDecl
	: funcDef {  }
	| decl   {  }
	;

funcDef
	: decalarationSpecifiers declarator declListOpt changetable compoundStatement  
	{
		
		int next_instr=0;	 
		
		ST->parent=globalST;
		
		changeTable(globalST);                   
		
		
	};

declList : decl   {  } | declList decl    {  };				   										  				   

declListOpt : %empty {  } | declList   {  } ;

%%

void yyerror(string s) {        //print syntax error
    cout << "SYNTAX ERROR : " << s << endl;
}
