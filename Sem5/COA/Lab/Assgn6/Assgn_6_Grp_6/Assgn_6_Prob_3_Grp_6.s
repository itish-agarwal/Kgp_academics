#//////////////////////////////////////////////////////////////////////////////////
#// Create Date: 5.11.2020 15:55:12
#// Module Name: MIPS program to find product of two 16-bit unsigned integers
#//              using the Sequential Unsigned Binary Multiplication(left-shift version)
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

prompt1: .asciiz "Enter first number : "
prompt2: .asciiz "Enter second number : "
rangeEr: .asciiz "Error, atleast one of the numbers does not lie in the 16-bit unsigned integer range"
overflowEr: .asciiz "Arithmetic overflow occured, product of given numbers exceeds the range of signed 32-bit integers used in MIPS"
message: .asciiz "Product of given numbers is : " 

num1: .word 0 #stores num1 
num2: .word 0 #stores num2

.text
.globl main

main: 
		
	#display the message to tell the user to input first number
	li $v0, 4
	la $a0, prompt1
	syscall
	
	#take input of the first number
	li $v0, 5
	syscall
	sw $v0, num1
	
	#display the message to tell the user to input the second number
	li $v0, 4
	la $a0, prompt2
	syscall
	
	#take input of the second number	
	li $v0, 5
	syscall
	sw $v0, num2
	
	#load word from memory into registers
	lw $t0, num1
	lw $t1, num2
	
	#Sanity check (ie, check if both the numbers lie in the range of 16-bit unsigned integers)
	#Range of 16-bit unsiged integers is from [0, 2^16 - 1], ie from [0, 65535].	
	blt $t0, 0, rangeError  
	blt $t1, 0, rangeError
	bge $t0, 65536, rangeError
	bge $t1, 65536, rangeError
	
	#if there is no range error, jump to label noError
	j noError
	
	noError:	
		#fill up parameters $a0 and $a1
		addu $a0, $zero, $t0
		addu $a1, $zero, $t1
		
		#call label seq_mult_unsigned -> takes $a0 and $a1 as parameters and stores the result in $v0
		jal seq_mult_unsigned
		
		#copy result into $t5
		addu $t5, $zero, $v0
		
		#check for overflow, ie, check if the product overflows the range of 32-bit integers available in MIPS
		blt $t5, 0, overflowError
		
		#print the result message
		li $v0, 4
		la $a0, message
		syscall
		
		#print the result ie, $t5
		li $v0, 1
		add $a0, $zero, $t5
		syscall
	
		j Exit
		
	rangeError:
		#if any of the input numbers violates the range, we are directed here and print the error message
		li $v0, 4
		la $a0, rangeEr
		syscall
		j Exit
		
	overflowError:
		#if the product overflows the range of 32-bit integers available in MIPS, display the overflow message
		li $v0, 4
		la $a0, overflowEr
		syscall
		j Exit

seq_mult_unsigned:	
	
	#store the parameters in temporary registers $t0 and $t1
	addu $t0, $zero, $a0
	addu $t1, $zero, $a1
	
	#t2 will store the answer
	addu $t2, $zero, $zero
	
	#t3 stores the cnt (which is needed in left-shift multiplication)
	addu $t3, $zero, $zero
	
	#t5 stores the constant 2 which will be used in integer division
	addu $t5, $zero, 2
	
	#/Now, pseudocode to be used here is:
	#ans=0,cnt=0;
	#while($t1 > 0) {
	#	if($t0 % 2 == 1) {
	#		ans += ($t1 << cnt);
	#	}
	#	cnt++;
	# $t1 = $t1/2;
	#}
	
	while: 
		
		beq $t1, 0, done  #if t1 == 0, jump to label done
		
		div $t1, $t5  #stores quotient in lo and remainder in hi
		
		mfhi $s0 #move remainder from register hi to register s0 
		
		beq $s0, 1, addToAns   #if remainder==1, jump to label addToAns
		
		j next
		
		next:
		
			addi $t3, $t3, 1	#increment cnt (ie, $t3) by 1 -> we are processing the binary representation of multiplier (from right to left)
			div $t1, $t1, 2  #divide $t1 by 2, integer division
			j while
			
		addToAns:
			addu $t4, $zero, $t0  #initialise $t4 to $t0
			sllv $t4, $t4, $t3  #left shift $t4 by cnt(ie, $t3)
			addu $t2, $t2, $t4 #add $t4 to ans(ie, $t2)
			j next
			
		done:
			#when the loop ends, we simply store the result in $v0 and jump back using to the place from where seq_mult_unsigned was called
			addu $v0, $zero, $t2
			j return	
				
	return:
		jr $ra
	
Exit:
	#terminate the program
	li $v0, 10
	syscall

