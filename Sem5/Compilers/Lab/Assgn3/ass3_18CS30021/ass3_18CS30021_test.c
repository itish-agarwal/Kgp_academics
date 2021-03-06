/*  Name: Itish Agarwal (18CS30021) 
    Compilers Laboratory Assignment 3 
    Created on 24.9.2020  
*/
// 	Test file to check running of flex specifications 

#include <stdio.h>

typedef struct beautiful_game {
	char name[10];
	name = "football";
	int rank = 1;
}

int main() {

	1 2 3 4 5 6 7 8 9

	//	testing single line comments
	/* 	Let's test multi line comments now;
		I am a Real Madrid fan and I want to 	
		visit Madrid and watch the match at 
		Santiago Bernabeu */
    
    "Let us test string literals now!"
    "This is a typical interview question: Tell us about yourself"
    "Now again I am testing string literals but let's move on to testing some keywords!"
    "Ah there! I am surprised to know that there are so many keywords!"


     //again testing single line comments but keywords come after this!


     auto  enum 
     restrict unsigned    
     continue   
     if   static   _Complex
     default   inline   struct     _Imaginary
     break extern return void
     char   for  
    signed while
     const  goto    sizeof   _Bool
     do         int   switch     double    long
     typedef    else    register
     union
     case   float short  volatile
     
     
       


    //testing integer and floats 
    int temp = 2 + 4
    temp = 3 + 4.7
    float _dg1 = 4.7/3.4
    float _ABC = 3.5*6
    int var909 = 5%2
    float _TEMP909 = 5.7 - 4.8  

    //Lets test these some more;

    short int a = 8893;
    const int b = 3243434.23;
    volatile signed long b += 9.33;
    extern unsigned int c = b;
    d = "sdfdsfdsfg"

    for(int i = 0; i < 20; i++) {
    	//I know this does not print a loop xD, no use of going upto 20
    	printf("In the loop @ %d\n", i);
    }
     


    // 	Let's now test escape sequences and some string literals     
     \n  \t ' \  ""   "dfdfbd" "flex"



   //	Let's test all punctuators

                     [ ]     ( )       { }       .        ->
                     ++       --        &        *         +
                      -       ~         !        /         %
                     <<       >>        <        >         <=
                     ==      !=         ^        |         &&
                     ||      ?          :        ;          ...
                     =       *=         /=      %=         +=
                    -=       <<=        >>=     &=         ^=
                     |=      ,          #   

    int f = 323, i = 2332;
    if (f == i+1){
		beautiful_game Football;
		i++;
		--i;
		i *= i;
		//Exit
	}
	else if(f*f >= i) {
	 	_Imaginary	im;
	 	f = i^i;
	}
	else {
	 	f = (i == f) ? i*i : f/4;
	 	i += 33;
	 	i++;
	 	--i;
	}

    //Test over - hope everything runs fine!
}