#//////////////////////////////////////////////////////////////////////////////////
#// Create Date: 5.11.2020 15:55:12
#// Module Name: MIPS program to find GCD of two numbers using repeated subtraction
#// Project Name: Ass_6_Grp_6
#//
#// SEMESTER 5
#// Assignment 6 - COA Lab
#//
#// GROUP 6
#// 18CS30005 - Aditya Singh
#// 18CS30021 - Itish Agarwal
#//////////////////////////////////////////////////////////////////////////////////

.data
prompt1: .asciiz "Enter the first number : "
prompt2: .asciiz "Enter the second number : "
prompt3: .asciiz "GCD of given numbers is : "
errorMsg: .asciiz "Error, atleast one of the numbers is not purely positive"

num1: .word 0 #stores input number 1
num2: .word 0 #stores input number 2
gcd: .word 0 #stores the result, ie, gcd of given numbers

.text 
.globl main

main:
	
	#display the message to tell the user to input the first number
	li $v0, 4
	la $a0, prompt1
	syscall
	
	#take input of first number and store it in num1
	li $v0, 5
	syscall 
	sw $v0, num1
	
	#display the message to tell the user to input the second number
	li $v0, 4
	la $a0, prompt2
	syscall
	
	#take input of second number and store it in num2	
	li $v0, 5
	syscall
	sw $v0, num2	
	
	#load word from memory into temporary registers
	lw $t1, num1
	lw $t2, num2
	
	#if any of num1 or num2 <= 0, display the error message and terminate
	#the program by jumping to label error and then to Exit
	blt $t1, 1, error
	blt $t2, 1, error
	
	#if both numbers are positive as they should be, jump to label noError
	j noError
		
	#num1 is stored in t1, num2 is stored in t2
	noError:
	#now pseudocode for finding GCD (using repeated subtraction) of two numbers a and b is 
	#while(a != b) {
	#	if(a > b) {
	#		a -= b;
	#	} else {
	#		b -= a;
	#	}
	#}
	
	#$t1 stores a, $t2 stores b
		while:		
			beq $t1, $t2, done	    #if a==b, break the loop and go to done
			bgt $t1, $t2, agb		#else if a > b, go to a > b
			sub $t2, $t2, $t1		#if we reach here, it means b > a, hence do b -= a
			j while		
			agb:			
				#means a > b, hence do a -= b
				sub $t1, $t1, $t2			
				j while		
			done:				
		
		#now print the result
		#display message for the result
		li $v0, 4
		la $a0, prompt3
		syscall
		
		#display gcd of given numbers
		li $v0, 1
		move $a0, $t1
		syscall	

	j Exit
	
	error:		
	#display error message
		li $v0, 4
		la $a0, errorMsg
		syscall
		j Exit
	
	Exit:
	#terminate the program
