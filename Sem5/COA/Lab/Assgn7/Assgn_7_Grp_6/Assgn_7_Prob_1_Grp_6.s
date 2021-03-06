#//////////////////////////////////////////////////////////////////////////////////
#// Create Date: 11.11.2020 13:55:12
#// Module Name: MIPS program to convert characters of a string to lowercase
#// Project Name: Ass_7_Grp_6
#//
#// SEMESTER 5
#// Assignment 7 - COA Lab (Problem 1)
#//
#// GROUP 6
#// 18CS30005 - Aditya Singh
#// 18CS30021 - Itish Agarwal
#//////////////////////////////////////////////////////////////////////////////////

.data
	
prompt: .asciiz "***Enter the string:\n"
resultMessage: .asciiz "=> Lowercase string is:\n"
space: .asciiz "   "
newLine: .asciiz "\n"
string: .space 150   #150 is set as the maximum length of input text

.text 
.globl main

main: 

	#display the message to ask user to input the string
	li $v0, 4
	la $a0, prompt
	syscall 	
	
	li $v0, 4
	la $a0, space
	syscall
	
	#take the string as input, and store it in memory 
	li $v0, 8
	la $a0, string
	li $a1, 100
	syscall
	
	li $t0, 0
	
	#write a loop to iterate over the string
	loop:
	
		lb $t1, string($t0)
		beq $t1, 0, exit #if we reach end of string, exit		
		blt $t1, 'A', notCapital #check if current character is less than 'A', we do not need to convert it to lowercase
		bgt $t1, 'Z', notCapital #check if current character is greater than 'Z', we do not need to convert it to lowercase
		
		add $t1, $t1, 32 #if we reach here, that means current char was uppercase -> add 32 (according to ASCII code) to convert it  to lowercase
		sb $t1, string($t0)  #change the original memory location
		
		notCapital:
			addi $t0, $t0, 1
			j loop
		exit:
			li $v0, 4
			la $a0, newLine
			syscall
			
			#display result message
			li $v0, 4
			la $a0, resultMessage
			syscall
			
			li $v0, 4
			la $a0, space
			syscall
			
			#print the string after modification to lowercase
			li $v0, 4
			la $a0, string
			syscall
			
			#terminate the program
			li $v0, 10
			syscall
		
	
	
	
