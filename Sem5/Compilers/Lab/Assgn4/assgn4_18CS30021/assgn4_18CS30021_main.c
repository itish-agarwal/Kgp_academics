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

#include "y.tab.h"
#include <stdio.h>

extern int yyparse();

int main()
{
    yyparse();
    return 0;
}