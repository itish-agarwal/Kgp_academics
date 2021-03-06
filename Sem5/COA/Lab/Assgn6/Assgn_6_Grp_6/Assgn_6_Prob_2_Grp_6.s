#//////////////////////////////////////////////////////////////////////////////////
#// Create Date: 5.11.2020 15:55:12
#// Module Name: MIPS program to determine whether the given number is prime or composite
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
.data
mess1: .asciiz "Enter number : "
mess2: .asciiz "Number is prime"
mess3: .asciiz "Number is composite"
errorMsg: .asciiz "Error, number should be greater than or equal to 2"

num: .word 0
cnt: .word 2

.text 
.globl main

main:
	
	#display the message to take the number as input
	li $v0, 4
	la $a0, mess1
	syscall
	
	#take number as input
	li $v0, 5
	syscall 
	sw $v0, num	

	lw $t1, num
	lw $t2, cnt       # counter from 1 to n
	
	blt $t1, 2, error	# if n is less than 2, error message is displayed 
	j noError
		
	# n in t1
	noError:
		while:		
			beq $t1, $t2, exit	# if counter reaches n, loop ends	
			div $t1, $t2	
			mfhi $t3 		# t3 contains remainder when n is divided by counter
			beq $t3, 0, exit	# if remainder is 0, n has more than 2 factors and is hence composite, so loop ends
			add $t2, $t2, 1		# increment counter
			j while			
		exit:	
			beq $t1, $t2, cond	# if counter is equal to n after the loop ends, that means that no factor was found and n is prime
			li $v0, 4
			la $a0, mess3		# n is composite message is printed
			syscall
			j Exit	
		cond:
			li $v0, 4
			la $a0, mess2		# n is prime message is printed
			syscall
			
			j Exit		
	
	error:		
		li $v0, 4
		la $a0, errorMsg		# if n < 2, error message is printed
		syscall
		j Exit
	
	Exit:
		#terminate the program
