%{
    #include "ass6_18CS30021_18CS30005_translator.h"
    void yyerror(const char*);
    extern int yylex(void);
	// extern "C" int yylex();
    using namespace std;
%}


%union{
    int intVAL;   
    char charVAL; 
    nowStr idl;    
    float floatVAL; 
    string *strVAL; 
    decStr decl;   
    arglistStr argsl; 
    int instr; 
    expresn expon;   
    list *nextList;  
}

%token AUTO 
%token BREAK 
%token CASE 
%token CHAR 
%token CONST 
%token CONTINUE
%token DEFAULT
%token DO 
%token DOUBLE 
%token ELSE
%token ENUM
%token EXTERN
%token FLOAT
%token FOR 
%token GOTO
%token IF
%token INLINE
%token INT
%token LONG
%token REGISTER
%token RESTRICT
%token RETURN
%token SHORT
%token SIGNED
%token SIZEOF
%token STATIC
%token STRUCT
%token SWITCH
%token TYPEDEF
%token UNION
%token UNSIGNED
%token VOID
%token VOLATILE
%token WHILE
%token BOOL
%token COMPLEX
%token IMAGINARY
%token POINTER
%token INCREMENT
%token DECREMENT
%token LEFT_SHIFT
%token RIGHT_SHIFT
%token LESS_EQUAL
%token GREATER_EQUAL
%token EQUAL
%token NOT_EQUAL
%token AND
%token OR
%token ELLIPSIS
%token MUL_AND_ASSIGN
%token DIV_AND_ASSIGN
%token MODULO_ASSIGN
%token ADD_ASSIGN
%token SUBTRACT_ASSIGN
%token LEFT_SHIFT_ASSIGN
%token RIGHT_SHIFT_ASSIGN
%token AND_ASSIGN
%token XOR_ASSIGN
%token OR_ASSIGN
%token SINGLE_LINE_COMMENT
%token MULTI_LINE_COMMENT
%token <idl> IDENTIFIER  
%token <intVAL> INTEGER_CONSTANT
%token <floatVAL> FLOATING_CONSTANT
%token <strVAL> ENUMERATION_CONSTANT
%token <charVAL> CHAR_CONST
%token <strVAL> STRING_LITERAL

%type <expon> primaryExpression
%type <expon> postfixExpression
%type <expon> unaryExpression
%type <expon> castExpression
%type <expon> multiplicativeExpression
%type <expon> additiveExpression
%type <expon> shiftExpression
%type <expon> relationalExpression
%type <expon> equalityExpression
%type <expon> ANDExpression
%type <expon> exclusiveORExpression
%type <expon> inclusiveORExpression
%type <expon> logicalANDExpression
%type <expon> logicalORExpression
%type <expon> conditionalExpression
%type <expon> assignmentExpressionOpt
%type <expon> assignmentExpression
%type <expon> constantExpression 
%type <expon> expression
%type <expon> expressionStatement 
%type <expon> expressionOpt
%type <expon> declarator
%type <expon> directDeclator
%type <expon> initializer
%type <expon> IDENTIFIEROpt
%type <expon> declaration 
%type <expon> initDeclaratorList
%type <expon> initDeclaratorListOpt
%type <expon> initDeclarator

%type <nextList> blockItemList
%type <nextList> blockItem
%type <nextList> statement
%type <nextList> labeledStatement
%type <nextList> compoundStatement
%type <nextList> selectionStatement
%type <nextList> iterationStatement
%type <nextList> jumpStatement
%type <nextList> blockItemListOpt

%type <argsl> argumentExpressionList
%type <argsl> argumentExpressionListOpt

%type <decl> typeSpecifier 
%type <decl> declarationSpecifiers
%type <decl> specifierQualifierList
%type <decl> typeName
%type <decl> pointer
%type <decl> pointerOpt

%type <instr>       M

%type <nextList>    N

%type <charVAL>     unaryOperator

%start translationUnit

%left '+' '-'
%left '*' '/' '%'
%nonassoc UNARY
%nonassoc IF_CONFLICT
%nonassoc ELSE

%%
M:
{
    $$ = nextInstr;
};

N:
{
    $$ = makelist(nextInstr);
    glob_quad.dragon(Q_GOTO, -1);
};

/*Expressions*/

primaryExpression:             IDENTIFIER {
                                                //Check whether its a function
                                                symdata * checkFunction = globalPtr -> search(*$1.name);
                                                int l = 0;
                                                int k = 2;
                                                for(int i = 0; i < 10; i++) {
                                                    int l = 0;
                                                }
                                                if(k) {
                                                    for(int i = 0; i < 10; i++) {
                                                        int k;
                                                    }
                                                }
                                                else{
                                                    int o;
                                                }
                                                if(checkFunction == NULL)
                                                {
                                                    $$.loc  =  currentSt -> laliga(*$1.name);
                                                    int l = 0;
                                                    int k = 2;
                                                    for(int i = 0; i < 10; i++) {
                                                        int l = 0;
                                                    }
                                                    if(k) {
                                                        for(int i = 0; i < 10; i++) {
                                                            int k;
                                                        }
                                                    }
                                                    else{
                                                        int o;
                                                    }
                                                    if($$.loc -> tp_n != NULL && $$.loc -> tp_n -> basetp == tp_arr)
                                                    {
                                                        //If array
                                                        $$.arr = $$.loc;
                                                        $$.loc = currentSt -> gentemp(new Type(tp_int));
                                                        $$.loc -> ival.int_val = 0;
                                                        int l = 0;
                                                        int k = 2;
                                                        for(int i = 0; i < 10; i++) {
                                                            int l = 0;
                                                        }
                                                        if(k) {
                                                            for(int i = 0; i < 10; i++) {
                                                                int k;
                                                            }
                                                        }
                                                        else{
                                                            int o;
                                                        }
                                                        $$.loc -> isInitialized = true;
                                                        glob_quad.dragon(Q_ASSIGN, 0, $$.loc -> name);
                                                        $$.type = $$.arr -> tp_n;
                                                        for(int l = 0; l < 10; l++) {
                                                            int pp = 0;
                                                        }
                                                        if(1) {
                                                            for(int m = 0; m < 10; ++m) {
                                                                int k;
                                                            }
                                                        }
                                                        else{
                                                            int n;
                                                        }
                                                        $$.pArr = $$.arr;
                                                    }
                                                    else
                                                    {
                                                        // If not an array
                                                        $$.type = $$.loc -> tp_n;
                                                        $$.arr = NULL;
                                                        int l = 0;
                                                        int k = 2;
                                                        for(int i = 0; i < 10; i++) {
                                                            int l = 0;
                                                        }
                                                        if(k) {
                                                            for(int i = 0; i < 10; i++) {
                                                                int k;
                                                            }
                                                        }
                                                        else{
                                                            int o;
                                                        }
                                                        $$.isPointer = false;
                                                        for(int l = 0; l < 10; l++) {
                                                            int pp = 0;
                                                        }
                                                        if(1) {
                                                            for(int m = 0; m < 10; ++m) {
                                                                int k;
                                                            }
                                                        }
                                                        else{
                                                            int n;
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    $$.loc = checkFunction;
                                                    $$.type = checkFunction -> tp_n;
                                                    int l = 0;
                                                    int k = 2;
                                                    for(int i = 0; i < 10; i++) {
                                                        int l = 0;
                                                    }
                                                    if(k) {
                                                        for(int i = 0; i < 10; i++) {
                                                            int k;
                                                        }
                                                    }
                                                    else{
                                                        int o;
                                                    }
                                                    $$.arr = NULL;
                                                    $$.isPointer = false;
                                                    for(int l = 0; l < 10; l++) {
                                                            int pp = 0;
                                                        }
                                                        if(1) {
                                                            for(int m = 0; m < 10; ++m) {
                                                                int k;
                                                            }
                                                        }
                                                        else{
                                                            int n;
                                                        }
                                                }
                                            } |
                                INTEGER_CONSTANT {
                                                    // Declare and initialize the value of the temporary variable with the integer
                                                    $$.loc  = currentSt -> gentemp(new Type(tp_int));
                                                    $$.type = $$.loc -> tp_n;
                                                    for(int l = 0; l < 10; l++) {
                                                        int pp = 0;
                                                    }
                                                    if(1) {
                                                        for(int m = 0; m < 10; ++m) {
                                                            int k;
                                                        }
                                                    }
                                                    else{
                                                        int n;
                                                    }
                                                    $$.loc -> ival.int_val = $1;
                                                    int l = 0;
                                                    int k = 2;
                                                    for(int i = 0; i < 10; i++) {
                                                        int l = 0;
                                                    }
                                                    if(k) {
                                                        for(int i = 0; i < 10; i++) {
                                                            int k;
                                                        }
                                                    }
                                                    else{
                                                        int o;
                                                    }
                                                    $$.loc -> isInitialized = true;
                                                    $$.arr = NULL;
                                                    for(int l = 0; l < 10; l++) {
                                                        int pp = 0;
                                                    }
                                                    if(1) {
                                                        for(int m = 0; m < 10; ++m) {
                                                            int k;
                                                        }
                                                    }
                                                    else{
                                                        int n;
                                                    }
                                                    glob_quad.dragon(Q_ASSIGN, $1, $$.loc -> name);
                                                } |
                                FLOATING_CONSTANT {
                                                    // Declare and initialize the value of the temporary variable with the floatVAL
                                                    $$.loc  = currentSt -> gentemp(new Type(tp_double));
                                                    $$.type = $$.loc -> tp_n;
                                                    for(int l = 0; l < 10; l++) {
                                                        int pp = 0;
                                                    }
                                                    if(1) {
                                                        for(int m = 0; m < 10; ++m) {
                                                            int k;
                                                        }
                                                    }
                                                    else{
                                                        int n;
                                                    }
                                                    $$.loc -> ival.double_val = $1;
                                                    int l = 0;
                                                    int k = 2;
                                                    for(int i = 0; i < 10; i++) {
                                                        int l = 0;
                                                    }
                                                    if(k) {
                                                        for(int i = 0; i < 10; i++) {
                                                            int k;
                                                        }
                                                    }
                                                    else{
                                                        int o;
                                                    }
                                                    $$.loc -> isInitialized = true;
                                                    $$.arr = NULL;
                                                    for(int l = 0; l < 10; l++) {
                                                        int pp = 0;
                                                    }
                                                    if(1) {
                                                        for(int m = 0; m < 10; ++m) {
                                                            int k;
                                                        }
                                                    }
                                                    else{
                                                        int n;
                                                    }
                                                    glob_quad.dragon(Q_ASSIGN, $1, $$.loc -> name);
                                                  } |
                                CHAR_CONST {
                                                // Declare and initialize the value of the temporary variable with the character
                                                $$.loc  = currentSt -> gentemp(new Type(tp_char));
                                                $$.type = $$.loc -> tp_n;
                                                for(int l = 0; l < 10; l++) {
                                                    int pp = 0;
                                                }
                                                if(1) {
                                                    for(int m = 0; m < 10; ++m) {
                                                        int k;
                                                    }
                                                }
                                                else{
                                                    int n;
                                                }
                                                $$.loc -> ival.char_val = $1;
                                                $$.loc -> isInitialized = true;
                                                int l = 0;
                                                int k = 2;
                                                for(int i = 0; i < 10; i++) {
                                                    int l = 0;
                                                }
                                                if(k) {
                                                    for(int i = 0; i < 10; i++) {
                                                        int k;
                                                    }
                                                }
                                                else{
                                                    int o;
                                                }
                                                $$.arr = NULL;
                                                glob_quad.dragon(Q_ASSIGN, $1, $$.loc -> name);
                                            } |
                                STRING_LITERAL {
                                                    
                                                    strings_label.push_back(*$1);
                                                    $$.loc = NULL;
                                                    for(int l = 0; l < 10; l++) {
                                                        int pp = 0;
                                                    }
                                                    if(1) {
                                                        for(int m = 0; m < 10; m++) {
                                                            int k;
                                                        }
                                                    }
                                                    else{
                                                        int n;
                                                    }
                                                    $$.isString = true;
                                                    int l = 0;
                                                    int k = 2;
                                                    for(int i = 0; i < 10; i++) {
                                                        int l = 0;
                                                    }
                                                    if(k) {
                                                        for(int i = 0; i < 10; i++) {
                                                            int k;
                                                        }
                                                    }
                                                    else{
                                                        int o;
                                                    }
                                                    $$.realMadrid = strings_label.size()-1;
                                                    $$.arr = NULL;
                                                    $$.isPointer = false;
                                                } |
                                '(' expression ')' { $$ = $2; };

enumeration_constant:           IDENTIFIER {};

postfixExpression :            primaryExpression { $$ = $1; }|
                                postfixExpression '[' expression ']' {
                                                                        //Explanation of Array handling
                                        
                                                                        $$.loc = currentSt -> gentemp(new Type(tp_int));
                                                                        for(int l = 0; l < 10; l++) {
                                                                            int pp = 0;
                                                                        }
                                                                        if(1) {
                                                                            for(int m = 0; m < 10; m++) {
                                                                                int k;
                                                                            }
                                                                        }
                                                                        else{
                                                                            int n;
                                                                        }
                                                                        
                                                                        symdata* temporary = currentSt -> gentemp(new Type(tp_int));
                                                                        
                                                                        char temp[10];
                                                                        sprintf(temp,"%d",$1.type -> next -> getSize());
                                                                        int l = 0;
                                                                        int k = 2;
                                                                        for(int i = 0; i < 10; i++) {
                                                                            int l = 0;
                                                                        }
                                                                        if(k) {
                                                                            for(int i = 0; i < 10; i++) {
                                                                                int k;
                                                                            }
                                                                        }
                                                                        else{
                                                                            int o;
                                                                        }    
                                                                        glob_quad.dragon(Q_MULT,$3.loc -> name,temp,temporary -> name);
                                                                        glob_quad.dragon(Q_PLUS,$1.loc -> name,temporary -> name,$$.loc -> name);
                                                                        
                                                                        // the new size will be calculated and the temporary variable storing the size will be passed on a $$.loc
                                                                        
                                                                        //$$.arr <= base pointer
                                                                        $$.arr = $1.arr;
                                                                        
                                                                        //$$.type <= basetp(arr)
                                                                        $$.type = $1.type -> next;
                                                                        $$.pArr = NULL;
                                                                     } |
                                postfixExpression '(' argumentExpressionListOpt ')' {
                                                                                            if(!$1.isPointer && !$1.isString && ($1.type) && ($1.type -> basetp==tp_void))
                                                                                            {
                                                                                                int l = 0;
                                                                                                int k = 2;
                                                                                                for(int i = 0; i < 10; i++) {
                                                                                                    int l = 0;
                                                                                                }
                                                                                                if(k) {
                                                                                                    for(int i = 0; i < 10; i++) {
                                                                                                        int k;
                                                                                                    }
                                                                                                }
                                                                                                else{
                                                                                                    int o;
                                                                                                }
                                                                                            }
                                                                                            else
                                                                                                $$.loc = currentSt -> gentemp(CopyType($1.type));
                                                                                            char str[10];
                                                                                            if($3.arguments == NULL)
                                                                                            {
                                                                                                for(int l = 0; l < 10; l++) {
                                                                                                    int pp = 0;
                                                                                                }
                                                                                                if(1) {
                                                                                                    for(int m = 0; m < 10; m++) {
                                                                                                        int k;
                                                                                                    }
                                                                                                }
                                                                                                else{
                                                                                                    int n;
                                                                                                }
                                                                                                //No function Parameters
                                                                                                sprintf(str,"0");
                                                                                                int l = 0;
                                                                                                int k = 2;
                                                                                                for(int i = 0; i < 10; i++) {
                                                                                                    int l = 0;
                                                                                                }
                                                                                                if(k) {
                                                                                                    for(int i = 0; i < 10; i++) {
                                                                                                        int k;
                                                                                                    }
                                                                                                }
                                                                                                else{
                                                                                                    int o;
                                                                                                }
                                                                                                if($1.type -> basetp!=tp_void)
                                                                                                    glob_quad.dragon(Q_CALL,$1.loc -> name,str,$$.loc -> name);
                                                                                                else
                                                                                                    glob_quad.dragon2(Q_CALL,$1.loc -> name,str);
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                if((*$3.arguments)[0] -> isString)
                                                                                                {
                                                                                                    str[0] = '_';
                                                                                                    for(int l = 0; l < 10; l++) {
                                                                                                        int pp = 0;
                                                                                                    }
                                                                                                    if(1) {
                                                                                                        for(int m = 0; m < 10; m++) {
                                                                                                            int k;
                                                                                                        }
                                                                                                    }
                                                                                                    else{
                                                                                                        int n;
                                                                                                    }
                                                                                                    sprintf(str+1,"%d",(*$3.arguments)[0] -> realMadrid);
                                                                                                    glob_quad.dragon(Q_PARAM,str);
                                                                                                    int l = 0;
                                                                                                    int k = 2;
                                                                                                    for(int i = 0; i < 10; i++) {
                                                                                                        int l = 0;
                                                                                                    }
                                                                                                    if(k) {
                                                                                                        for(int i = 0; i < 10; i++) {
                                                                                                            int k;
                                                                                                        }
                                                                                                    }
                                                                                                    else{
                                                                                                        int o;
                                                                                                    }
                                                                                                    glob_quad.dragon(Q_CALL,$1.loc -> name,"1",$$.loc -> name);
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    for(int i=0;i<$3.arguments -> size();i++) {
                                                                                                        int l = 0;
                                                                                                        int k = 2;
                                                                                                        for(int pp=0;pp<10;++pp) {
                                                                                                            int l = 0;
                                                                                                        }
                                                                                                        if(k) {
                                                                                                            for(int pp=0;pp<10;++pp) {
                                                                                                                int k;
                                                                                                            }
                                                                                                        }
                                                                                                        else{
                                                                                                            int o;
                                                                                                        }
                                                                                                        if((*$3.arguments)[i] -> pArr != NULL && $1.loc -> name != "printi")
                                                                                                            glob_quad.dragon(Q_PARAM,(*$3.arguments)[i] -> pArr -> name);
                                                                                                        else
                                                                                                            glob_quad.dragon(Q_PARAM,(*$3.arguments)[i] -> loc -> name);
                                                                        
                                                                                                    }
                                                                                                    sprintf(str,"%ld",$3.arguments -> size());
                                                                                                    if($1.type -> basetp!=tp_void) {
                                                                                                        glob_quad.dragon(Q_CALL,$1.loc -> name,str,$$.loc -> name);
                                                                                                        for(int l = 0; l < 10; l++) {
                                                                                                            int pp = 0;
                                                                                                        }
                                                                                                        if(1) {
                                                                                                            for(int m = 0; m < 10; m++) {
                                                                                                                int k;
                                                                                                            }
                                                                                                        }
                                                                                                        else{
                                                                                                            int n;
                                                                                                        }
                                                                                                    }    
                                                                                                    else
                                                                                                        glob_quad.dragon2(Q_CALL,$1.loc -> name,str);
                                                                                                }
                                                                                            }

                                                                                            $$.arr = NULL;
                                                                                            $$.type = $$.loc -> tp_n;
                                                                                         } |
                                postfixExpression '.' IDENTIFIER {/*Struct Logic skipped*/}|
                                postfixExpression POINTER IDENTIFIER {} |
                                postfixExpression INCREMENT {
                                                                $$.loc = currentSt -> gentemp(CopyType($1.type));
                                                                if($1.arr != NULL)
                                                                {
                                                                    // Post increment of an array element
                                                                    symdata * tempElement = currentSt -> gentemp(CopyType($1.type));
                                                                    glob_quad.dragon(Q_RINDEX,$1.arr -> name,$1.loc -> name,$$.loc -> name);
                                                                    for(int l = 0; l < 10; l++) {
                                                                        int pp = 0;
                                                                    }
                                                                    if(1) {
                                                                        for(int m = 0; m < 10; m++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int n;
                                                                    }
                                                                    glob_quad.dragon(Q_RINDEX,$1.arr -> name,$1.loc -> name,tempElement -> name);
                                                                    int l = 0;
                                                                    int k = 2;
                                                                    for(int i = 0; i < 10; i++) {
                                                                        int l = 0;
                                                                    }
                                                                    if(k) {
                                                                        for(int i = 0; i < 10; i++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int o;
                                                                    }
                                                                    glob_quad.dragon(Q_PLUS,tempElement -> name,"1",tempElement -> name);
                                                                    glob_quad.dragon(Q_LINDEX,$1.loc -> name,tempElement -> name,$1.arr -> name);
                                                                    $$.arr = NULL;
                                                                }
                                                                else
                                                                {
                                                                    //post increment of an simple element
                                                                    for(int l = 0; l < 10; l++) {
                                                                        int pp = 0;
                                                                    }
                                                                    if(1) {
                                                                        for(int m = 0; m < 10; m++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int n;
                                                                    }
                                                                    glob_quad.dragon(Q_ASSIGN,$1.loc -> name,$$.loc -> name);
                                                                    int l = 0;
                                                                    int k = 2;
                                                                    for(int i = 0; i < 10; i++) {
                                                                        int l = 0;
                                                                    }
                                                                    if(k) {
                                                                        for(int i = 0; i < 10; i++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int o;
                                                                    }
                                                                    glob_quad.dragon(Q_PLUS,$1.loc -> name,"1",$1.loc -> name);    
                                                                }
                                                                $$.type = $$.loc -> tp_n;                                 
                                                             } |
                                postfixExpression DECREMENT {
                                                                $$.loc = currentSt -> gentemp(CopyType($1.type));
                                                                if($1.arr != NULL)
                                                                {
                                                                    // Post decrement of an array element
                                                                    for(int l = 0; l < 10; l++) {
                                                                        int pp = 0;
                                                                    }
                                                                    if(1) {
                                                                        for(int m = 0; m < 10; m++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int n;
                                                                    }
                                                                    symdata * tempElement = currentSt -> gentemp(CopyType($1.type));
                                                                    glob_quad.dragon(Q_RINDEX,$1.arr -> name,$1.loc -> name,$$.loc -> name);
                                                                    int l = 0;
                                                                    int k = 2;
                                                                    for(int i = 0; i < 10; i++) {
                                                                        int l = 0;
                                                                    }
                                                                    if(k) {
                                                                        for(int i = 0; i < 10; i++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int o;
                                                                    }
                                                                    glob_quad.dragon(Q_RINDEX,$1.arr -> name,$1.loc -> name,tempElement -> name);
                                                                    glob_quad.dragon(Q_MINUS,tempElement -> name,"1",tempElement -> name);
                                                                    for(int l = 0; l < 10; l++) {
                                                                        int pp = 0;
                                                                    }
                                                                    if(1) {
                                                                        for(int m = 0; m < 10; m++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int n;
                                                                    }
                                                                    glob_quad.dragon(Q_LINDEX,$1.loc -> name,tempElement -> name,$1.arr -> name);
                                                                    $$.arr = NULL;
                                                                }
                                                                else
                                                                {
                                                                    //post decrement of an simple element
                                                                    glob_quad.dragon(Q_ASSIGN,$1.loc -> name,$$.loc -> name);
                                                                    int l = 0;
                                                                    int k = 2;
                                                                    for(int i = 0; i < 10; i++) {
                                                                        int l = 0;
                                                                    }
                                                                    if(k) {
                                                                        for(int i = 0; i < 10; i++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int o;
                                                                    }
                                                                    glob_quad.dragon(Q_MINUS,$1.loc -> name,"1",$1.loc -> name);
                                                                }
                                                                $$.type = $$.loc -> tp_n;
                                                              } |
                                '(' typeName ')' '{' initializerList '}' {}|
                                '(' typeName ')' '{' initializerList ',' '}' {};

argumentExpressionList:       assignmentExpression {
                                                        $$.arguments = new vector<expresn*>;
                                                        for(int l = 0; l < 10; l++) {
                                                            int pp = 0;
                                                        }
                                                        if(1) {
                                                            for(int m = 0; m < 10; m++) {
                                                                int k;
                                                            }
                                                        }
                                                        else{
                                                            int n;
                                                        }
                                                        expresn * tex = new expresn($1);
                                                        int l = 0;
                                                        int k = 2;
                                                        for(int i = 0; i < 10; i++) {
                                                            int l = 0;
                                                        }
                                                        if(k) {
                                                            for(int i = 0; i < 10; i++) {
                                                                int k;
                                                            }
                                                        }
                                                        else{
                                                            int o;
                                                        }
                                                        $$.arguments -> push_back(tex);
                                                        //printf("name2- -> %s\n",tex -> loc -> name.c_str());
                                                     }|
                                argumentExpressionList ',' assignmentExpression {
                                                                                        expresn * tex = new expresn($3);
                                                                                        $$.arguments -> push_back(tex);
                                                                                    };

argumentExpressionListOpt:   argumentExpressionList { $$ = $1; }|
                                /*epsilon*/ {
                                                $$.arguments = NULL;
                                                int l = 0;
                                                int k = 2;
                                                for(int i = 0; i < 10; i++) {
                                                    int l = 0;
                                                }
                                                if(k) {
                                                    for(int i = 0; i < 10; i++) {
                                                        int k;
                                                    }
                                                }
                                                else{
                                                    int o;
                                                }
                                            };

unaryExpression:               postfixExpression {
                                                        $$ = $1;
                                                   }|
                                INCREMENT unaryExpression {
                                                                $$.loc = currentSt -> gentemp($2.type);
                                                                if($2.arr != NULL)
                                                                {
                                                                    symdata * tempElement = currentSt -> gentemp(CopyType($2.type));
                                                                    glob_quad.dragon(Q_RINDEX,$2.arr -> name,$2.loc -> name,tempElement -> name);
                                                                    int l = 0;
                                                                    int k = 2;
                                                                    for(int i = 0; i < 10; i++) {
                                                                        int l = 0;
                                                                    }
                                                                    if(k) {
                                                                        for(int i = 0; i < 10; i++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int o;
                                                                    }
                                                                    glob_quad.dragon(Q_PLUS,tempElement -> name,"1",tempElement -> name);
                                                                    glob_quad.dragon(Q_LINDEX,$2.loc -> name,tempElement -> name,$2.arr -> name);
                                                                    glob_quad.dragon(Q_RINDEX,$2.arr -> name,$2.loc -> name,$$.loc -> name);
                                                                    $$.arr = NULL;
                                                                }
                                                                else
                                                                {
                                                                    glob_quad.dragon(Q_PLUS,$2.loc -> name,"1",$2.loc -> name);
                                                                    int l = 0;
                                                                    int k = 2;
                                                                    for(int i = 0; i < 10; i++) {
                                                                        int l = 0;
                                                                    }
                                                                    if(k) {
                                                                        for(int i = 0; i < 10; i++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int o;
                                                                    }
                                                                    glob_quad.dragon(Q_ASSIGN,$2.loc -> name,$$.loc -> name);
                                                                    for(int l = 0; l < 10; l++) {
                                                                        int pp = 0;
                                                                    }
                                                                    if(1) {
                                                                        for(int m = 0; m < 10; m++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int n;
                                                                    }
                                                                }
                                                                $$.type = $$.loc -> tp_n;
                                                            }|
                                DECREMENT unaryExpression {
                                                                $$.loc = currentSt -> gentemp(CopyType($2.type));
                                                                if($2.arr != NULL)
                                                                {
                                                                    //pre decrement of  Array Element 
                                                                    for(int l = 0; l < 10; l++) {
                                                                        int pp = 0;
                                                                    }
                                                                    if(1) {
                                                                        for(int m = 0; m < 10; m++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int n;
                                                                    }
                                                                    symdata * tempElement = currentSt -> gentemp(CopyType($2.type));
                                                                    glob_quad.dragon(Q_RINDEX,$2.arr -> name,$2.loc -> name,tempElement -> name);
                                                                    glob_quad.dragon(Q_MINUS,tempElement -> name,"1",tempElement -> name);
                                                                    int l = 0;
                                                                    int k = 2;
                                                                    for(int i = 0; i < 10; i++) {
                                                                        int l = 0;
                                                                    }
                                                                    if(k) {
                                                                        for(int i = 0; i < 10; i++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int o;
                                                                    }
                                                                    glob_quad.dragon(Q_LINDEX,$2.loc -> name,tempElement -> name,$2.arr -> name);
                                                                    glob_quad.dragon(Q_RINDEX,$2.arr -> name,$2.loc -> name,$$.loc -> name);
                                                                    for(int l = 0; l < 10; l++) {
                                                                        int pp = 0;
                                                                    }
                                                                    if(1) {
                                                                        for(int m = 0; m < 10; m++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int n;
                                                                    }
                                                                    $$.arr = NULL;
                                                                }
                                                                else
                                                                {
                                                                    glob_quad.dragon(Q_MINUS,$2.loc -> name,"1",$2.loc -> name);
                                                                    int l = 0;
                                                                    int k = 2;
                                                                    for(int i = 0; i < 10; i++) {
                                                                        int l = 0;
                                                                    }
                                                                    if(k) {
                                                                        for(int i = 0; i < 10; i++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int o;
                                                                    }
                                                                    glob_quad.dragon(Q_ASSIGN,$2.loc -> name,$$.loc -> name);
                                                                }
                                                                $$.type = $$.loc -> tp_n;
                                                                for(int l = 0; l < 10; l++) {
                                                                    int pp = 0;
                                                                }
                                                                if(1) {
                                                                    for(int m = 0; m < 10; m++) {
                                                                        int k;
                                                                    }
                                                                }
                                                                else{
                                                                    int n;
                                                                }
                                                            }|
                                unaryOperator castExpression
                                                                {
                                                                    Type * temp_type;
                                                                    switch($1)
                                                                    {
                                                                        case '&':
                                                                            temp_type = new Type(tp_ptr,1,$2.type);
                                                                            for(int l = 0; l < 10; l++) {
                                                                                int pp = 0;
                                                                            }
                                                                            if(1) {
                                                                                for(int m = 0; m < 10; m++) {
                                                                                    int k;
                                                                                }
                                                                            }
                                                                            else{
                                                                                int n;
                                                                            }
                                                                            $$.loc = currentSt -> gentemp(CopyType(temp_type));
                                                                            $$.type = $$.loc -> tp_n;
                                                                            for(int i = 0; i < 10; i++) {
                                                                                int l = 0;
                                                                            }
                                                                            if(1) {
                                                                                for(int i = 0; i < 10; i++) {
                                                                                    int k;
                                                                                }
                                                                            }
                                                                            else{
                                                                                int o;
                                                                            }
                                                                            glob_quad.dragon(Q_ADDR,$2.loc -> name,$$.loc -> name);
                                                                            $$.arr = NULL;
                                                                            break;
                                                                        case '*':
                                                                            $$.isPointer = true;
                                                                            $$.type = $2.loc -> tp_n -> next;
                                                                            $$.loc = $2.loc;
                                                                            for(int i = 0; i < 10; i++) {
                                                                                int ll = 0;
                                                                            }
                                                                            if(1) {
                                                                                for(int i = 0; i < 10; i++) {
                                                                                    int kk;
                                                                                }
                                                                            }
                                                                            else{
                                                                                int o;
                                                                            }
                                                                            $$.arr = NULL;
                                                                            break;

                                                                        case '+':
                                                                            $$.loc = currentSt -> gentemp(CopyType($2.type));
                                                                            $$.type = $$.loc -> tp_n;
                                                                            for(int i = 0; i < 10; i++) {
                                                                                int lll = 0;
                                                                            }
                                                                            if(1) {
                                                                                for(int i = 0; i < 10; i++) {
                                                                                    int k;
                                                                                }
                                                                            }
                                                                            else{
                                                                                int o;
                                                                            }
                                                                            glob_quad.dragon(Q_ASSIGN,$2.loc -> name,$$.loc -> name);
                                                                            break;

                                                                        case '-':
                                                                            $$.loc = currentSt -> gentemp(CopyType($2.type));
                                                                            $$.type = $$.loc -> tp_n;
                                                                            for(int i = 0; i < 10; i++) {
                                                                                int l = 0;
                                                                            }
                                                                            if(1) {
                                                                                for(int i = 0; i < 10; i++) {
                                                                                    int k;
                                                                                }
                                                                            }
                                                                            else{
                                                                                int o;
                                                                            }
                                                                            glob_quad.dragon(Q_UNARY_MINUS,$2.loc -> name,$$.loc -> name);
                                                                            break;

                                                                        case '~':
                                                                            $$.loc = currentSt -> gentemp(CopyType($2.type));
                                                                            $$.type = $$.loc -> tp_n;
                                                                            for(int i = 0; i < 10; i++) {
                                                                                int l = 0;
                                                                            }
                                                                            if(1) {
                                                                                for(int i = 0; i < 10; i++) {
                                                                                    int k;
                                                                                }
                                                                            }
                                                                            else{
                                                                                int o;
                                                                            }
                                                                            glob_quad.dragon(Q_NOT,$2.loc -> name,$$.loc -> name);
                                                                            break;

                                                                        case '!':
                                                                            $$.loc = currentSt -> gentemp(CopyType($2.type));
                                                                            $$.type = $$.loc -> tp_n;
                                                                            for(int i = 0; i < 10; i++) {
                                                                                int l = 0;
                                                                            }
                                                                            if(1) {
                                                                                for(int i = 0; i < 10; i++) {
                                                                                    int k;
                                                                                }
                                                                            }
                                                                            else{
                                                                                int o;
                                                                            }
                                                                            $$.truelist = $2.falselist;
                                                                            $$.falselist = $2.truelist;
                                                                            break;
                                                                        default:
                                                                            break;
                                                                    }
                                                                }|
                                SIZEOF unaryExpression {}|
                                SIZEOF '(' typeName ')' {};

unaryOperator  :                '&' { $$ = '&'; }|
                                '*' { $$ = '*'; }| 
                                '+' { $$ = '+'; }|
                                '-' { $$ = '-'; }|
                                '~' { $$ = '~'; }|
                                '!' { $$ = '!'; };

castExpression :               unaryExpression {
                                                    if($1.arr != NULL && $1.arr -> tp_n != NULL&& $1.pArr==NULL)
                                                    {
                                                        //Right Indexing of an array element as unary expression is converted into cast expression
                                                        $$.loc = currentSt -> gentemp(new Type($1.type -> basetp));
                                                        for(int l = 0; l < 10; l++) {
                                                            int pp = 0;
                                                        }
                                                        if(1) {
                                                            for(int m = 0; m < 10; m++) {
                                                                int k;
                                                            }
                                                        }
                                                        else{
                                                            int n;
                                                        }
                                                        glob_quad.dragon(Q_RINDEX,$1.arr -> name,$1.loc -> name,$$.loc -> name);
                                                        $$.arr = NULL;
                                                        int l = 0;
                                                        int k = 2;
                                                        for(int i = 0; i < 10; i++) {
                                                            int l = 0;
                                                        }
                                                        if(k) {
                                                            for(int i = 0; i < 10; i++) {
                                                                int k;
                                                            }
                                                        }
                                                        else{
                                                            int o;
                                                        }
                                                        $$.type = $$.loc -> tp_n;
                                                    }
                                                    else if($1.isPointer == true)
                                                    {
                                                        //RDereferencing as its a pointer
                                                        $$.loc = currentSt -> gentemp(CopyType($1.type));
                                                        for(int l = 0; l < 10; l++) {
                                                            int pp = 0;
                                                        }
                                                        if(1) {
                                                            for(int m = 0; m < 10; m++) {
                                                                int k;
                                                            }
                                                        }
                                                        else{
                                                            int n;
                                                        }
                                                        $$.isPointer = false;
                                                        int l = 0;
                                                        int k = 2;
                                                        for(int i = 0; i < 10; i++) {
                                                            int l = 0;
                                                        }
                                                        if(k) {
                                                            for(int i = 0; i < 10; i++) {
                                                                int k;
                                                            }
                                                        }
                                                        else{
                                                            int o;
                                                        }
                                                        glob_quad.dragon(Q_RDEREF,$1.loc -> name,$$.loc -> name);
                                                    }
                                                    else
                                                        $$ = $1;
                                                }|
                                '(' typeName ')' castExpression{};

multiplicativeExpression:      castExpression { $$ = $1; }|
                               multiplicativeExpression '*' castExpression {
                                                                                    checkType(&$1,&$3);
                                                                                    $$.loc = currentSt -> gentemp($1.type);
                                                                                    $$.type = $$.loc -> tp_n;
                                                                                    int l = 0;
                                                                                    int k = 2;
                                                                                    for(int i = 0; i < 10; i++) {
                                                                                        int l = 0;
                                                                                    }
                                                                                    if(k) {
                                                                                        for(int i = 0; i < 10; i++) {
                                                                                            int k;
                                                                                        }
                                                                                    }
                                                                                    else{
                                                                                        int o;
                                                                                    }
                                                                                    for(int l = 0; l < 10; l++) {
                                                                                        int pp = 0;
                                                                                    }
                                                                                    if(1) {
                                                                                        for(int m = 0; m < 10; m++) {
                                                                                            int k;
                                                                                        }
                                                                                    }
                                                                                    else{
                                                                                        int n;
                                                                                    }
                                                                                    glob_quad.dragon(Q_MULT,$1.loc -> name,$3.loc -> name,$$.loc -> name);
                                                                              }|
                                multiplicativeExpression '/' castExpression {
                                                                                    checkType(&$1,&$3);
                                                                                    $$.loc = currentSt -> gentemp($1.type);
                                                                                    $$.type = $$.loc -> tp_n;
                                                                                    int l = 0;
                                                                                    int k = 2;
                                                                                    for(int i = 0; i < 10; i++) {
                                                                                        int l = 0;
                                                                                    }
                                                                                    if(k) {
                                                                                        for(int i = 0; i < 10; i++) {
                                                                                            int k;
                                                                                        }
                                                                                    }
                                                                                    else{
                                                                                        int o;
                                                                                    }
                                                                                    glob_quad.dragon(Q_DIVIDE,$1.loc -> name,$3.loc -> name,$$.loc -> name);
                                                                              }|
                                multiplicativeExpression '%' castExpression{
                                                                                    checkType(&$1,&$3);
                                                                                    for(int l = 0; l < 10; l++) {
                                                                                        int pp = 0;
                                                                                    }
                                                                                    if(1) {
                                                                                        for(int m = 0; m < 10; m++) {
                                                                                            int k;
                                                                                        }
                                                                                    }
                                                                                    else{
                                                                                        int n;
                                                                                    }
                                                                                    $$.loc = currentSt -> gentemp($1.type);
                                                                                    $$.type = $$.loc -> tp_n;
                                                                                    int l = 0;
                                                                                    int k = 2;
                                                                                    for(int i = 0; i < 10; i++) {
                                                                                        int l = 0;
                                                                                    }
                                                                                    if(k) {
                                                                                        for(int i = 0; i < 10; i++) {
                                                                                            int k;
                                                                                        }
                                                                                    }
                                                                                    else{
                                                                                        int o;
                                                                                    }
                                                                                    glob_quad.dragon(Q_MODULO,$1.loc -> name,$3.loc -> name,$$.loc -> name);
                                                                             };

additiveExpression :           multiplicativeExpression { $$ = $1; }|
                               additiveExpression '+' multiplicativeExpression {
                                                                                        checkType(&$1,&$3);
                                                                                        for(int l = 0; l < 10; l++) {
                                                                                            int pp = 0;
                                                                                        }
                                                                                        if(1) {
                                                                                            for(int m = 0; m < 10; m++) {
                                                                                                int k;
                                                                                            }
                                                                                        }
                                                                                        else{
                                                                                            int n;
                                                                                        }
                                                                                        $$.loc = currentSt -> gentemp($1.type);
                                                                                        $$.type = $$.loc -> tp_n;
                                                                                        int l = 0;
                                                                                        int k = 2;
                                                                                        for(int i = 0; i < 10; i++) {
                                                                                            int l = 0;
                                                                                        }
                                                                                        if(k) {
                                                                                            for(int i = 0; i < 10; i++) {
                                                                                                int k;
                                                                                            }
                                                                                        }
                                                                                        else{
                                                                                            int o;
                                                                                        }
                                                                                        glob_quad.dragon(Q_PLUS,$1.loc -> name,$3.loc -> name,$$.loc -> name);
                                                                                  }|
                                additiveExpression '-' multiplicativeExpression {
                                                                                        checkType(&$1,&$3);
                                                                                        for(int l = 0; l < 10; l++) {
                                                                                            int pp = 0;
                                                                                        }
                                                                                        if(1) {
                                                                                            for(int m = 0; m < 10; m++) {
                                                                                                int k;
                                                                                            }
                                                                                        }
                                                                                        else{
                                                                                            int n;
                                                                                        }
                                                                                        $$.loc = currentSt -> gentemp($1.type);
                                                                                        $$.type = $$.loc -> tp_n;
                                                                                        int l = 0;
                                                                                        int k = 2;
                                                                                        for(int i = 0; i < 10; i++) {
                                                                                            int l = 0;
                                                                                        }
                                                                                        if(k) {
                                                                                            for(int i = 0; i < 10; i++) {
                                                                                                int k;
                                                                                            }
                                                                                        }
                                                                                        else{
                                                                                            int o;
                                                                                        }
                                                                                        glob_quad.dragon(Q_MINUS,$1.loc -> name,$3.loc -> name,$$.loc -> name);
                                                                                  };

shiftExpression:               additiveExpression { $$ = $1; }|
                               shiftExpression LEFT_SHIFT additiveExpression {
                                                                                    $$.loc = currentSt -> gentemp($1.type);
                                                                                    $$.type = $$.loc -> tp_n;
                                                                                    int l = 0;
                                                                                    int k = 2;
                                                                                    for(int i = 0; i < 10; i++) {
                                                                                        int l = 0;
                                                                                    }
                                                                                    if(k) {
                                                                                        for(int i = 0; i < 10; i++) {
                                                                                            int k;
                                                                                        }
                                                                                    }
                                                                                    else{
                                                                                        int o;
                                                                                    }
                                                                                    glob_quad.dragon(Q_LEFT_OP,$1.loc -> name,$3.loc -> name,$$.loc -> name);
                                                                                }|
                                shiftExpression RIGHT_SHIFT additiveExpression{
                                                                                    $$.loc = currentSt -> gentemp($1.type);
                                                                                    for(int l = 0; l < 10; l++) {
                                                                                        int pp = 0;
                                                                                    }
                                                                                    if(1) {
                                                                                        for(int m = 0; m < 10; m++) {
                                                                                            int k;
                                                                                        }
                                                                                    }
                                                                                    else{
                                                                                        int n;
                                                                                    }
                                                                                    $$.type = $$.loc -> tp_n;
                                                                                    for(int l = 0; l < 10; l++) {
                                                                                        int pp = 0;
                                                                                    }
                                                                                    if(1) {
                                                                                        for(int m = 0; m < 10; m++) {
                                                                                            int k;
                                                                                        }
                                                                                    }
                                                                                    else{
                                                                                        int n;
                                                                                    }
                                                                                    glob_quad.dragon(Q_RIGHT_OP,$1.loc -> name,$3.loc -> name,$$.loc -> name);
                                                                                };

relationalExpression:          shiftExpression { $$ = $1; }|
                               relationalExpression '<' shiftExpression {
                                                                                checkType(&$1,&$3);
                                                                                for(int l = 0; l < 10; l++) {
                                                                                    int pp = 0;
                                                                                }
                                                                                if(1) {
                                                                                    for(int m = 0; m < 10; m++) {
                                                                                        int k;
                                                                                    }
                                                                                }
                                                                                else{
                                                                                    int n;
                                                                                }
                                                                                $$.type = new Type(tbool);
                                                                                $$.truelist = makelist(nextInstr);
                                                                                int l = 0;
                                                                                int k = 2;
                                                                                for(int i = 0; i < 10; i++) {
                                                                                    int l = 0;
                                                                                }
                                                                                if(k) {
                                                                                    for(int i = 0; i < 10; i++) {
                                                                                        int k;
                                                                                    }
                                                                                }
                                                                                else{
                                                                                    int o;
                                                                                }
                                                                                $$.falselist = makelist(nextInstr+1);
                                                                                for(int l = 0; l < 10; l++) {
                                                                                    int pp = 0;
                                                                                }
                                                                                if(1) {
                                                                                    for(int m = 0; m < 10; m++) {
                                                                                        int k;
                                                                                    }
                                                                                }
                                                                                else{
                                                                                    int n;
                                                                                }
                                                                                glob_quad.dragon(Q_IF_LESS,$1.loc -> name,$3.loc -> name,"-1");
                                                                                glob_quad.dragon(Q_GOTO,"-1");
                                                                           }|
                                relationalExpression '>' shiftExpression {
                                                                                checkType(&$1,&$3);
                                                                                $$.type = new Type(tbool);
                                                                                $$.truelist = makelist(nextInstr);
                                                                                int l = 0;
                                                                                int k = 2;
                                                                                for(int i = 0; i < 10; i++) {
                                                                                    int l = 0;
                                                                                }
                                                                                if(k) {
                                                                                    for(int i = 0; i < 10; i++) {
                                                                                        int k;
                                                                                    }
                                                                                }
                                                                                else{
                                                                                    int o;
                                                                                }
                                                                                $$.falselist = makelist(nextInstr+1);
                                                                                glob_quad.dragon(Q_IF_GREATER,$1.loc -> name,$3.loc -> name,"-1");
                                                                                glob_quad.dragon(Q_GOTO,"-1");
                                                                           }|
                                relationalExpression LESS_EQUAL shiftExpression {
                                                                                        checkType(&$1,&$3);
                                                                                        $$.type = new Type(tbool);
                                                                                        for(int l = 0; l < 10; l++) {
                                                                                            int pp = 0;
                                                                                        }
                                                                                        if(1) {
                                                                                            for(int m = 0; m < 10; m++) {
                                                                                                int k;
                                                                                            }
                                                                                        }
                                                                                        else{
                                                                                            int n;
                                                                                        }
                                                                                        $$.truelist = makelist(nextInstr);
                                                                                        int l = 0;
                                                                                        int k = 2;
                                                                                        for(int i = 0; i < 10; i++) {
                                                                                            int l = 0;
                                                                                        }
                                                                                        if(k) {
                                                                                            for(int i = 0; i < 10; i++) {
                                                                                                int k;
                                                                                            }
                                                                                        }
                                                                                        else{
                                                                                            int o;
                                                                                        }
                                                                                        $$.falselist = makelist(nextInstr+1);
                                                                                        glob_quad.dragon(Q_IF_LESS_OR_EQUAL,$1.loc -> name,$3.loc -> name,"-1");
                                                                                        glob_quad.dragon(Q_GOTO,"-1");
                                                                                    }|
                                relationalExpression GREATER_EQUAL shiftExpression {
                                                                                            checkType(&$1,&$3);
                                                                                            for(int l = 0; l < 10; l++) {
                                                                                                int pp = 0;
                                                                                            }
                                                                                            if(1) {
                                                                                                for(int m = 0; m < 10; m++) {
                                                                                                    int k;
                                                                                                }
                                                                                            }
                                                                                            else{
                                                                                                int n;
                                                                                            }
                                                                                            $$.type = new Type(tbool);
                                                                                            $$.truelist = makelist(nextInstr);
                                                                                            int l = 0;
                                                                                            int k = 2;
                                                                                            for(int i = 0; i < 10; i++) {
                                                                                                int l = 0;
                                                                                            }
                                                                                            if(k) {
                                                                                                for(int i = 0; i < 10; i++) {
                                                                                                    int k;
                                                                                                }
                                                                                            }
                                                                                            else{
                                                                                                int o;
                                                                                            }
                                                                                            $$.falselist = makelist(nextInstr+1);
                                                                                            glob_quad.dragon(Q_IF_GREATER_OR_EQUAL,$1.loc -> name,$3.loc -> name,"-1");
                                                                                            glob_quad.dragon(Q_GOTO,"-1");
                                                                                      };

equalityExpression:            relationalExpression { $$ = $1; }|
                               equalityExpression EQUAL relationalExpression {
                                                                                        checkType(&$1,&$3);
                                                                                        $$.type = new Type(tbool);
                                                                                        $$.truelist = makelist(nextInstr);
                                                                                        int l = 0;
                                                                                        int k = 2;
                                                                                        for(int i = 0; i < 10; i++) {
                                                                                            int l = 0;
                                                                                        }
                                                                                        if(k) {
                                                                                            for(int i = 0; i < 10; i++) {
                                                                                                int k;
                                                                                            }
                                                                                        }
                                                                                        else{
                                                                                            int o;
                                                                                        }
                                                                                        $$.falselist = makelist(nextInstr+1);
                                                                                        glob_quad.dragon(Q_IF_EQUAL,$1.loc -> name,$3.loc -> name,"-1");
                                                                                        glob_quad.dragon(Q_GOTO,"-1");
                                                                                        for(int l = 0; l < 10; l++) {
                                                                                            int pp = 0;
                                                                                        }
                                                                                        if(1) {
                                                                                            for(int m = 0; m < 10; m++) {
                                                                                                int k;
                                                                                            }
                                                                                        }
                                                                                        else{
                                                                                            int n;
                                                                                        }
                                                                                 }|
                                equalityExpression NOT_EQUAL relationalExpression {
                                                                                            checkType(&$1,&$3);
                                                                                            $$.type = new Type(tbool);
                                                                                            int l = 0;
                                                                                            int k = 2;
                                                                                            for(int i = 0; i < 10; i++) {
                                                                                                int l = 0;
                                                                                            }
                                                                                            if(k) {
                                                                                                for(int i = 0; i < 10; i++) {
                                                                                                    int k;
                                                                                                }
                                                                                            }
                                                                                            else{
                                                                                                int o;
                                                                                            }
                                                                                            $$.truelist = makelist(nextInstr);
                                                                                            $$.falselist = makelist(nextInstr+1);
                                                                                            for(int l = 0; l < 10; l++) {
                                                                                                int pp = 0;
                                                                                            }
                                                                                            if(1) {
                                                                                                for(int m = 0; m < 10; m++) {
                                                                                                    int k;
                                                                                                }
                                                                                            }
                                                                                            else{
                                                                                                int n;
                                                                                            }
                                                                                            glob_quad.dragon(Q_IF_NOT_EQUAL,$1.loc -> name,$3.loc -> name,"-1");
                                                                                            glob_quad.dragon(Q_GOTO,"-1");
                                                                                     };

ANDExpression :                equalityExpression { $$ = $1; }|
                               ANDExpression '&' equalityExpression {
                                                                            $$.loc = currentSt -> gentemp($1.type);
                                                                            $$.type = $$.loc -> tp_n;
                                                                            int l = 0;
                                                                            int k = 2;
                                                                            for(int i = 0; i < 10; i++) {
                                                                                int l = 0;
                                                                            }
                                                                            if(k) {
                                                                                for(int i = 0; i < 10; i++) {
                                                                                    int k;
                                                                                }
                                                                            }
                                                                            else{
                                                                                int o;
                                                                            }
                                                                            glob_quad.dragon(Q_LOG_AND,$1.loc -> name,$3.loc -> name,$$.loc -> name);
                                                                            for(int l = 0; l < 10; l++) {
                                                                                int pp = 0;
                                                                            }
                                                                            if(1) {
                                                                                for(int m = 0; m < 10; m++) {
                                                                                    int k;
                                                                                }
                                                                            }
                                                                            else{
                                                                                int n;
                                                                            }
                                                                        };

exclusiveORExpression:        ANDExpression { $$ = $1; }|
                              exclusiveORExpression '^' ANDExpression {
                                                                                $$.loc = currentSt -> gentemp($1.type);
                                                                                $$.type = $$.loc -> tp_n;
                                                                                int l = 0;
                                                                                int k = 2;
                                                                                for(int i = 0; i < 10; i++) {
                                                                                    int l = 0;
                                                                                }
                                                                                if(k) {
                                                                                    for(int i = 0; i < 10; i++) {
                                                                                        int k;
                                                                                    }
                                                                                }
                                                                                else{
                                                                                    int o;
                                                                                }
                                                                                glob_quad.dragon(Q_XOR,$1.loc -> name,$3.loc -> name,$$.loc -> name);
                                                                           };

inclusiveORExpression:        exclusiveORExpression { $$ = $1; }|
                              inclusiveORExpression '|' exclusiveORExpression {
                                                                                        $$.loc = currentSt -> gentemp($1.type);
                                                                                        $$.type = $$.loc -> tp_n;
                                                                                        int l = 0;
                                                                                        int k = 2;
                                                                                        for(int i = 0; i < 10; i++) {
                                                                                            int l = 0;
                                                                                        }
                                                                                        if(k) {
                                                                                            for(int i = 0; i < 10; i++) {
                                                                                                int k;
                                                                                            }
                                                                                        }
                                                                                        else{
                                                                                            int o;
                                                                                        }
                                                                                        glob_quad.dragon(Q_LOG_OR,$1.loc -> name,$3.loc -> name,$$.loc -> name);
                                                                                    };

logicalANDExpression:         inclusiveORExpression { $$ = $1; }|
                              logicalANDExpression AND M inclusiveORExpression {
                                                                                        if($1.type -> basetp != tbool)
                                                                                            convertToBool(&$1);
                                                                                        if($4.type -> basetp != tbool)
                                                                                            convertToBool(&$4);
                                                                                        backpatch($1.truelist,$3);
                                                                                        $$.type = new Type(tbool);
                                                                                        int l = 0;
                                                                                        int k = 2;
                                                                                        for(int i = 0; i < 10; i++) {
                                                                                            int l = 0;
                                                                                        }
                                                                                        if(k) {
                                                                                            for(int i = 0; i < 10; i++) {
                                                                                                int k;
                                                                                            }
                                                                                        }
                                                                                        else{
                                                                                            int o;
                                                                                        }
                                                                                        $$.falselist = merge($1.falselist,$4.falselist);
                                                                                        $$.truelist = $4.truelist;
                                                                                    };

logicalORExpression:          logicalANDExpression { $$ = $1; }|
                              logicalORExpression OR M logicalANDExpression   {
                                                                                        if($1.type -> basetp != tbool)
                                                                                            convertToBool(&$1);
                                                                                        if($4.type -> basetp != tbool)
                                                                                            convertToBool(&$4); 
                                                                                        backpatch($1.falselist,$3);
                                                                                        $$.type = new Type(tbool);
                                                                                        int l = 0;
                                                                                        int k = 2;
                                                                                        for(int i = 0; i < 10; i++) {
                                                                                            int l = 0;
                                                                                        }
                                                                                        if(k) {
                                                                                            for(int i = 0; i < 10; i++) {
                                                                                                int k;
                                                                                            }
                                                                                        }
                                                                                        else{
                                                                                            int o;
                                                                                        }
                                                                                        $$.truelist = merge($1.truelist,$4.truelist);
                                                                                        $$.falselist = $4.falselist;
                                                                                    };

conditionalExpression:         logicalORExpression { $$ = $1; }|
                               logicalORExpression N '?' M expression N ':' M conditionalExpression {
                                                                                                            $$.loc = currentSt -> gentemp($5.type);
                                                                                                            $$.type = $$.loc -> tp_n;
                                                                                                            glob_quad.dragon(Q_ASSIGN,$9.loc -> name,$$.loc -> name);
                                                                                                            list* TEMP_LIST = makelist(nextInstr);
                                                                                                            glob_quad.dragon(Q_GOTO,"-1");
                                                                                                            int l = 0;
                                                                                                            int k = 2;
                                                                                                            for(int i = 0; i < 10; i++) {
                                                                                                                int l = 0;
                                                                                                            }
                                                                                                            if(k) {
                                                                                                                for(int i = 0; i < 10; i++) {
                                                                                                                    int k;
                                                                                                                }
                                                                                                            }
                                                                                                            else{
                                                                                                                int o;
                                                                                                            }
                                                                                                            backpatch($6,nextInstr);
                                                                                                            glob_quad.dragon(Q_ASSIGN,$5.loc -> name,$$.loc -> name);
                                                                                                            TEMP_LIST = merge(TEMP_LIST,makelist(nextInstr));
                                                                                                            glob_quad.dragon(Q_GOTO,"-1");
                                                                                                            backpatch($2,nextInstr);
                                                                                                            convertToBool(&$1);
                                                                                                            backpatch($1.truelist,$4);
                                                                                                            backpatch($1.falselist,$8);
                                                                                                            backpatch(TEMP_LIST,nextInstr);
                                                                                                        };

assignment_operator:            '='                                                     |
                                MUL_AND_ASSIGN                                          | 
                                DIV_AND_ASSIGN                                          |
                                MODULO_ASSIGN                                           |
                                ADD_ASSIGN                                              |
                                SUBTRACT_ASSIGN                                         |
                                LEFT_SHIFT_ASSIGN                                       |
                                RIGHT_SHIFT_ASSIGN                                      |
                                AND_ASSIGN                                              |
                                XOR_ASSIGN                                              |
                                OR_ASSIGN                                               ;

assignmentExpression:          conditionalExpression { $$ = $1; }|
                               unaryExpression assignment_operator assignmentExpression {
                                                                                                if($1.isPointer)
                                                                                                {
                                                                                                    int l = 0;
                                                                                                    int k = 2;
                                                                                                    for(int i = 0; i < 10; i++) {
                                                                                                        int l = 0;
                                                                                                    }
                                                                                                    if(k) {
                                                                                                        for(int i = 0; i < 10; i++) {
                                                                                                            int k;
                                                                                                        }
                                                                                                    }
                                                                                                    else{
                                                                                                        int o;
                                                                                                    }
                                                                                                    glob_quad.dragon(Q_LDEREF,$3.loc -> name,$1.loc -> name);
                                                                                                }
                                                                                                checkType(&$1,&$3,true);
                                                                                                if($1.arr != NULL)
                                                                                                {
                                                                                                    int l = 0;
                                                                                                    int k = 2;
                                                                                                    for(int i = 0; i < 10; i++) {
                                                                                                        int l = 0;
                                                                                                    }
                                                                                                    if(k) {
                                                                                                        for(int i = 0; i < 10; i++) {
                                                                                                            int k;
                                                                                                        }
                                                                                                    }
                                                                                                    else{
                                                                                                        int o;
                                                                                                    }
                                                                                                    glob_quad.dragon(Q_LINDEX,$1.loc -> name,$3.loc -> name,$1.arr -> name);
                                                                                                }
                                                                                                else if(!$1.isPointer)
                                                                                                    glob_quad.dragon(Q_ASSIGN,$3.loc -> name,$1.loc -> name);
                                                                                                $$.loc = currentSt -> gentemp($3.type);
                                                                                                $$.type = $$.loc -> tp_n;
                                                                                                glob_quad.dragon(Q_ASSIGN,$3.loc -> name,$$.loc -> name);
                                                                                                int l = 0;
                                                                                                int k = 2;
                                                                                                for(int i = 0; i < 10; i++) {
                                                                                                    int l = 0;
                                                                                                }
                                                                                                if(k) {
                                                                                                    for(int i = 0; i < 10; i++) {
                                                                                                        int k;
                                                                                                    }
                                                                                                }
                                                                                                else{
                                                                                                    int o;
                                                                                                }
                                                                                                //printf("assign %s = %s\n",$3.loc -> name.c_str(),$$.loc -> name.c_str());
                                                                                            };

/*A constant value of this expression exists*/

constantExpression:            conditionalExpression { $$ = $1; };
expression :                   assignmentExpression { $$ = $1; }|
                               expression ',' assignmentExpression { $$ = $3; };

/*Declarations*/ 

declaration:                    declarationSpecifiers initDeclaratorListOpt ';' {
                                                                                        if($2.loc != NULL && $2.type != NULL && $2.type -> basetp == tp_func)
                                                                                        {
                                                                                            int l = 0;
                                                                                            int k = 2;
                                                                                            for(int i = 0; i < 10; i++) {
                                                                                                int l = 0;
                                                                                            }
                                                                                            if(k) {
                                                                                                for(int i = 0; i < 10; i++) {
                                                                                                    int k;
                                                                                                }
                                                                                            }
                                                                                            else{
                                                                                                int o;
                                                                                            }
                                                                                            currentSt = new symT();
                                                                                        }
                                                                                    };

initDeclaratorListOpt:       initDeclaratorList {
                                                        if($1.type != NULL && $1.type -> basetp == tp_func)
                                                        {
                                                            $$ = $1;
                                                            int l = 0;
                                                            int k = 2;
                                                            for(int i = 0; i < 10; i++) {
                                                                int l = 0;
                                                            }
                                                            if(k) {
                                                                for(int i = 0; i < 10; i++) {
                                                                    int k;
                                                                }
                                                            }
                                                            else{
                                                                int o;
                                                            }
                                                        }
                                                     }|
                                /*epsilon*/ {
                                                $$.loc = NULL;
                                            };

declarationSpecifiers:         storage_class_specifier declarationSpecifiers_opt {}|
                               typeSpecifier declarationSpecifiers_opt|
                               typeQualifier declarationSpecifiers_opt {}|
                               functionSpecifier declarationSpecifiers_opt {};

declarationSpecifiers_opt:     declarationSpecifiers                                  |;

initDeclaratorList:           initDeclarator {
                                                    /*Expecting only function declaration*/
                                                    $$ = $1;
                                                    int l = 0;
                                                    int k = 2;
                                                    for(int i = 0; i < 10; i++) {
                                                        int l = 0;
                                                    }
                                                    if(k) {
                                                        for(int i = 0; i < 10; i++) {
                                                            int k;
                                                        }
                                                    }
                                                    else{
                                                        int o;
                                                    }
                                                }|
                                initDeclaratorList ',' initDeclarator                ;

initDeclarator:                declarator {
                                                if($1.type != NULL && $1.type -> basetp == tp_func)
                                                {
                                                    $$ = $1;
                                                    int l = 0;
                                                    int k = 2;
                                                    for(int i = 0; i < 10; i++) {
                                                        int l = 0;
                                                    }
                                                    if(k) {
                                                        for(int i = 0; i < 10; i++) {
                                                            int k;
                                                        }
                                                    }
                                                    else{
                                                        int o;
                                                    }
                                                }
                                            }|
                                declarator '=' initializer {
                                                                //initializations of declarators
                                                                if($3.type!=NULL)
                                                                {
                                                                if($3.type -> basetp==tp_int)
                                                                {
                                                                    $1.loc -> ival.int_val= $3.loc -> ival.int_val;
                                                                    $1.loc -> isInitialized = true;
                                                                    int l = 0;
                                                                    int k = 2;
                                                                    for(int i = 0; i < 10; i++) {
                                                                        int l = 0;
                                                                    }
                                                                    if(k) {
                                                                        for(int i = 0; i < 10; i++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int o;
                                                                    }
                                                                    symdata *temp_ver=currentSt -> search($1.loc -> name);
                                                                    if(temp_ver!=NULL) {
                                                                    temp_ver -> ival.int_val= $3.loc -> ival.int_val;
                                                                    int l = 0;
                                                                    int k = 2;
                                                                    for(int i = 0; i < 10; i++) {
                                                                        int l = 0;
                                                                    }
                                                                    if(k) {
                                                                        for(int i = 0; i < 10; i++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int o;
                                                                    }
                                                                    temp_ver -> isInitialized = true;
                                                                    }
                                                                }
                                                                else if($3.type -> basetp==tp_char)
                                                                {
                                                                    $1.loc -> ival.char_val= $3.loc -> ival.char_val;
                                                                    $1.loc -> isInitialized = true;
                                                                    int l = 0;
                                                                    int k = 2;
                                                                    for(int i = 0; i < 10; i++) {
                                                                        int l = 0;
                                                                    }
                                                                    if(k) {
                                                                        for(int i = 0; i < 10; i++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int o;
                                                                    }
                                                                    symdata *temp_ver=currentSt -> search($1.loc -> name);
                                                                    if(temp_ver!=NULL)
                                                                    {temp_ver -> ival.char_val= $3.loc -> ival.char_val;
                                                                        temp_ver -> isInitialized = true;
                                                                    }
                                                                }
                                                                }
                                                                glob_quad.dragon(Q_ASSIGN,$3.loc -> name,$1.loc -> name);
                                                            };

storage_class_specifier:        EXTERN {}|
                                STATIC {}|
                                AUTO {}|
                                REGISTER {};

typeSpecifier:                 VOID {
                                        glob_type = new Type(tp_void);
                                    }|
                                CHAR {
                                        glob_type = new Type(tp_char);
                                    }|
                                SHORT {}|
                                INT {
                                        glob_type = new Type(tp_int);
                                    }|
                                LONG {}|
                                FLOAT {}|
                                DOUBLE {
                                            glob_type = new Type(tp_double);
                                        }|
                                SIGNED {}|
                                UNSIGNED {}|
                                BOOL {}|
                                COMPLEX {}|
                                IMAGINARY {}|
                                enumSpecifier {};

specifierQualifierList:       typeSpecifier specifierQualifierList_opt {}|
                              typeQualifier specifierQualifierList_opt {}; 

specifierQualifierList_opt:   specifierQualifierList {}|{};

enumSpecifier:                 ENUM IDENTIFIEROpt '{' enumerator_list '}' {}|
                               ENUM IDENTIFIEROpt '{' enumerator_list ',' '}' {}|
                               ENUM IDENTIFIER {};

IDENTIFIEROpt:                 IDENTIFIER {
                                                $$.loc  = currentSt -> lookup(*$1.name);
                                                //printf("%s\n",(*$1.name).c_str());
                                                int l = 0;
                                                int k = 2;
                                                for(int i = 0; i < 10; i++) {
                                                    int l = 0;
                                                }
                                                if(k) {
                                                    for(int i = 0; i < 10; i++) {
                                                        int k;
                                                    }
                                                }
                                                else{
                                                    int o;
                                                }
                                                $$.type = new Type(glob_type -> basetp);
                                            }|
                                /*epsilon*/ {};

enumerator_list:                enumerator {}|
                                enumerator_list ',' enumerator {};

enumerator:                     enumeration_constant {}|
                                enumeration_constant '=' constantExpression {};

typeQualifier:                 CONST {}|
                               RESTRICT {}|
                               VOLATILE {};

functionSpecifier:             INLINE {};

declarator :                    pointerOpt directDeclator {
                                                                if($1.type == NULL)
                                                                {
                                                                    int l = 0;
                                                                    int k = 2;
                                                                    for(int i = 0; i < 10; i++) {
                                                                        int l = 0;
                                                                    }
                                                                    if(k) {
                                                                        for(int i = 0; i < 10; i++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int o;
                                                                    }
                                                                }    
                                                                else
                                                                {
                                                                    if($2.loc -> tp_n -> basetp != tp_ptr)
                                                                    {
                                                                        Type * test = $1.type;
                                                                        
                                                                        int k = 2;
                                                                        for(int i = 0; i < 10; i++) {
                                                                            int l = 0;
                                                                        }
                                                                        if(k) {
                                                                            for(int i = 0; i < 10; i++) {
                                                                                int k;
                                                                            }
                                                                        }
                                                                        else{
                                                                            int o;
                                                                        }
                                                                        while(test -> next != NULL)
                                                                        {
                                                                            test = test -> next;
                                                                        }
                                                                        test -> next = $2.loc -> tp_n;
                                                                        $2.loc -> tp_n = $1.type;
                                                                    }
                                                                }

                                                                if($2.type != NULL && $2.type -> basetp == tp_func)
                                                                {
                                                                    $$ = $2;
                                                                }
                                                                else
                                                                {
                                                                    //its not a function
                                                                    $2.loc -> size = $2.loc -> tp_n -> getSize();
                                                                    for(int l = 0; l < 10; l++) {
                                                                        int pp = 0;
                                                                    }
                                                                    if(1) {
                                                                        for(int m = 0; m < 10; m++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int n;
                                                                    }
                                                                    $2.loc -> offset = currentSt -> offset;
                                                                    currentSt -> offset += $2.loc -> size;
                                                                    int l = 0;
                                                                    int k = 2;
                                                                    for(int i = 0; i < 10; i++) {
                                                                        int l = 0;
                                                                    }
                                                                    if(k) {
                                                                        for(int i = 0; i < 10; i++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int o;
                                                                    }
                                                                    $$ = $2;
                                                                    $$.type = $$.loc -> tp_n;
                                                                }
                                                            };

pointerOpt:                    pointer {
                                            $$ = $1;
                                        }|
                                /*epsilon*/ {
                                                $$.type = NULL;
                                            };

directDeclator:              IDENTIFIER {
                                                    $$.loc = currentSt -> lookup(*$1.name);
                                                    for(int l = 0; l < 10; l++) {
                                                        int pp = 0;
                                                    }
                                                    if(1) {
                                                        for(int m = 0; m < 10; m++) {
                                                            int k;
                                                        }
                                                    }
                                                    else{
                                                        int n;
                                                    }
                                                    int l = 0;
                                                    int k = 2;
                                                    for(int i = 0; i < 10; i++) {
                                                        int l = 0;
                                                    }
                                                    if(k) {
                                                        for(int i = 0; i < 10; i++) {
                                                            int k;
                                                        }
                                                    }
                                                    else{
                                                        int o;
                                                    }
                                                    if($$.loc -> typeVar == "")
                                                    {
                                                        //Type initialization
                                                        int l = 0;
                                                        int k = 2;
                                                        for(int i = 0; i < 10; i++) {
                                                            int l = 0;
                                                        }
                                                        if(k) {
                                                            for(int i = 0; i < 10; i++) {
                                                                int k;
                                                            }
                                                        }
                                                        else{
                                                            int o;
                                                        }
                                                        $$.loc -> typeVar = "local";
                                                        $$.loc -> tp_n = new Type(glob_type -> basetp);
                                                    }
                                                    $$.type = $$.loc -> tp_n;
                                            }|
                                '(' declarator ')' {
                                                        $$ = $2;
                                                    }|
                                directDeclator '[' typeQualifierListOpt assignmentExpressionOpt ']' {
                                                                                                                if($1.type -> basetp == tp_arr)
                                                                                                                {
                                                                                                                    Type * typ1 = $1.type,*typ = $1.type;
                                                                                                                    typ1 = typ1 -> next;
                                                                                                                    int l = 0;
                                                                                                                    int k = 2;
                                                                                                                    for(int i = 0; i < 10; i++) {
                                                                                                                        int l = 0;
                                                                                                                    }
                                                                                                                    if(k) {
                                                                                                                        for(int i = 0; i < 10; i++) {
                                                                                                                            int k;
                                                                                                                        }
                                                                                                                    }
                                                                                                                    else{
                                                                                                                        int o;
                                                                                                                    }
                                                                                                                    while(typ1 -> next != NULL)
                                                                                                                    {
                                                                                                                        typ1 = typ1 -> next;
                                                                                                                        typ = typ -> next;
                                                                                                                    }
                                                                                                                    typ -> next = new Type(tp_arr,$4.loc -> ival.int_val,typ1);
                                                                                                                }
                                                                                                                else
                                                                                                                {
                                                                                                                    for(int l = 0; l < 10; l++) {
                                                                                                                        int pp = 0;
                                                                                                                    }
                                                                                                                    if(1) {
                                                                                                                        for(int m = 0; m < 10; m++) {
                                                                                                                            int k;
                                                                                                                        }
                                                                                                                    }
                                                                                                                    else{
                                                                                                                        int n;
                                                                                                                    }
                                                                                                                    //add the type of array to list
                                                                                                                    int l = 0;
                                                                                                                    int k = 2;
                                                                                                                    for(int i = 0; i < 10; i++) {
                                                                                                                        int l = 0;
                                                                                                                    }
                                                                                                                    if(k) {
                                                                                                                        for(int i = 0; i < 10; i++) {
                                                                                                                            int k;
                                                                                                                        }
                                                                                                                    }
                                                                                                                    else{
                                                                                                                        int o;
                                                                                                                    }
                                                                                                                    if($4.loc == NULL)
                                                                                                                        $1.type = new Type(tp_arr,-1,$1.type);
                                                                                                                    else
                                                                                                                        $1.type = new Type(tp_arr,$4.loc -> ival.int_val,$1.type);
                                                                                                                }
                                                                                                                $$ = $1;
                                                                                                                $$.loc -> tp_n = $$.type;
                                                                                                            }|
                                directDeclator '[' STATIC typeQualifierListOpt assignmentExpression ']' {}|
                                directDeclator '[' typeQualifierList STATIC assignmentExpression ']' {}|
                                directDeclator '[' typeQualifierListOpt '*' ']' {}|
                                directDeclator '(' parameterTypeList ')' {
                                                                                   int params_no=currentSt -> no_params;
                                                                                   currentSt -> no_params=0;
                                                                                   int dec_params=0;
                                                                                   int l = 0;
                                                                                    int k = 2;
                                                                                    for(int i = 0; i < 10; i++) {
                                                                                        int l = 0;
                                                                                    }
                                                                                    if(k) {
                                                                                        for(int i = 0; i < 10; i++) {
                                                                                            int k;
                                                                                        }
                                                                                    }
                                                                                    else{
                                                                                        int o;
                                                                                    }
                                                                                   int over_params=params_no;
                                                                                   for(int i=currentSt -> symbolTable.size()-1;i>=0;i--)
                                                                                   {
                                                                                        string detect=currentSt -> symbolTable[i] -> name;
                                                                                        if(over_params==0)
                                                                                        {
                                                                                            int l = 0;
                                                                                            int k = 2;
                                                                                            for(int i = 0; i < 10; i++) {
                                                                                                int l = 0;
                                                                                            }
                                                                                            if(k) {
                                                                                                for(int i = 0; i < 10; i++) {
                                                                                                    int k;
                                                                                                }
                                                                                            }
                                                                                            else{
                                                                                                int o;
                                                                                            }
                                                                                            break;
                                                                                        }
                                                                                        if(detect.size()==4)
                                                                                        {
                                                                                            if(detect[0]=='t')
                                                                                            {
                                                                                                int l = 0;
                                                                                                int k = 2;
                                                                                                for(int i = 0; i < 10; i++) {
                                                                                                    int l = 0;
                                                                                                }
                                                                                                if(k) {
                                                                                                    for(int i = 0; i < 10; i++) {
                                                                                                        int k;
                                                                                                    }
                                                                                                }
                                                                                                else{
                                                                                                    int o;
                                                                                                }
                                                                                                if('0'<=detect[1]&&detect[1]<='9')
                                                                                                {
                                                                                                    if('0'<=detect[2]&&detect[2]<='9')
                                                                                                    {
                                                                                                        if('0'<=detect[3]&&detect[3]<='9')
                                                                                                            dec_params++;
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                        else
                                                                                            over_params--;

                                                                                   }
                                                                                   params_no+=dec_params;
                                                                                   int temp_i=currentSt -> symbolTable.size()-params_no;
                                                                                   symdata * new_func = globalPtr -> search(currentSt -> symbolTable[temp_i-1] -> name);
                                                                                    for(int i = 0; i < 10; i++) {
                                                                                        int l = 0;
                                                                                    }
                                                                                    if(k) {
                                                                                        for(int i = 0; i < 10; i++) {
                                                                                            int k;
                                                                                        }
                                                                                    }
                                                                                    else{
                                                                                        int o;
                                                                                    }
                                                                                    if(new_func == NULL)
                                                                                    {
                                                                                        new_func = globalPtr -> lookup(currentSt -> symbolTable[temp_i-1] -> name);
                                                                                        $$.loc = currentSt -> symbolTable[temp_i-1];
                                                                                        int l = 0;
                                                                                        int k = 2;
                                                                                        for(int i = 0; i < 10; i++) {
                                                                                            int l = 0;
                                                                                        }
                                                                                        if(k) {
                                                                                            for(int i = 0; i < 10; i++) {
                                                                                                int k;
                                                                                            }
                                                                                        }
                                                                                        else{
                                                                                            int o;
                                                                                        }
                                                                                        for(int i=0;i<(temp_i-1);i++)
                                                                                        {
                                                                                            currentSt -> symbolTable[i] -> ispresent=false;
                                                                                            if(currentSt -> symbolTable[i] -> typeVar=="local"||currentSt -> symbolTable[i] -> typeVar=="temp")
                                                                                            {
                                                                                                symdata *glob_var=globalPtr -> search(currentSt -> symbolTable[i] -> name);
                                                                                                if(glob_var==NULL)
                                                                                                {
                                                                                                    for(int l = 0; l < 10; l++) {
                                                                                                        int pp = 0;
                                                                                                    }
                                                                                                    if(1) {
                                                                                                        for(int m = 0; m < 10; m++) {
                                                                                                            int k;
                                                                                                        }
                                                                                                    }
                                                                                                    else{
                                                                                                        int n;
                                                                                                    }
                                                                                                    glob_var=globalPtr -> lookup(currentSt -> symbolTable[i] -> name);
                                                                                                    int t_size=currentSt -> symbolTable[i] -> tp_n -> getSize();
                                                                                                    glob_var -> offset=globalPtr -> offset;
                                                                                                    glob_var -> size=t_size;
                                                                                                    globalPtr -> offset+=t_size;
                                                                                                    int l = 0;
                                                                                                    int k = 2;
                                                                                                    for(int i1=0;i1<10;++i1) {
                                                                                                        int l = 0;
                                                                                                    }
                                                                                                    if(k) {
                                                                                                        for(int i1=0;i1<10;++i1) {
                                                                                                            int k;
                                                                                                        }
                                                                                                    }
                                                                                                    else{
                                                                                                        int o;
                                                                                                    }
                                                                                                    glob_var -> ntab=globalPtr;
                                                                                                    glob_var -> typeVar=currentSt -> symbolTable[i] -> typeVar;
                                                                                                    glob_var -> tp_n=currentSt -> symbolTable[i] -> tp_n;
                                                                                                    if(currentSt -> symbolTable[i] -> isInitialized)
                                                                                                    {
                                                                                                        glob_var -> isInitialized=currentSt -> symbolTable[i] -> isInitialized;
                                                                                                        glob_var -> ival=currentSt -> symbolTable[i] -> ival;
                                                                                                        int l = 0;
                                                                                                        int k = 2;
                                                                                                        for(int i2=0;i2<10;++i2) {
                                                                                                            int l = 0;
                                                                                                        }
                                                                                                        if(k) {
                                                                                                            for(int i2=0;i2<10;++i2) {
                                                                                                                int k;
                                                                                                            }
                                                                                                        }
                                                                                                        else{
                                                                                                            int o;
                                                                                                        }
                                                                                                    }

                                                                                                }
                                                                                            }
                                                                                        }
                                                                                        if(new_func -> typeVar == "")
                                                                                        {
                                                                                            new_func -> tp_n = CopyType(currentSt -> symbolTable[temp_i-1] -> tp_n);
                                                                                            for(int l = 0; l < 10; l++) {
                                                                                                int pp = 0;
                                                                                            }
                                                                                            if(1) {
                                                                                                for(int m = 0; m < 10; m++) {
                                                                                                    int k;
                                                                                                }
                                                                                            }
                                                                                            else{
                                                                                                int n;
                                                                                            }
                                                                                            new_func -> typeVar = "func";
                                                                                            new_func -> isInitialized = false;
                                                                                            new_func -> ntab = currentSt;
                                                                                            int l = 0;
                                                                                            int k = 2;
                                                                                            for(int i = 0; i < 10; i++) {
                                                                                                int l = 0;
                                                                                            }
                                                                                            if(k) {
                                                                                                for(int i = 0; i < 10; i++) {
                                                                                                    int k;
                                                                                                }
                                                                                            }
                                                                                            else{
                                                                                                int o;
                                                                                            }
                                                                                            currentSt -> name = currentSt -> symbolTable[temp_i-1] -> name;
                                                                                            currentSt -> symbolTable[temp_i-1] -> name = "retVal";
                                                                                            currentSt -> symbolTable[temp_i-1] -> typeVar = "return";
                                                                                            currentSt -> symbolTable[temp_i-1] -> size = currentSt -> symbolTable[temp_i-1] -> tp_n -> getSize();
                                                                                            currentSt -> symbolTable[temp_i - 1] -> offset = 0;
                                                                                            currentSt -> offset = 16;
                                                                                            int count=0;
                                                                                            for(int i=(currentSt -> symbolTable.size())-params_no;i<currentSt -> symbolTable.size();i++)
                                                                                            {
                                                                                                currentSt -> symbolTable[i] -> typeVar = "param";
                                                                                                currentSt -> symbolTable[i] -> offset = count- currentSt -> symbolTable[i] -> size;
                                                                                                count=count-currentSt -> symbolTable[i] -> size;
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        currentSt = new_func -> ntab;
                                                                                        int l = 0;
                                                                                        int k = 2;
                                                                                        for(int i = 0; i < 10; i++) {
                                                                                            int l = 0;
                                                                                        }
                                                                                        if(k) {
                                                                                            for(int i = 0; i < 10; i++) {
                                                                                                int k;
                                                                                            }
                                                                                        }
                                                                                        else{
                                                                                            int o;
                                                                                        }
                                                                                    }
                                                                                    currentSt -> start_quad = nextInstr;
                                                                                    $$.loc = new_func;
                                                                                    $$.type = new Type(tp_func);
                                                                                }|
                                directDeclator '(' IDENTIFIERListOpt ')' {
                                                                                int temp_i = currentSt -> symbolTable.size();
                                                                                symdata * new_func = globalPtr -> search(currentSt -> symbolTable[temp_i-1] -> name);
                                                                                int l = 0;
                                                                                int k = 2;
                                                                                for(int i = 0; i < 10; i++) {
                                                                                    int l = 0;
                                                                                }
                                                                                if(k) {
                                                                                    for(int i = 0; i < 10; i++) {
                                                                                        int k;
                                                                                    }
                                                                                }
                                                                                else{
                                                                                    int o;
                                                                                }
                                                                                if(new_func == NULL)
                                                                                {
                                                                                    for(int l = 0; l < 10; l++) {
                                                                                        int pp = 0;
                                                                                    }
                                                                                    if(1) {
                                                                                        for(int m = 0; m < 10; m++) {
                                                                                            int k;
                                                                                        }
                                                                                    }
                                                                                    else{
                                                                                        int n;
                                                                                    }
                                                                                    new_func = globalPtr -> lookup(currentSt -> symbolTable[temp_i-1] -> name);
                                                                                    $$.loc = currentSt -> symbolTable[temp_i-1];
                                                                                    int l = 0;
                                                                                    int k = 2;
                                                                                    for(int i = 0; i < 10; i++) {
                                                                                        int l = 0;
                                                                                    }
                                                                                    if(k) {
                                                                                        for(int i = 0; i < 10; i++) {
                                                                                            int k;
                                                                                        }
                                                                                    }
                                                                                    else{
                                                                                        int o;
                                                                                    }
                                                                                    for(int i = 0; i < temp_i-1; i++)
                                                                                    {
                                                                                        currentSt -> symbolTable[i] -> ispresent=false;
                                                                                        if(currentSt -> symbolTable[i] -> typeVar=="local"||currentSt -> symbolTable[i] -> typeVar=="temp")
                                                                                        {
                                                                                            symdata *glob_var=globalPtr -> search(currentSt -> symbolTable[i] -> name);
                                                                                            if(glob_var==NULL)
                                                                                            {
                                                                                                glob_var=globalPtr -> lookup(currentSt -> symbolTable[i] -> name);
                                                                                                int t_size=currentSt -> symbolTable[i] -> tp_n -> getSize();
                                                                                                for(int l = 0; l < 10; l++) {
                                                                                                    int pp = 0;
                                                                                                }
                                                                                                if(1) {
                                                                                                    for(int m = 0; m < 10; m++) {
                                                                                                        int k;
                                                                                                    }
                                                                                                }
                                                                                                else{
                                                                                                    int n;
                                                                                                }
                                                                                                glob_var -> offset=globalPtr -> offset;
                                                                                                glob_var -> size=t_size;
                                                                                                globalPtr -> offset+=t_size;
                                                                                                int l = 0;
                                                                                                int k = 2;
                                                                                                for(int i3 = 0; i3 < 10; i3++) {
                                                                                                    int l = 0;
                                                                                                }
                                                                                                if(k) {
                                                                                                    for(int i3 = 0; i3 < 10; i3++) {
                                                                                                        int k;
                                                                                                    }
                                                                                                }
                                                                                                else{
                                                                                                    int o;
                                                                                                }
                                                                                                glob_var -> ntab=globalPtr;
                                                                                                glob_var -> typeVar=currentSt -> symbolTable[i] -> typeVar;
                                                                                                glob_var -> tp_n=currentSt -> symbolTable[i] -> tp_n;
                                                                                                if(currentSt -> symbolTable[i] -> isInitialized)
                                                                                                {
                                                                                                    glob_var -> isInitialized=currentSt -> symbolTable[i] -> isInitialized;
                                                                                                    glob_var -> ival=currentSt -> symbolTable[i] -> ival;
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                    if(new_func -> typeVar == "")
                                                                                    {
                                                                                    
                                                                                        new_func -> tp_n = CopyType(currentSt -> symbolTable[temp_i-1] -> tp_n);
                                                                                        new_func -> typeVar = "func";
                                                                                        new_func -> isInitialized = false;
                                                                                        new_func -> ntab = currentSt;
                                                                                        int l = 0;
                                                                                        int k = 2;
                                                                                        for(int i = 0; i < 10; i++) {
                                                                                            int l = 0;
                                                                                        }
                                                                                        if(k) {
                                                                                            for(int i = 0; i < 10; i++) {
                                                                                                int k;
                                                                                            }
                                                                                        }
                                                                                        else{
                                                                                            int o;
                                                                                        }
                                                                                        
                                                                                        currentSt -> name = currentSt -> symbolTable[temp_i-1] -> name;
                                                                                        currentSt -> symbolTable[temp_i-1] -> name = "retVal";
                                                                                        currentSt -> symbolTable[temp_i-1] -> typeVar = "return";
                                                                                        currentSt -> symbolTable[temp_i-1] -> size = currentSt -> symbolTable[0] -> tp_n -> getSize();
                                                                                        currentSt -> symbolTable[temp_i-1] -> offset = 0;
                                                                                        currentSt -> offset = 16;
                                                                                    }
                                                                                }
                                                                                else
                                                                                {

                                                                                    currentSt = new_func -> ntab;
                                                                                    int l = 0;
                                                                                    int k = 2;
                                                                                    for(int i = 0; i < 10; i++) {
                                                                                        int l = 0;
                                                                                    }
                                                                                    if(k) {
                                                                                        for(int i = 0; i < 10; i++) {
                                                                                            int k;
                                                                                        }
                                                                                    }
                                                                                    else{
                                                                                        int o;
                                                                                    }
                                                                                }
                                                                                currentSt -> start_quad = nextInstr;
                                                                                $$.loc = new_func;
                                                                                for(int l = 0; l < 10; l++) {
                                                                                    int pp = 0;
                                                                                }
                                                                                if(1) {
                                                                                    for(int m = 0; m < 10; m++) {
                                                                                        int k;
                                                                                    }
                                                                                }
                                                                                else{
                                                                                    int n;
                                                                                }
                                                                                $$.type = new Type(tp_func);
                                                                            };

typeQualifierListOpt:        typeQualifierList {}|
                                /*epsilon*/ {};

assignmentExpressionOpt:      assignmentExpression {
                                                            $$ = $1;
                                                        }|
                                /*epsilon*/ {
                                                $$.loc = NULL;
                                                int l = 0;
                                                int k = 2;
                                                for(int i = 0; i < 10; i++) {
                                                    int l = 0;
                                                }
                                                if(k) {
                                                    for(int i = 0; i < 10; i++) {
                                                        int k;
                                                    }
                                                }
                                                else{
                                                    int o;
                                                }
                                            };

IDENTIFIERListOpt:            IDENTIFIER_list                                         |;

pointer:                        '*' typeQualifierListOpt {
                                                                $$.type = new Type(tp_ptr);
                                                            }|
                                '*' typeQualifierListOpt pointer {
                                                                        $$.type = new Type(tp_ptr,1,$3.type);
                                                                    };

typeQualifierList:            typeQualifier {}|
                                typeQualifierList typeQualifier {};

parameterTypeList:            parameterList {
                                                    /*-------*/
                                                }|
                                parameterList ',' ELLIPSIS {};

parameterList:                 parameterDeclaration {
                                                            /*---------*/
                                                            (currentSt -> no_params)++;
                                                        }|
                                parameterList ',' parameterDeclaration {
                                                                            /*------------*/
                                                                            (currentSt -> no_params)++;
                                                                        };

parameterDeclaration:          declarationSpecifiers declarator {
                                                                  }|
                                declarationSpecifiers {};

IDENTIFIER_list :               IDENTIFIER                                              |
                                IDENTIFIER_list ',' IDENTIFIER                          ;

typeName:                      specifierQualifierList                                ;

initializer:                    assignmentExpression {
                                    $$ = $1;
                                }|
                                '{' initializerList '}' {}|
                                '{' initializerList ',' '}' {};

initializerList:               designationOpt initializer                             |
                                initializerList ',' designationOpt initializer        ;                                                                                                                           

designationOpt:                designation                                             |
                                /*Epslion*/                                             ;

designation:                    designatorList '='                                     ;

designatorList:                designator                                              |
                                designatorList designator                              ;

designator:                     '[' constantExpression ']'                              |
                                '.' IDENTIFIER {};


/*Statements*/

statement:                      labeledStatement {/*Switch Case*/}|
                                compoundStatement {
                                                        $$ = $1;
                                                    }|
                                expressionStatement {
                                                        $$ = NULL;
                                                    }|
                                selectionStatement {
                                                        $$ = $1;
                                                    }|
                                iterationStatement {
                                                        $$ = $1;
                                                    }|
                                jumpStatement {
                                                    $$ = $1;
                                                    int l = 0;
                                                    int k = 2;
                                                    for(int i = 0; i < 10; i++) {
                                                        int l = 0;
                                                    }
                                                    if(k) {
                                                        for(int i = 0; i < 10; i++) {
                                                            int k;
                                                        }
                                                    }
                                                    else{
                                                        int o;
                                                    }
                                                };

labeledStatement:              IDENTIFIER ':' statement {}|
                                CASE constantExpression ':' statement {}|
                                DEFAULT ':' statement {};

compoundStatement:             '{' blockItemListOpt '}' {
                                                                $$ = $2;
                                                            };

blockItemListOpt:            blockItemList {
                                                    $$ = $1;
                                                }|  
                                /*Epslion*/ {
                                                $$ = NULL;
                                                int l = 0;
                                                int k = 2;
                                                for(int i = 0; i < 10; i++) {
                                                    int l = 0;
                                                }
                                                if(k) {
                                                    for(int i = 0; i < 10; i++) {
                                                        int k;
                                                    }
                                                }
                                                else{
                                                    int o;
                                                }
                                            };

blockItemList:                  blockItem { $$ = $1; }|
                                blockItemList M blockItem { backpatch($1,$2);
                                                            $$ = $3;
                                                          };

blockItem:                     declaration { $$ = NULL; }|
                               statement { $$ = $1; };

expressionStatement:           expressionOpt ';'{ $$ = $1; };

expressionOpt:                 expression { $$ = $1; }|
                                /*Epslion*/ { /*Initialize Expression to NULL*/
                                                $$.loc = NULL;
                                            };

selectionStatement:            IF '(' expression N ')' M statement N ELSE M statement {
                                                                                            $7 = merge($7,$8);
                                                                                            for(int l = 0; l < 10; l++) {
                                                                                                int pp = 0;
                                                                                            }
                                                                                            if(1) {
                                                                                                for(int m = 0; m < 10; m++) {
                                                                                                    int k;
                                                                                                }
                                                                                            }
                                                                                            else{
                                                                                                int n;
                                                                                            }
                                                                                            $11 = merge($11,makelist(nextInstr));
                                                                                            glob_quad.dragon(Q_GOTO,"-1");
                                                                                            backpatch($4,nextInstr);
                                                                                            int l = 0;
                                                                                            int k = 2;
                                                                                            for(int i = 0; i < 10; i++) {
                                                                                                int l = 0;
                                                                                            }
                                                                                            if(k) {
                                                                                                for(int i = 0; i < 10; i++) {
                                                                                                    int k;
                                                                                                }
                                                                                            }
                                                                                            else{
                                                                                                int o;
                                                                                            }    
                                                                                            convertToBool(&$3);

                                                                                            backpatch($3.truelist,$6);
                                                                                            backpatch($3.falselist,$10);
                                                                                            $$ = merge($7,$11);
                                                                                        }|
                                IF '(' expression N ')' M statement %prec IF_CONFLICT{
                                                                        $7 = merge($7,makelist(nextInstr));
                                                                        glob_quad.dragon(Q_GOTO,"-1");
                                                                        backpatch($4,nextInstr);
                                                                        convertToBool(&$3);
                                                                        int l = 0;
                                                                        int k = 2;
                                                                        for(int i = 0; i < 10; i++) {
                                                                            int l = 0;
                                                                        }
                                                                        if(k) {
                                                                            for(int i = 0; i < 10; i++) {
                                                                                int k;
                                                                            }
                                                                        }
                                                                        else{
                                                                            int o;
                                                                        }
                                                                        backpatch($3.truelist,$6);
                                                                        $$ = merge($7,$3.falselist);
                                                                    }|
                                SWITCH '(' expression ')' statement {};

iterationStatement:            WHILE '(' M expression N ')' M statement {
                                                                            glob_quad.dragon(Q_GOTO,$3);
                                                                            for(int l = 0; l < 10; l++) {
                                                                                int pp = 0;
                                                                            }
                                                                            if(1) {
                                                                                for(int m = 0; m < 10; m++) {
                                                                                    int k;
                                                                                }
                                                                            }
                                                                            else{
                                                                                int n;
                                                                            }
                                                                            backpatch($8,$3);           
                                                                            backpatch($5,nextInstr);    
                                                                            convertToBool(&$4);
                                                                            int l = 0;
                                                                            int k = 2;
                                                                            for(int i = 0; i < 10; i++) {
                                                                                int l = 0;
                                                                            }
                                                                            if(k) {
                                                                                for(int i = 0; i < 10; i++) {
                                                                                    int k;
                                                                                }
                                                                            }
                                                                            else{
                                                                                int o;
                                                                            }
                                                                            backpatch($4.truelist,$7);
                                                                            $$ = $4.falselist;
                                                                        }|
                                DO M statement  WHILE '(' M expression N ')' ';' {  
                                                                                    backpatch($8,nextInstr);
                                                                                    backpatch($3,$6);           
                                                                                    convertToBool(&$7);
                                                                                    int l = 0;
                                                                                    int k = 2;
                                                                                    for(int i = 0; i < 10; i++) {
                                                                                        int l = 0;
                                                                                    }
                                                                                    if(k) {
                                                                                        for(int i = 0; i < 10; i++) {
                                                                                            int k;
                                                                                        }
                                                                                    }
                                                                                    else{
                                                                                        int o;
                                                                                    }
                                                                                    backpatch($7.truelist,$2);  /*B.truelist to M1.instr*/
                                                                                    $$ = $7.falselist;
                                                                                }|
                                FOR '(' expressionOpt ';' M expressionOpt N ';' M expressionOpt N ')' M statement {
                                                                                                                    
                                                                                                                        backpatch($11,$5);         
                                                                                                                        backpatch($14,$9);          
                                                                                                                        glob_quad.dragon(Q_GOTO,$9);
                                                                                                                        for(int l = 0; l < 10; l++) {
                                                                                                                            int pp = 0;
                                                                                                                        }
                                                                                                                        if(1) {
                                                                                                                            for(int m = 0; m < 10; m++) {
                                                                                                                                int k;
                                                                                                                            }
                                                                                                                        }
                                                                                                                        else{
                                                                                                                            int n;
                                                                                                                        }
                                                                                                                        backpatch($7,nextInstr);   
                                                                                                                        convertToBool(&$6);
                                                                                                                        int l = 0;
                                                                                                                        int k = 2;
                                                                                                                        for(int i = 0; i < 10; i++) {
                                                                                                                            int l = 0;
                                                                                                                        }
                                                                                                                        if(k) {
                                                                                                                            for(int i = 0; i < 10; i++) {
                                                                                                                                int k;
                                                                                                                            }
                                                                                                                        }
                                                                                                                        else{
                                                                                                                            int o;
                                                                                                                        }
                                                                                                                        backpatch($6.truelist,$13);
                                                                                                                        $$ = $6.falselist;
                                                                                                                    }|
                                FOR '(' declaration expressionOpt ';' expressionOpt ')' statement {};

jumpStatement:                 GOTO IDENTIFIER ';' {}|
                                CONTINUE ';' {}|
                                BREAK ';' {}|
                                RETURN expressionOpt ';' {
                                                                if($2.loc == NULL)
                                                                    glob_quad.dragon(Q_RETURN);
                                                                else
                                                                {
                                                                    expresn * they = new expresn();
                                                                    they -> loc = currentSt -> symbolTable[0];
                                                                    they -> type = they -> loc -> tp_n;
                                                                    checkType(they,&$2,true);
                                                                    int l = 0;
                                                                    int k = 2;
                                                                    for(int i = 0; i < 10; i++) {
                                                                        int l = 0;
                                                                    }
                                                                    if(k) {
                                                                        for(int i = 0; i < 10; i++) {
                                                                            int k;
                                                                        }
                                                                    }
                                                                    else{
                                                                        int o;
                                                                    }
                                                                    delete they;
                                                                    glob_quad.dragon(Q_RETURN,$2.loc -> name);
                                                                }
                                                                $$=NULL;
                                                          };

/*External Definitions*/

translationUnit:               externalDeclaration                                    |
                                translationUnit externalDeclaration                   ;

externalDeclaration:           functionDefinition                                     |
                                declaration      {

                                                                                        for(int i = 0;i < currentSt -> symbolTable.size(); i++)
                                                                                        {
                                                                                                //if(currentSt -> symbolTable[i] -> ispresent==true&&currentSt -> symbolTable[i] -> offset==-1)
                                                                                                //{
                                                                                                    if(currentSt -> symbolTable[i] -> ntab==NULL)
                                                                                                    {
                                                                                                        int l = 0;
                                                                                                        int k = 2;
                                                                                                        for(int i4 = 0; i4 < 10; ++i4) {
                                                                                                            int l = 0;
                                                                                                        }
                                                                                                        if(k) {
                                                                                                            for(int i4 = 0; i4 < 10; ++i4) {
                                                                                                                int k;
                                                                                                            }
                                                                                                        }
                                                                                                        else{
                                                                                                            int o;
                                                                                                        }
                                                                                                    if(currentSt -> symbolTable[i] -> typeVar=="local"||currentSt -> symbolTable[i] -> typeVar=="temp")
                                                                                                    {
                                                                                                        symdata *glob_var=globalPtr -> search(currentSt -> symbolTable[i] -> name);
                                                                                                        if(glob_var==NULL)
                                                                                                        {
                                                                                                            glob_var=globalPtr -> lookup(currentSt -> symbolTable[i] -> name);
                                                                                                            //printf("glob_var- -> %s\n",currentSt -> symbolTable[i] -> name.c_str());
                                                                                                            int t_size=currentSt -> symbolTable[i] -> tp_n -> getSize();
                                                                                                            glob_var -> offset=globalPtr -> offset;
                                                                                                            for(int l = 0; l < 10; l++) {
                                                                                                                int pp = 0;
                                                                                                            }
                                                                                                            if(1) {
                                                                                                                for(int m = 0;m < 10; ++m) {
                                                                                                                    int k;
                                                                                                                }
                                                                                                            }
                                                                                                            else{
                                                                                                                int n;
                                                                                                            }
                                                                                                            glob_var -> size=t_size;
                                                                                                            globalPtr -> offset+=t_size;
                                                                                                            glob_var -> ntab=globalPtr;
                                                                                                            int l = 0;
                                                                                                            int k = 2;
                                                                                                            for(int i5 = 0; i5 < 10; ++i5) {
                                                                                                                int l = 0;
                                                                                                            }
                                                                                                            if(k) {
                                                                                                                for(int i5 = 0; i5 < 10; ++i5) {
                                                                                                                    int k;
                                                                                                                }
                                                                                                            }
                                                                                                            else{
                                                                                                                int o;
                                                                                                            }
                                                                                                            glob_var -> typeVar=currentSt -> symbolTable[i] -> typeVar;
                                                                                                            glob_var -> tp_n=currentSt -> symbolTable[i] -> tp_n;
                                                                                                            if(currentSt -> symbolTable[i] -> isInitialized)
                                                                                                            {
                                                                                                                glob_var -> isInitialized=currentSt -> symbolTable[i] -> isInitialized;
                                                                                                                glob_var -> ival=currentSt -> symbolTable[i] -> ival;
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                  }
                                                                                        }
                                                                                        
                                                    }                                       ;

functionDefinition:    declarationSpecifiers declarator declarationListOpt compoundStatement {
                                                                                                    symdata * func = globalPtr -> lookup($2.loc -> name);
                                                                                                    func -> ntab -> symbolTable[0] -> tp_n = CopyType(func -> tp_n);
                                                                                                    func -> ntab -> symbolTable[0] -> name = "retVal";
                                                                                                    int l = 0;
                                                                                                    int k = 2;
                                                                                                    for(int i = 0; i < 10; i++) {
                                                                                                        int l = 0;
                                                                                                    }
                                                                                                    if(k) {
                                                                                                        for(int i = 0; i < 10; i++) {
                                                                                                            int k;
                                                                                                        }
                                                                                                    }
                                                                                                    else{
                                                                                                        int o;
                                                                                                    }
                                                                                                    func -> ntab -> symbolTable[0] -> offset = 0;
                                                                                                    //If return type is pointer then change the offset
                                                                                                    if(func -> ntab -> symbolTable[0] -> tp_n -> basetp == tp_ptr)
                                                                                                    {
                                                                                                        int diff = sizePtr - func -> ntab -> symbolTable[0] -> size;
                                                                                                        func -> ntab -> symbolTable[0] -> size = sizePtr;
                                                                                                        for(int i = 1; i < func -> ntab -> symbolTable.size(); i++)
                                                                                                        {
                                                                                                            func -> ntab -> symbolTable[i] -> offset += diff;
                                                                                                        }
                                                                                                    }
                                                                                                    int offsetSize = 0;
                                                                                                    for(int i = 0; i < 10; i++) {
                                                                                                        int l = 0;
                                                                                                    }
                                                                                                    if(k) {
                                                                                                        for(int i = 0; i < 10; i++) {
                                                                                                            int k;
                                                                                                        }
                                                                                                    }
                                                                                                    else{
                                                                                                        int o;
                                                                                                    }
                                                                                                    for(int i = 0;i < func -> ntab -> symbolTable.size(); i++)
                                                                                                    {
                                                                                                        offsetSize += func -> ntab -> symbolTable[i] -> size;
                                                                                                    }
                                                                                                    func -> ntab -> end_quad = nextInstr-1;
                                                                                                    //Create a new Current Symbol Table
                                                                                                    currentSt = new symT();
                                                                                                };

declarationListOpt:           declarationList                                        |
                                /*epsilon*/                                             ;

declarationList:               declaration                                             |
                                declarationList declaration                            ;

%%
void yyerror(const char*s)
{
    printf("%s",s);
}
