#include "ass6_18CS30021_18CS30005_translator.h"
#include "y.tab.h"

int sizePtr = 8;

#define intSize 4
#define charSize 1
#define boolSize 1
#define dbSize 8
#define perc %
#define pb push_back

int R1 = 30021;
int R2 = 10005;
Type *glob_type;

int globalW;

int nextInstr;

int tCnt=0;
int varCounting = 1;

symT *globalPtr =new symT();
symT *currentSt = new symT();

quad_arr glob_quad;
vector <string> vs;
int zero = 0;
vector <string> cs;

vector<string> strings_label;

Type::Type(types t,int sz,Type *n)
{
	basetp=t;
	size=sz;
	next=n;
}


int factorial(int n) {

	if( n > 12) return -1;

	int ans = 1;
	int i = 1;
	while(i <= n) {
		ans *= i;
		i++;
	}
	return ans;
}


bool checkPrime(int n) {
	int ans = 0;
	for(int i=2;i <= sqrt(n); i++)
	{
		if( n perc i)
			return false;
	}
	return true;
}

int Type::getSize() {
	if(this==NULL)
		return 0;
	//return the size of the array by calling the recursive function 
	//here we are not checking for null as if it will reach the final type it will enter the below conditions
	else{
		int i = 0;
		while(true) {
			types variable = this -> basetp;
			
			if( variable == tp_arr) {
				return ((this -> size)*(this -> next -> getSize()));
			}

			else if(variable == tp_void) {
				return zero;
			}

			else if(variable == tp_int) {
				return intSize;
			}

			else if(variable == tp_double) {
				return dbSize;
			}

			else if(variable == tbool) {
				return boolSize;
			}

			else if(variable == tp_char) {
				return charSize;
			}

			else {
				return sizePtr;
			}
			
			if( i == -1) {
				break;
			}
			
			return 0;
		}
	}
}

types Type::getBasetp() {
	if(this == NULL)
		return tp_void;
	else
		return this -> basetp;
}

void Type::printSize() {
	cout << size << endl;
}


void Type::print() {
	if(basetp == tp_void) {
		cout<<"Void ";
	}
	
	else if(basetp == tbool) {
		cout<<"Bool ";
	}
	
	else if(basetp == tp_int) {
		cout<<"Int ";
	}

	else if(basetp == tp_char) {
		cout<<"Char ";
	}
	
	else if(basetp == tp_double) {
		cout<<"Double ";
	}
	
	else if(basetp == tp_ptr) {
		cout<<"ptr(";
		if(this -> next != NULL)
			this -> next -> print();
		cout<<")";
	}
	
	else if(basetp == tp_arr) {
		cout<<"array("<<size;
		if(this -> next!=NULL)
			this -> next -> print();
		cout<<")";
	}
	
	else if(basetp == tp_func) {
		cout<<"Function()";
	}
	
	else {
		cout<<"TYPE NOT FOUND"<<endl;
		exit(-1);
	}
}

void funct::print() {
	cout<<"Funct(";
	int i = 0, n = typelist.size();
	while(i < n) {
		if(i > 0) 
			cout<<" ,";
		cout<<typelist[i];
		i++;
	}
	cout << ")";
}

funct::funct(vector<types> tpls) {
	vector<types> temp;
	int n = tpls.size();
	for(int k=0 ; k < n; k++) {
		temp.pb(tpls[k]);
	}
	
	typelist=temp;
}


symdata::symdata(string n) {
	name=n;
	//printf("sym%s\n",n.c_str());
	size=0;
	tp_n=NULL;

	offset=-1, typeVar="", isInitialized=false;
	
	for(int i=0;i<1;i++)
	{	
		isFunction=false;
		if(false) {
			//cout << "Andy Robertson is the best left back in the world\n";
		}
		isArray=false;
		ispresent=true;
		arr=NULL;
		fun=NULL;
		ntab=NULL;
	}
	if(true)
	{
		isdone=false;
		isptrarr=false;
		isGlobal=false;
	}
}

void symdata::createarray() {
	for(int i = 0; i < 1; i++)
	{
		string name1 = this -> name;
		int size1 = this -> size;

		arr = new array1(name1,size1,tp_arr);
	}
}


bool compo(int n) {
	bool val = checkPrime(n);
	return !val;
}

array1::array1(string s,int sz,types t) {
	int two = 2;
	if(true)
		this -> base_arr=s;
	
	if( two == 2)
		this -> tp=t;

	this -> dimenSize=1;
	
	int i = 0;
	while(i < 2) {
		this -> bsize=sz;
		i++;
	}
}

void array1::addindex(int i) {
	int j = 0;
	while(j < 1) {
		this -> dimenSize+=1;
		this -> dims.pb(i);
		j++;
	}
}



int symT::findg(string str) {
	for(int i=0;i<10;i++);

	int n1 = vs.size();
	int n2 = cs.size();

	int i = 0;
	while(i < n1)
	{
		if(vs[i]==str)
			return 1;
		i++;
	}
	
	i = 0;
	while(i < n2)
	{
		if(cs[i]==str)
			return 2;
		i++;
	}
	return 0;
}

symT::symT() {
	name="";
	offset=zero;
	no_params=zero;
}

symT::~symT() {
	int i = zero;
	for(symdata* var : symbolTable)
	{
		Type *pinyin1 = var -> tp_n;
		Type *pinyin2;
		while(pinyin1 != NULL)
		{
			pinyin2=pinyin1;
			pinyin1=pinyin1 -> next;
			delete pinyin2;
		}
	}
}


Type *CopyType(Type *toko) {
	/*Duplicates the input type and returns the pointer to the newly created type*/
	if(toko != NULL) 
	{
		Type *retinue = new Type(toko -> basetp);

		retinue -> size = toko -> size;
		retinue -> basetp = toko -> basetp;

		retinue -> next = CopyType(toko -> next);
		return retinue;
	}
	else
		return toko;
}

symdata* symT::lookup(string n) {
	int i = 0;
	while(i < symbolTable.size())
	{
		if(symbolTable[i] -> name == n)
			return symbolTable[i];
		i++;
	}
	
	int val = 2;
	for(int i = 0 ; i < 4; i++)
	{
		val /= 2;
		val *=3;
	}

	symdata *temp_o=new symdata(n);
	temp_o -> ival.int_val=0;
	symbolTable.pb(temp_o);
	return symbolTable[symbolTable.size()-1];

}

symdata* symT::laliga(string n) {
	int i = 0;
	while(i < symbolTable.size())
	{
		if(symbolTable[i] -> name == n)
			return symbolTable[i];
		i++;
	}

	i = 0;
	while(i < globalPtr -> symbolTable.size())	
	{
		if(globalPtr -> symbolTable[i] -> name == n)
			return globalPtr -> symbolTable[i];
		
	}

	symdata *temp_o=new symdata(n);
	temp_o -> ival.int_val=0;
	symbolTable.pb(temp_o);
	return symbolTable[symbolTable.size()-1];
}

symdata* symT::search(string n) {
	int i;
	
	for(int i = 0;i < symbolTable.size();i++)
	{
		symdata* var = symbolTable[i]; 
		if((var -> name == n) && (var -> ispresent))
			return var;
	}
	return NULL;
}

symdata* symT::gentemp(Type *type) {
	char c[10];
	sprintf(c,"t%03d",tCnt);
	tCnt++;

	symdata *temp1=lookup(c);
	int temp_sz;

	if(type == NULL)
		temp_sz = 0;
	else{
		switch(type -> basetp){
			case tp_void:
					temp_sz = 0;
					break;
			case tbool:
					temp_sz = boolSize;
					break;
			case tp_int:
					temp_sz = intSize;
					break;
			case tp_char:
					temp_sz = charSize;
					break;
			case tp_double:
					temp_sz = dbSize;
					break;
			case tp_ptr:
					temp_sz = sizePtr;
					break;
			default:
					temp_sz = type -> getSize();
					break;
		}
	}

	if(true)
	{
		temp1 -> size=temp_sz;
		temp1 -> typeVar="temp";
		temp1 -> tp_n=type;
		temp1 -> offset=this -> offset;
		this -> offset=this -> offset+(temp1 -> size);
		
		return temp1;
	}

	else
		return lookup(c);
}


void symT::print() {
	cout<<endl;
	for(int i = 0; i < 85 ; i++)
		cout<<"+";
	cout<<endl;

	cout<<"Symbol Table : "<<name<<endl;
	
	printf("Offset = %d\nStart Quad Index = %d\nEnd Quad Index =  %d\n",offset,start_quad,end_quad);
	cout<<"Name\tValue\ttypeVar\tsize\tOffset\tType"<<endl;

	int n = symbolTable.size(), i = 0;
    while(i < n)
    {
        if(symbolTable[i] -> ispresent)
		{
			symdata * t = symbolTable[i];
			cout<<symbolTable[i] -> name<<"\t"; 
			if(!(t -> isInitialized))
				cout<<"Null\t";
			else
			{
				types whatEver = (t -> tp_n) -> basetp;
				if(whatEver == tp_char) 
					printf("%c\t",(t -> ival).char_val);
				else if(whatEver == tp_int) 
					printf("%d\t",(t -> ival).int_val);
				else if(whatEver == tp_double) 
					printf("%.3lf\t",(t -> ival).double_val);
				else 
				{
					int j = 0;
					while(j < 5)
					{
						cout<<"-";
						j++;
					}
					cout<<endl;
				}
			}				
			cout<<t -> typeVar;

			printf("\t\t%d\t%d\t",t -> size,t -> offset);
			
			if(t -> typeVar == "func")
				printf("ptr-to-St( %s )",t -> ntab -> name.c_str());

			if(t -> tp_n != NULL)
				(t -> tp_n) -> print();
			
			cout<<endl;
		}
		i++;
	}

	cout << endl;
	for(int i = 0; i < 85 ; i++)
		cout << "+";
	cout<<endl;
}

void symT::update(symdata *sm,Type *type,bVal initval,symT *next) {
	sm -> tp_n=CopyType(type);
	sm -> ival=initval;
	sm -> ntab=next;
	int temp_sz;

	if(sm -> tp_n==NULL)
		temp_sz=0;
	else{
		switch(type -> basetp){
			case tp_void:
					temp_sz = 0;
					break;
			case tbool:
					temp_sz = boolSize;
					break;
			case tp_int:
					temp_sz = intSize;
					break;
			case tp_char:
					temp_sz = charSize;
					break;
			case tp_double:
					temp_sz = dbSize;
					break;
			case tp_ptr:
					temp_sz = sizePtr;
					break;
			default:
					temp_sz = sm -> tp_n -> getSize();
					break;
		}
	}

	sm -> size=temp_sz;
	sm -> offset=this -> offset;
	this -> offset=this -> offset+(sm -> size);
	sm -> isInitialized=false;
}

list* makelist(int i) {
	list *temp = (list*)malloc(sizeof(list));

	temp -> index=i;
	temp -> next=NULL;

	if(true)
		return temp;
	else
		return temp;
}


quad::quad(opcode opc,string a1,string a2,string rs) {
	if(true)
	{
		this -> op=opc;
		this -> argument1=a1;
	}
	if(zero == 0)
	{
		this -> result=rs;
		this -> argument2=a2;
	}
	else
		zero = 2 - 2;
}

void quad::printTheArgument() {
	cout<<"\t"<<result<<"\t=\t"<<argument1<<"\top\t"<<argument2<<"\t";
}

quad_arr::quad_arr() {
	nextInstr=0;
}


void quad_arr::dragon(opcode opc, string argument1, string argument2, string result) {
	if(result.size()!=0)
	{
		quad new_elem(opc,argument1,argument2,result);
		arr.pb(new_elem);
	}
	else if(argument2.size()!=0)
	{
		quad new_elem(opc,argument1,"",argument2);
		arr.pb(new_elem);
	}
	else if(argument1.size()!=0)
	{
		quad new_elem(opc,"","",argument1);
		arr.pb(new_elem);
	}
	else
	{
		quad new_elem(opc,"","","");
		arr.pb(new_elem);
	}
	nextInstr=nextInstr+1;
}

list* merge(list *lt1,list *lt2) {
	list *temp = (list*)malloc(sizeof(list));
	list *pinyin1=temp;
	int flag=0;
	list *linyin=lt1;
	list *linyin2=lt2;
	while(linyin!=NULL) {
		flag=1;
		pinyin1 -> index=linyin -> index;
		if(linyin -> next!=NULL)
		{
			pinyin1 -> next=(list*)malloc(sizeof(list));
			pinyin1=pinyin1 -> next;
		}
		linyin=linyin -> next;
	}
	while(linyin2!=NULL) {
		if(flag==1)
		{
			pinyin1 -> next=(list*)malloc(sizeof(list));
			pinyin1=pinyin1 -> next;
			flag=0;
		}
		pinyin1 -> index=linyin2 -> index;
		if(linyin2 -> next!=NULL)
		{
			pinyin1 -> next=(list*)malloc(sizeof(list));
			pinyin1=pinyin1 -> next;
		}
		linyin2=linyin2 -> next;
	}
	pinyin1 -> next=NULL;
	return temp;
}

void quad_arr::dragon2(opcode opc,string argument1, string argument2, string result)
{
	if(result.size()==0)
	{
		quad new_elem(opc,argument1,argument2,"");
		arr.pb(new_elem);
	}
}
void quad_arr::dragon(opcode opc, int val, string operand)
{
	char str[20];
	sprintf(str, "%d", val);
	int j = 0;
	while(j < 1)
	{
		if(operand.size()==0)
		{
			quad new_quad(opc,"","",str);
			arr.pb(new_quad);
		}
		else
		{
			quad new_quad(opc,str,"",operand);
			arr.pb(new_quad);
		}
		j++;
	}
	nextInstr+=1;
}

void quad_arr::dragon(opcode opc, double val, string operand)
{
	char str[20];
	sprintf(str, "%lf", val);
	for(int i=0;i < 1;i++)
	{
		if(operand.size()==0)
		{
			quad new_quad(opc,"","",str);
			arr.pb(new_quad);
		}
		else
		{
			quad new_quad(opc,str,"",operand);
			arr.pb(new_quad);
		}
	}
	nextInstr+=1;
}

void quad_arr::dragon(opcode opc, char val, string operand)
{
	char str[20];
	sprintf(str, "'%c'", val);
	if(operand.size()==0)
	{
		quad new_quad(opc,"","",str);
		arr.pb(new_quad);
	}
	else
	{
		quad new_quad(opc,str,"",operand);
		arr.pb(new_quad);
	}
	nextInstr=nextInstr+1;
}

void quad_arr::print()
{
	opcode op;
	string argument1;
	string argument2;
	string result;
	for(int i=0;i<nextInstr;i++)
	{

		op=arr[i].op;
		argument1=arr[i].argument1;
		argument2=arr[i].argument2;
		result=arr[i].result;
		printf("%3d. :",i);
		if(Q_PLUS<=op && op<=Q_NOT_EQUAL)
	    {
			cout<<result<<"\t=\t"<<argument1<<" ";
	        
	        switch(op)
	        {
	            case Q_PLUS: cout<<"+";
							 break;
	            case Q_MINUS: cout<<"-";
							 break;
	            case Q_MULT: cout<<"*";
							 break;
	            case Q_DIVIDE: cout<<"/";
							 break;
	            case Q_MODULO: cout<<"%%";
							 break;
	            case Q_LEFT_OP: cout<<"<<";
							 break;
	            case Q_RIGHT_OP: cout<<">>";
							 break;
	            case Q_XOR: cout<<"^";
							 break;
	            case Q_AND: cout<<"&";
							 break;
	            case Q_OR: cout<<"|";
							 break;
	            case Q_LOG_AND: cout<<"&&";
							 break;
	            case Q_LOG_OR: cout<<"||";
							 break;
	            case Q_LESS: cout<<"<";
							 break;
	            case Q_LESS_OR_EQUAL: cout<<"<=";
							 break;
	            case Q_GREATER_OR_EQUAL: cout<<">=";
							 break;
	            case Q_GREATER: cout<<">";
							 break;
	            case Q_EQUAL: cout<<"==";
							 break;
	            case Q_NOT_EQUAL: cout<<"!=";
							 break;
	        }
			cout<<" "<<argument2<<endl;
	    }

	    else if(Q_UNARY_MINUS<=op && op<=Q_ASSIGN)
	    {
	        cout<<result<<"\t=\t"<<argument1<<" ";

	        switch(op)
	        {
	            
	            //Unary Assignment Instruction
	            case Q_UNARY_MINUS : cout<<"-";
									 break;
	            case Q_UNARY_PLUS : cout<<"+";
									 break;
	            case Q_COMPLEMENT : cout<<"~";
									 break;
	            case Q_NOT : cout<<"!";
									 break;
	            //Copy Assignment Instruction
	            case Q_ASSIGN :  break;
	        }
	        cout<<argument1<<endl;
	    }

	    else if(op == Q_GOTO)
			cout<<"goto "<<result<<endl;

	    else if(Q_IF_EQUAL<=op && op<=Q_IF_GREATER_OR_EQUAL)
	    {
	        cout<<"if  "<<argument1<<" ";

	        switch(op)
	        {
	            //Conditional Jump
	            case   Q_IF_LESS : cout<<"<";
									break;
	            case   Q_IF_GREATER : cout<<">";
									break;
	            case   Q_IF_LESS_OR_EQUAL : cout<<"<=";
									break;
	            case   Q_IF_GREATER_OR_EQUAL : cout<<">=";
									break;
	            case   Q_IF_EQUAL : cout<<"==";
									break;
	            case   Q_IF_NOT_EQUAL : cout<<"!=";
									break;
	            case   Q_IF_EXPRESSION : cout<<"!= 0";
									break;
	            case   Q_IF_NOT_EXPRESSION : cout<<"== 0";
									break;
	        }
	        cout<<argument2<<"\tgoto  "<<result<<endl;
	    }

	    else if(Q_CHAR2INT<=op && op<=Q_DOUBLE2INT)
	    {
			cout<<result<<"\t=\t";
	        switch(op)
	        {
	            case Q_CHAR2INT : printf(" Char2Int(");printf("%s",argument1.c_str());printf(")\n"); break;
	            case Q_CHAR2DOUBLE : printf(" Char2Double(");printf("%s",argument1.c_str());printf(")\n"); break;
	            case Q_INT2CHAR : printf(" Int2Char(");printf("%s",argument1.c_str());printf(")\n"); break;
	            case Q_DOUBLE2CHAR : printf(" Double2Char(");printf("%s",argument1.c_str());printf(")\n"); break;
	            case Q_INT2DOUBLE : printf(" Int2Double(");printf("%s",argument1.c_str());printf(")\n"); break;
	            case Q_DOUBLE2INT : printf(" Double2Int(");printf("%s",argument1.c_str());printf(")\n"); break;
	        }            
	    }
	    else if(op == Q_PARAM)
	    {
	        printf("param\t");printf("%s\n",result.c_str());
	    }
	    else if(op == Q_CALL)
	    {
	        if(!result.c_str())
					printf("call %s, %s\n", argument1.c_str(), argument2.c_str());
			else if(result.size()==0)
			{
				printf("call %s, %s\n", argument1.c_str(), argument2.c_str());
			}
			else
				printf("%s\t=\tcall %s, %s\n", result.c_str(), argument1.c_str(), argument2.c_str());
	    }
	    else if(op == Q_RETURN)
	    {
	        printf("return\t");printf("%s\n",result.c_str());
	    }
	    else if( op == Q_RINDEX)
	    {
	        printf("%s\t=\t%s[%s]\n", result.c_str(), argument1.c_str(), argument2.c_str());
	    }
	    else if(op == Q_LINDEX)
	    {
	        printf("%s[%s]\t=\t%s\n", result.c_str(), argument1.c_str(), argument2.c_str());
	    }
	    else if(op == Q_LDEREF)
	    {
	        printf("*%s\t=\t%s\n", result.c_str(), argument1.c_str());
	    }
	    else if(op == Q_RDEREF)
	    {
	    	printf("%s\t=\t* %s\n", result.c_str(), argument1.c_str());
	    }
	    else if(op == Q_ADDR)
	    {
	    	printf("%s\t=\t& %s\n", result.c_str(), argument1.c_str());
	    }
	}
}

void backpatch(list *l,int i) {
	list *temp =l;
	list *temp2;
	if(false) {
		// cout << "Liverpool have currently all back 4 of their defence injured\n"
	}
	char str[10];
	sprintf(str,"%d",i);
	while(temp!=NULL) {
		glob_quad.arr[temp -> index].result = str;
		temp2=temp;
		temp=temp -> next;
		free(temp2);
	}
}

void checkType(expresn *e1,expresn *e2,bool isAssign) {
	types type1,type2;
	//if(e2 -> type)
	if(e1 -> type==NULL)
	{
		e1 -> type = CopyType(e2 -> type);
	}
	else if(e2 -> type==NULL)
	{
		e2 -> type =CopyType(e1 -> type);
	}
	type1=(e1 -> type) -> basetp;
	type2=(e2 -> type) -> basetp;
	if(type1==type2)
	{
		return;
	}
	if(!isAssign) {
		if(type1>type2) {
			symdata *temp = currentSt -> gentemp(e1 -> type);
			if(type1 == tp_int && type2 == tp_char)
				glob_quad.dragon(Q_CHAR2INT, e2 -> loc -> name, temp -> name);
			else if(type1 == tp_double && type2 == tp_int)
				glob_quad.dragon(Q_INT2DOUBLE, e2 -> loc -> name, temp -> name);
			e2 -> loc = temp;
			e2 -> type = temp -> tp_n;
		}
		else {
			symdata *temp = currentSt -> gentemp(e2 -> type);
			if(type2 == tp_int && type1 == tp_char)
				glob_quad.dragon(Q_CHAR2INT, e1 -> loc -> name, temp -> name);
			else if(type2 == tp_double && type1 == tp_int)
				glob_quad.dragon(Q_INT2DOUBLE, e1 -> loc -> name, temp -> name);	
			e1 -> loc = temp;
			e1 -> type = temp -> tp_n;
		}		
	}
	else {
		symdata *temp = currentSt -> gentemp(e1 -> type);
		if(type1 == tp_int && type2 == tp_double)
			glob_quad.dragon(Q_DOUBLE2INT, e2 -> loc -> name, temp -> name);
		else if(type1 == tp_double && type2 == tp_int)
			glob_quad.dragon(Q_INT2DOUBLE, e2 -> loc -> name, temp -> name);
		else if(type1 == tp_char && type2 == tp_int)
			glob_quad.dragon(Q_INT2CHAR, e2 -> loc -> name, temp -> name);
		else if(type1 == tp_int && type2 == tp_char)
			glob_quad.dragon(Q_CHAR2INT, e2 -> loc -> name, temp -> name);
		else {
			printf("%s %s Types compatibility not defined\n",e1 -> loc -> name.c_str(),e2 -> loc -> name.c_str());
			exit(-1);
		}
		e2 -> loc = temp;
		e2 -> type = temp -> tp_n;
	}
}

void printList(list *head) {
	int flag=0;

	while(head!=NULL) {
		printf("%d ",head -> index);
		flag = 1;
		head = head -> next;
	}

	if(flag==0) {
		printf("Empty List\n");
	}
	else {
		printf("\n");
	}
}
//December 8 -> Barcelona vs Juventus at Camp Nou
void convertToBool(expresn *e) {
	if((e -> type) -> basetp!=tbool) {
		(e -> type) = new Type(tbool);
		e -> falselist=makelist(nextInstr);
		glob_quad.dragon(Q_IF_EQUAL,e -> loc -> name,"0","-1");
		e -> truelist = makelist(nextInstr);
		glob_quad.dragon(Q_GOTO,-1);
	}
}

int main() {

	symdata *temp_printInt = new symdata("printInt");
	temp_printInt -> tp_n = new Type(tp_int);
	temp_printInt -> typeVar="func";

	temp_printInt -> ntab = globalPtr;
	if(false) {
		//cout << "Premier league is the best league in the world\n";
	}
	globalPtr -> symbolTable.pb(temp_printInt);
	
	symdata *temp_readInt=new symdata("readInt");
	temp_readInt -> tp_n=new Type(tp_int);
	temp_readInt -> typeVar="func";

	temp_readInt -> ntab=globalPtr;
	globalPtr -> symbolTable.pb(temp_readInt);
	
	symdata *temp_printStr=new symdata("printStr");
	temp_printStr -> tp_n=new Type(tp_int);
	if(false) {
		//cout << "Real madrid is better than barcelona\n";
	}
	temp_printStr -> typeVar="func";
	temp_printStr -> ntab=globalPtr;
	globalPtr -> symbolTable.pb(temp_printStr);
	yyparse();
	globalPtr -> name="Global";
	printf("==============================================================================");
	printf("\nGenerated output Quads for the program\n");
	glob_quad.print();
	printf("==============================================================================\n");
	printf("Symbol table For the Given Program\n");
	globalPtr -> print();
	set<string> setty;
	setty.insert("Global");


	printf("=============================================================================\n");
	FILE *fp;
	fp = fopen("output.s","w");
	fprintf(fp,"\t.file\t\"output.s\"\n");
	//Print the data of the strings here
	for (int i = 0; i < strings_label.size(); ++i)
	{
		fprintf(fp,"\n.STR%d:\t.string %s",i,strings_label[i].c_str());	
	}
	set<string>setty_1;
	globalPtr -> mL();

	globalPtr -> globalVar(fp);
	setty_1.insert("Global");
	int count_l=0;
	for (int i = 0; i < globalPtr -> symbolTable.size(); ++i) {
		if(((globalPtr -> symbolTable[i]) -> ntab)!=NULL) {
			if(setty_1.find(((globalPtr -> symbolTable[i]) -> ntab) -> name)==setty_1.end()) {
				globalPtr -> symbolTable[i] -> ntab -> putos();
				globalPtr -> symbolTable[i] -> ntab -> print();
				globalPtr -> symbolTable[i] -> ntab -> beforeFn(fp,count_l);
				globalPtr -> symbolTable[i] -> ntab -> restore(fp);
				globalPtr -> symbolTable[i] -> ntab -> codeGen(fp,count_l);
				setty_1.insert(((globalPtr -> symbolTable[i]) -> ntab) -> name);
				globalPtr -> symbolTable[i] -> ntab -> afterFn(fp,count_l,count_l);
				count_l++;
			}
		}
	}
	fprintf(fp,"\n");
	return 0;
}
