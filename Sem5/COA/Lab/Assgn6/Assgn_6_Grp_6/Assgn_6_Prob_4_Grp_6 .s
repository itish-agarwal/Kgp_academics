#//////////////////////////////////////////////////////////////////////////////////
#// Create Date: 5.11.2020 15:55:12
#// Module Name: MIPS program to find product of two 16-bit signed integers encoded in 2's complement format
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
prompt1:     .asciiz  "Enter first number : "
prompt2:	   .asciiz  "Enter second number : "
rangeEr:  .asciiz "Error, atleast one of the numbers violates the range of 16-bit signed integers in MIPS"
result:    .asciiz "The product of given number is: "

.text
.globl main
main:

       #display the message to tell user to input the first number
       li $v0, 4
       la $a0, prompt1
       syscall

       #take input of the first number and store it in $t0
       li $v0, 5  
       syscall
       move $t0, $v0 
    
       #display the message to tell user to input the second number    
       li $v0, 4 
       la $a0, prompt2
       syscall
    
       #take input of second number and store it in $t1
       li $v0, 5
       syscall
       move $t1, $v0
       
       #Sanity check for first number
       add $a0, $t0, $zero
	     jal SanityCheck
	   
       #Sanity check for second number
       add $a0, $t1, $zero
	     jal SanityCheck
		 
       #If both the numbers are within the required range, we implement Booth's algorithm
       add $a0, $t0, $zero 
       add $a1, $t1, $zero
       move $s3, $zero		# Product
       move $t3, $zero 		# Counter
       sll $a0, $a0, 1		# a(0)=0
       
       jal seq_mult_booth	#jump back to seq_mult_booth
	   
       # printing the product
       la $a0, result
       li $v0, 4
       syscall

       li $v0, 1
       move $a0, $s3
       syscall

       j exit
       
SanityCheck:
		addi $s0, $zero, 1
		sll $s0, $s0, 15     #Left shift $s0 by 15 bits
		addi $s0, $s0, -1
		bgt $a0, $s0, rangeError		# Input can not be greater than 2^15 - 1
		sub $s1, $zero, $s0
		addi $s1, $s1, -1
		blt $a0, $s1, rangeError		# Input can not be less than -2^15
		jr $ra				# Return back to main

seq_mult_booth: 
		beq $t3, 16, end
		addi $t3, $t3, 1	# Increment counter
		andi $t2, $a0, 1	# Check a(i-1)
		beq $t2, 1, case_01	# case '01'
		bne $t2, 1, case_10	# Case '10'
		
		j seq_mult_booth  #jump back to seq_mult_booth
		
end:
		jr $ra			# Return back to from where this function was called
		
case_01:
		add $t6, $a0, $zero
		srl $t6, $t6, 1
		andi $t7, $t6, 1	#Check a(i)
		beq $t7, $zero, cond_1
		srl $a0, $a0, 1		#Shift multiplier right by 1
		sll $a1, $a1, 1		#Shift multiplicand left by 1
		
		j seq_mult_booth 	#jump back to seq_mult_booth

case_10:
		
		add $t4, $a0, $zero
		srl $t4, $t4, 1
		andi $t5, $t4, 1	#Check a(i)
		beq $t5, 1, cond_2
		srl $a0, $a0, 1		#Shift multiplier right by 1
		sll $a1, $a1, 1		#Shift multiplicand left by 1
		
		j seq_mult_booth
			
cond_1: 
		add $s3, $s3, $a1	#Result += multiplicand
		srl $a0, $a0, 1		#Shift multiplier right by 1
		sll $a1, $a1, 1		#Shift multiplicand left by 1
		
		j seq_mult_booth  #jump back to seq_mult_booth
			
cond_2:
		sub $s3, $s3, $a1	#Result -= multiplicand
		srl $a0, $a0, 1		#Shift multiplier right by 1
		sll $a1, $a1, 1		#Shift multiplicand left by 1
		
		j seq_mult_booth  #jump back to seq_mult_booth
	 
rangeError:
	#if we reach here, there is error in the input, ie, number violates the specified range
	la $a0, rangeEr    
	li $v0, 4
	syscall
	j exit	
	
exit:
	#terminate the program
	li $v0, 10
	syscall 

