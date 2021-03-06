/* Compiler lab assignment 5
   Group number 47
   Itish Agarwal - 18CS30021
   Aditya Singh  - 18CS30005 
*/

#include "ass5_18CS30021_18CS30005_translator.h"
#include<sstream>
#include<string>
#include<iostream>
using namespace std;

//---------------- Global variables declared in header file  ---------------------//

symboltable* globalST;					// Global Symbol Table

string var_type;						// Stores latest type

sym* currSymbolPtr; 					// Points to current symbol

symboltable* ST;						// Points to current symbol table

basicType bType;                       // basic types

quadArray Q;						// Quad Array

sym::sym(string name, string t, symboltype* arrtype, int width) 
{     //Symbol table entry
		
		(*this).name=name;
		type=new symboltype(t,arrtype,width);       //Generate type of symbol
		
		size=computeSize(type);                   //find the size from the type
		
		offset=0;                                   //put offset as 0
		
		val="-";                                    //no initial value
		
		nested=NULL;                                //no nested table
		
}
sym* sym::update(symboltype* t) 
{
		
	type=t;										 //Update the new type
	
	(*this).size=computeSize(t);                 //new size
	
	return this;                                 //return the same variable	
}

symboltype::symboltype(string type,symboltype* arrtype,int width)        // Constructor for a symbol type
{
	
	(*this).type=type;
	
	(*this).width=width;
	
	(*this).arrtype=arrtype;
	
}
symboltable::symboltable(string name)            //Simple constructor for a symbol table
{
	(*this).name=name;
	
	count=0;                           
	
}
sym* symboltable::lookup(string name)               //Lookup an id in the symbol table
{
	sym* symbol;
	list<sym>::iterator it;                      
	it=table.begin();
	while(it!=table.end()) 
	{
		if(it->name==name) 
			return &(*it);        
		it++;
	}
	symbol= new sym(name);
	table.push_back(*symbol);           
	return &table.back();              
}
void symboltable::update()                      // Updates the symbol table 
{
	list<symboltable*> tb;               
	int off;
	list<sym>::iterator it;
	it=table.begin();
	while(it!=table.end()) 
	{
		if(it==table.begin()) 
		{
			it->offset=0;
			off=it->size;
		}
		else 
		{
			it->offset=off;
			off=it->offset+it->size;
		}
		if(it->nested!=NULL) 
			tb.push_back(it->nested);
		it++;
	}
	list<symboltable*>::iterator it1;
	it1=tb.begin();
	while(it1 !=tb.end()) 
	{
	  (*it1)->update();
	  it1++;
	}
}

void symboltable::print()                            // Prints a symbol table
{
	int next_instr=0;
	list<symboltable*> tb;                   
	for(int i=0;i<50;i++) 
		cout<<"__";          
	cout<<endl;
	cout<<"Table Name: "<<(*this).name<<"\t\t\t Parent Name: ";        
	if(((*this).parent==NULL))
		cout<<"NULL"<<endl;
	else
		cout<<(*this).parent->name<<endl; 
	for(int i=0;i<50;i++) 
		cout<<"__";
	cout<<endl;
	cout<<"Name";              // Name
	leaveGap(12);
	cout<<"Type";              // Type
	leaveGap(17);
	cout<<"Initial Value";    // Initial Value
	leaveGap(8);
	cout<<"Size";              // Size
	leaveGap(12);
	cout<<"Offset";            // Offset
	leaveGap(10);
	cout<<"Nested"<<endl;       // Nested symbol table
	leaveGap(101);
	cout<<endl;
	ostringstream str1;
	 
	for(list<sym>::iterator it=table.begin(); it!=table.end(); it++) {          // Prints details for the table
		
		cout<<it->name;                                    
		
		leaveGap(16-it->name.length());
		     
		string typeres=printType(it->type);            
			
		cout<<typeres;
		
		leaveGap(21-typeres.length());
		 
		cout<<it->val;                               
		
		leaveGap(21-it->val.length());
		
		cout<<it->size;                               
		
		str1<<it->size;
		
		leaveGap(16-str1.str().length());
		
		str1.str("");
		
		str1.clear();
		
		cout<<it->offset;                              
		
		str1<<it->offset;
		
		leaveGap(16-str1.str().length());
		
		str1.str("");
		
		str1.clear();
		
		if(it->nested==NULL) {                    
			
			cout<<"NULL"<<endl;
				
		}
		else {
			
			cout<<it->nested->name<<endl;
				
			tb.push_back(it->nested);
			
		}
	}
	
	for(int i=0;i<100;i++) 
		cout<<"-";
	cout<<"\n\n";
	for(list<symboltable*>::iterator it=tb.begin(); it !=tb.end();++it) 
	{
    	(*it)->print();                          
	}
			
}

// General constructors for quad
quad::quad(string res,string arg1,string op,string arg2)           
{
	
	(*this).res=res;
	
	(*this).arg1=arg1;
	
	(*this).op=op;
	
	(*this).arg2=arg2;
	
}
quad::quad(string res,int arg1,string op,string arg2)          
{
	
	(*this).res=res;
	
	(*this).arg2=arg2;
	
	(*this).op=op;
	
	(*this).arg1=IntToString(arg1);
	
}
quad::quad(string res,float arg1,string op,string arg2)         
{
	
	(*this).res=res;
	
	(*this).arg2=arg2;
	
	(*this).op=op;
	
	(*this).arg1=FloatToString(arg1);
	
}

void quad::print() 
{                                    // Prints a quad
	// Binary Operations
	int next_instr=0;	
	if(op=="+")
	{	
			
		(*this).type1();
	}
	else if(op=="-")
	{				
		
		(*this).type1();
	}
	else if(op=="*")
	{
		
		(*this).type1();
	}
	else if(op=="/")
	{	
			
		(*this).type1();
	}
	else if(op=="%")
	{
		
		(*this).type1();
	}
	else if(op=="|")
	{
		
		(*this).type1();
	}
	else if(op=="^")
	{
			
		(*this).type1();
	}
	else if(op=="&")
	{
						
		(*this).type1();
	}

	// Unary Operators

	else if(op=="=&")
	{
						
		cout<<res<<" = &"<<arg1;
	}
	else if(op=="=*")
	{
		
		cout<<res	<<" = *"<<arg1 ;
	}
	else if(op=="*=")
	{	
					
		cout<<"*"<<res	<<" = "<<arg1 ;
	}
	else if(op=="uminus")
	{
		
		cout<<res<<" = -"<<arg1;
	}
	else if(op=="~")
	{
						
		cout<<res<<" = ~"<<arg1;
	}
	else if(op=="!")
	{
		
		cout<<res<<" = !"<<arg1;
	}

	// Relational Operations

	else if(op=="==")
	{
		
		(*this).type2();
	}
	else if(op=="!=")
	{
		
		(*this).type2();
	}
	else if(op=="<=")
	{
		
		(*this).type2();
	}
	else if(op=="<")
	{	
					
		(*this).type2();
	}
	else if(op==">")
	{
		
		(*this).type2();
	}
	else if(op==">=")
	{
						
		(*this).type2();
	}
	else if(op=="goto")
	{
						
		cout<<"goto "<<res;
	}	
	// Shift Operations
	else if(op==">>")
	{
		
		(*this).type1();
	}
	else if(op=="<<")
	{
						
		(*this).type1();
	}
	else if(op=="=")
	{
						
		cout<<res<<" = "<<arg1 ;
	}	

	// Other operations

	else if(op=="=[]")
	{
		
		 cout<<res<<" = "<<arg1<<"["<<arg2<<"]";
	}
	else if(op=="[]=")
	{	
		 
		cout<<res<<"["<<arg1<<"]"<<" = "<< arg2;
	}
	else if(op=="return")
	{
		 			
		cout<<"return "<<res;
	}
	else if(op=="param")
	{
		 			
		cout<<"param "<<res;
	}
	else if(op=="call")
	{
		 			
		cout<<res<<" = "<<"call "<<arg1<<", "<<arg2;
	}
	else if(op=="label")
	{
		
		cout<<res<<": ";
	}	
	else
	{	
		cout<<"Can't find "<<op;
	}			
	cout<<endl;
	
}

void quad::type1()
{
	
	cout<<res<<" = "<<arg1<<" "<<op<<" "<<arg2;
	
}

void quad::type2()
{
	
	cout<<"if "<<arg1<< " "<<op<<" "<<arg2<<" goto "<<res;
	
}

void basicType::addType(string t, int s)          //Add new trivial type to type ST
{
	
	type.push_back(t);
	
	size.push_back(s);
	
}

void quadArray::print()                                   //print the quad Array i.e the TAC
{
	for(int i=0;i<50;i++) 
		cout<<"__";
	cout<<endl;
	cout<<"Three Address Code:"<<endl;           //print TAC
	for(int i=0;i<50;i++) 
		cout<<"__";
	cout<<endl;
	int j=0;
	vector<quad>::iterator it;
	it=Array.begin();
	while(it!=Array.end()) 
	{
		if(it->op=="label") 
		{           //it is a label, print it
			cout<<endl<<"L"<<j<<": ";
			it->print();
		}
		else {                         //otherwise give 4 spaces and then print
			cout<<"L"<<j<<": ";
			leaveGap(5);
			it->print();
		}
		it++;j++;
	}
	for(int i=0;i<50;i++) 
		cout<<"__";      //just for formatting
	cout<<endl;
}

void leaveGap(int n)
{
	
	while(n--) 
		cout<<" ";
	
}

string IntToString(int a)                    // Take int as input and produce string as output
{
	stringstream strs;                    
    strs<<a; 
    string temp=strs.str();
    char* integer=(char*) temp.c_str();
	string str=string(integer);
	return str;                              
}

string FloatToString(float x)                        // Take float as input and produce string as output
{
	std::ostringstream b;
	b<<x;
	return b.str();
}

void emit(string op, string res, int arg1, string arg2) 
{                
	quad *q2= new quad(res,arg1,op,arg2);
	
	Q.Array.push_back(*q2);
}

void emit(string op, string res, string arg1, string arg2) 
{            
	quad *q1= new quad(res,arg1,op,arg2);
	
	Q.Array.push_back(*q1);
}

void emit(string op, string res, float arg1, string arg2) 
{             
	quad *q3= new quad(res,arg1,op,arg2);
	Q.Array.push_back(*q3);
}

sym* convertType(sym* s, string rettype)  						// Convert symbol s into the required return type
{                             	
	sym* tmp=gentemp(new symboltype(rettype));	
	if((*s).type->type=="float")                                    
	{
		if(rettype=="int")                                    
		{
			emit("=",tmp->name,"float2int("+(*s).name+")");
			return tmp;
		}
		else if(rettype=="char")                             
		{
			emit("=",tmp->name,"float2char("+(*s).name+")");
			return tmp;
		}
		return s;
	}
	else if((*s).type->type=="char") 						
	{
		if(rettype=="int") 	
		{
			emit("=",tmp->name,"char2int("+(*s).name+")");
			return tmp;
		}
		if(rettype=="double") 						
		{
			emit("=",tmp->name,"char2double("+(*s).name+")");
			return tmp;
		}
		return s;
	}
	else if((*s).type->type=="int")                             
	{
		if(rettype=="float") 									
		{
			emit("=",tmp->name,"int2float("+(*s).name+")");
			return tmp;
		}
		else if(rettype=="char") 							
		{
			emit("=",tmp->name,"int2char("+(*s).name+")");
			return tmp;
		}
		return s;
	}
	return s;
}

void changeTable(symboltable* newtable) 
{	       // Change current symbol table
	
	ST = newtable;
	
} 

bool compareSymbolType(sym*& s1,sym*& s2)
{ 	// Check if the symbols have same type or not
	symboltype* type1=s1->type;                       
	symboltype* type2=s2->type;
	int flag=0;
	if(compareSymbolType(type1,type2)) 
		flag=1;       
	else if(s1=convertType(s1,type2->type)) 
		flag=1;	
	else if(s2=convertType(s2,type1->type)) 
		flag=1;
	if(flag)
		return true;
	else 
		return false;
}

bool compareSymbolType(symboltype* t1,symboltype* t2)
{ 	// Check if the symbol types are same or not
	
	int flag=0;
	if(t1==NULL && t2==NULL) 
		flag=1;             
	else if(t1==NULL || t2==NULL || t1->type!=t2->type) 
		flag=2;           
	
	if(flag==1)
		return true;
	else if(flag==2)
		return false;
	else 
		return compareSymbolType(t1->arrtype,t2->arrtype);       
}

void backpatch(list<int> list1,int addr)                 // Backpatching function
{
	string str=IntToString(addr);     
	list<int>::iterator it;
	it=list1.begin();
	
	while( it!=list1.end()) 
	{
		Q.Array[*it].res=str;                     
		it++;
	}
}

list<int> makelist(int init) 
{
	list<int> newlist(1,init);                      // Makes a new list
	
	return newlist;
}

list<int> merge(list<int> &a,list<int> &b)
{
	a.merge(b);                                // Merges two existing lists
	
	return a;
}

Expression* InttoBool(Expression* e)        
{	// Convert any Expression to bool
	if(e->type!="bool")                
	{
		e->falselist=makelist(nextinstr());    // Updates the falselist, truelist and also emit general goto statements
		emit("==","",e->loc->name,"0");
		e->truelist=makelist(nextinstr());
		emit("goto","");
	}
	return e;
}

Expression* BooltoInt(Expression* e) 
{	
	if(e->type=="bool") 
	{
		
		e->loc=gentemp(new symboltype("int"));         // Use general goto statements and standard procedure
		
		backpatch(e->truelist,nextinstr());
		
		emit("=",e->loc->name,"true");
		
		int p=nextinstr()+1;
		
		string str=IntToString(p);
		
		emit("goto",str);
		
		backpatch(e->falselist,nextinstr());
		
		emit("=",e->loc->name,"false");
		
	}
	return e;
}

int nextinstr() 
{
	
	return Q.Array.size();                //next instruction will be 1+last index and lastindex=size-1. hence return size
}

sym* gentemp(symboltype* t, string str_new) 
{           //generate temp variable
	string tmp_name = "t"+IntToString(ST->count++);             // Generate name of temporary
	sym* s = new sym(tmp_name);
	(*s).type = t;
	(*s).size=computeSize(t);                        // Calculating its size
	(*s).val = str_new;
	ST->table.push_back(*s);                        // Pushed in symbol table
	return &ST->table.back();
}

int computeSize(symboltype* t)                   //calculate size function
{
	if(t->type.compare("void")==0)	
		return bType.size[1];
	else if(t->type.compare("int")==0) 
		return bType.size[3];
	else if(t->type.compare("float")==0) 
		return  bType.size[4];
	else if(t->type.compare("arr")==0) 
		return t->width*computeSize(t->arrtype);     //recursive for arr1s(Multidimensional arr1s)
	else if(t->type.compare("char")==0) 
		return bType.size[2];
	else if(t->type.compare("ptr")==0) 
		return bType.size[5];
	else if(t->type.compare("func")==0) 
		return bType.size[6];
	else 
		return -1;
}

string printType(symboltype* t)                    // Print type of variable (for multidimensional arr1s)
{
	if(t==NULL) return bType.type[0];
	if(t->type.compare("void")==0)	return bType.type[1];
	else if(t->type.compare("char")==0) return bType.type[2];
	else if(t->type.compare("int")==0) return bType.type[3];
	else if(t->type.compare("float")==0) return bType.type[4];
	else if(t->type.compare("ptr")==0) return bType.type[5]+"("+printType(t->arrtype)+")";       
	else if(t->type.compare("arr")==0) 
	{
		string str=IntToString(t->width);                               
		return bType.type[6]+"("+str+","+printType(t->arrtype)+")";
	}
	else if(t->type.compare("func")==0) return bType.type[7];
	else return "NA";
}

int main()
{
	bType.addType("null",0);                 //Add base types initially
	bType.addType("void",0);
	bType.addType("char",1);
	bType.addType("int",4);
	bType.addType("float",8);
	bType.addType("ptr",4);
	bType.addType("arr",0);
	bType.addType("func",0);
	globalST=new symboltable("Global");                         // Global Symbol Table
	ST=globalST;
	yyparse();												 // Parser
	globalST->update();										 // Update the global Symbol Table
	cout<<"\n";
	Q.print();	
	globalST->print();										// Prints all Symbol Tables
													// Prints Three Address Codes
};
