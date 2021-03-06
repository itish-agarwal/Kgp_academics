/*  Name: Itish Agarwal (18CS30021) 
    Compilers Laboratory Assignment 3 
    Created on 24.9.2020  
*/

/* C file which contains main and auxiliary functions for flex specification */


#include <stdio.h>

#define KEYWORD           1
#define IDENTIFIER        2
#define STRING_LITERAL    3
#define PUNCTUATOR        4
#define COMMENT           5
#define INTEGER_CONST     6
#define FLT_CONST         7
#define CH_CONST          8
#define SL_COMMENT        9
#define ML_COMMENT        10

extern int yylex();
extern char* yytext;

int main() {
  
  extern FILE* yyin;
  yyin = fopen("ass3_18CS30021_test.c", "r");
  
  int token = yylex();
  
  while(token) {
    
    switch(token) {
      
      case KEYWORD:
        printf("<KEYWORD, %d, %s>\n", token, yytext);
        break;
        
      case IDENTIFIER:
        printf("<IDENTIFIER, %d, %s>\n", token, yytext);
        break;
        
      case INTEGER_CONST:
        printf("<INTEGER CONSTANT, %d, %s>\n", token, yytext);
        break;

      case FLT_CONST:
        printf("<FLOATING POINT CONSTANT, %d, %s>\n", token, yytext);
        break;

      case CH_CONST:
        printf("<CHARACTER CONSTANT, %d, %s>\n", token, yytext);
        break;
        
      case STRING_LITERAL:
        printf("<STRING LITERTAL, %d, %s>\n", token, yytext);
        break;
        
      case PUNCTUATOR:
        printf("<PUNCTUATOR, %d, %s>\n", token, yytext);
        break;

      // case COMMENT:
      // 	printf("<COMMENT, %d, %s>\n", token, yytext);
      // 	break;
      
      case SL_COMMENT:
        printf("<SINGLE LINE COMMENT, %d, %s>\n", token, yytext);
        break;

      case ML_COMMENT:
        printf("<MULTI LINE COMMENT, %d, %s>\n", token, yytext);
        break;

      default:
        printf("<PUNCTUATOR, %d, %s>\n", token, yytext);
        break;
    }
    
    token = yylex();
  }
  
  fclose(yyin);
  return 0;
}


