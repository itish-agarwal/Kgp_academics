/* Compiler lab assignment 5
   Group number 47
   Itish Agarwal - 18CS30021
   Aditya Singh  - 18CS30005 
*/

#ifndef _TRANSLATE_H
#define _TRANSLATE_H

#include <bits/stdc++.h>
extern  char* yytext;
extern  int yyparse();

using namespace std;

//---------------- Declaring the classes ---------------------//

class sym;						// An entry in the symbol table

class symboltype;				// Type of a symbol in symbol table

class symboltable;					// Stands for symbol table

class quad;						// Single entry in the quad Array

class quadArray;				// Array of quads

// Symbols : Element of the symbol table
class sym 
{                     
	public:
		string name;				// Name of the symbol
		symboltype *type;			// Type of the symbol
		int size;					// Size of the symbol
		int offset;					// Offset of symbol in ST
		symboltable* nested;			// Points to the nested table
		string val;				    // Initial value (if specified) of the symbol

		sym (string , string t="int", symboltype* ptr = NULL, int width = 0);

		sym* update(symboltype*); 	// Update fields of an entry.
};

typedef sym s;

// Symbol Type Class
class symboltype 
{                     
	public:
		string type;					// Type of symbol. 
		int width;					    // Size of Array, if encountered (Default Value : 1)
		symboltype* arrtype;			// Pointer for multidimentional arr1s
		
		symboltype(string , symboltype* ptr = NULL, int width = 1);
};

typedef symboltype symtyp;

// Symbol Table Class
class symboltable 
{ 					
	public:
		string name;				    // Table Name
		int count;					    // Count of the temporary variables
		list<sym> table; 			    // The table of symbols
		symboltable* parent;			// Parent symbol table of the current symbol table
		
		symboltable (string name="NULL");
		s* lookup (string);		// Symbol lookup in table					
		void print();			// Prints the table					            			
		void update();			// Updates the table					        			
};

// Quad : Element of quadArray
class quad 
{ 			
	public:
		string res;					// Result
		string op;					// Operator
		string arg1;				// Argument 1
		string arg2;				// Argument 2

		void print();		// Prints the Quad
		void type1();
		void type2();
						
		quad (string , string , string op = "=", string arg2 = "");			
		quad (string , int , string op = "=", string arg2 = "");				
		quad (string , float , string op = "=", string arg2 = "");			
};

// Array of quads
class quadArray 
{ 	
	public:
		vector<quad> Array;		                    // Simply an Array (vector) of quads
		
		void print();							// Prints the quadArray					
};

// Denotes a basic type
class basicType 
{                       
	public:
		vector<string> type;                    // Type name
		vector<int> size;                       // Size
		void addType(string ,int );
};

//---------------- Variables to be exported to the cxx file ---------------------//

extern symboltable* globalST;				    // Global Symbol Table

extern symboltable* ST;						// Current Symbol Table

extern basicType bType;                        // Type ST

extern s* currSymbolPtr;					    // Latest encountered symbol

extern quadArray Q;							// Quad Array

//---------------- Global functions required by the translator ---------------------//

s* gentemp (symboltype* , string init = "");	  // Generates temporary variable and inserts it in the current symbol table

string IntToString(int );

string FloatToString(float );

void leaveGap(int );

// Emit Functions

void emit(string , string , int, string arg2 = "");	

void emit(string , string , string arg1="", string arg2 = "");  

void emit(string , string , float , string arg2 = "");   

// Backpatching and related functions

void backpatch (list <int> , int );

list<int> makelist (int );							    // Creates new list containing an integer

list<int> merge (list<int> &l1, list <int> &l2);		// Merges two lists into a single list

int nextinstr();										// Returns the next instruction number

bool compareSymbolType(sym* &s1, sym* &s2);				// Checks if the type of two symbol table entries are same

bool compareSymbolType(symboltype*, symboltype*);	// Checks if the type of two symboltype objects are same

s* convertType(sym*, string);								// Performs type conversion

int computeSize (symboltype *);						// Calculates size of symbol type

void changeTable (symboltable* );					// Changes current table

string printType(symboltype *);							// Prints type of symbol

//---------------- Attributes and their explanation for non terminal types ---------------------//

// Statement Attribute
struct Statement {
	list<int> nextlist;					// Nextlist for Statement
};

// Expression Attribute
struct Expression {
	string type; 							// Type of expression
	s* loc;								//pointer to the symbol table entry
	list<int> truelist;						// Truelist for boolean expressions
	list<int> falselist;					// Falselist for boolean expressions
	list<int> nextlist;						// for statement expressions
};

typedef Expression* Exp;
Exp BooltoInt(Exp);				// Converts boolean expression to integer
Exp InttoBool(Exp);				// Converts integer expression to boolean

// Array Attributes
struct Array {
	string atype;				// Type of Array : pointer or array
	s* Array;					// Pointer to the symbol table entry
	s* loc;						// Location used to compute address of Array
	symboltype* type;			// Type of the subarr1 generated (for multidimensional arr1s)
};


#endif