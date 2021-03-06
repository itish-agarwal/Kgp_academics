#//////////////////////////////////////////////////////////////////////////////////
#// Create Date: 11.11.2020 13:55:12
#// Module Name: MIPS program to sort an array using Insertion Sort and then find a given value in the sorted
#//              array using recursive binary search(and tell if it does not exist in the array)
#// Project Name: Ass_7_Grp_6
#//
#// SEMESTER 5
#// Assignment 7 - COA Lab (Problem 3)
#//
#// GROUP 6
#// 18CS30005 - Aditya Singh
#// 18CS30021 - Itish Agarwal
#//////////////////////////////////////////////////////////////////////////////////

.data

array: .space 36 #4 bytes*9 == 36 bytes
newLine: .asciiz "\n"
space: .asciiz " "
message: .asciiz "=> Array after sorting is : \n"
prompt: .asciiz "***Enter 9 numbers (enter each number in new line) :\n"
notFoundMsg: .asciiz "=> Value does not exist in the array.\n"
foundMsg: .asciiz "=> Given value is present in the array at index: "
noteMsg: .asciiz "   (indexing starting from 1)\n"
threeSpace: .asciiz "   "
targetInput: .asciiz "***Enter target to be found in the array: "
targetNum: .word 0

num: .word 0

.text
.globl main

main:
	
	li $v0, 4
	la $a0, prompt
	syscall
	 
	#take 9 numbers as input
	addi $t0, $zero, 0
	while:
		li $v0, 4
		la $a0, threeSpace
		syscall
		
		beq $t0, 36, done

		li $v0, 5
		syscall
		sw $v0, num
		
		lw $t1, num
		
		sw $t1, array($t0)				
		addi $t0, $t0, 4
		j while
			
	done:
	
	
	la $a1, array

  addi $a2, $zero, 9
	
	#Sort the array
	jal InsertionSort 
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	#print the array now
		
	li $v0, 4
	la $a0, message
	syscall
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 4
	la $a0, space 
	syscall

	
	addi $t0, $zero, 0
	
	wloop3:
		beq $t0, 36, done3
		
		lw $t6, array($t0)
		
		li $v0, 1
		add $a0, $zero, $t6
		syscall
		
		addi $t0, $t0, 4
		li $v0, 4
		la $a0, space
		syscall
		
		j wloop3		
		
	done3: 
		
		li $v0, 4
		la $a0, newLine
		syscall
		li $v0, 4
		la $a0, newLine
		syscall
		j BS
		
		
	BS: 
			
		li $v0, 4
		la $a0, targetInput
		syscall 
		
		li $v0, 5
		syscall
		sw $v0, targetNum
		
		#t7 will always hold the targetNum
		lw $t7, targetNum
		
		#for recusive binary search, we need left and right indices
		
		#Store left index(ie, 0) in $a1
		#Store right index(ie, 8) in $a2
		#Store base address of array in $a3
		
		addi $a1, $zero, 0
		addi $a2, $zero, 8
		la $a3, array
		#Call BinarySearch
		jal BinarySearch
		
		nextt:
		
		#result is contained in $v0
			add $t0, $zero, $v0 			
			beq $t0, -1, notThere
			
			li $v0, 4
			la $a0, foundMsg
			syscall
			
			li $v0, 1
			addi $a0, $t0, 1
			syscall
			
			li $v0, 4
			la $a0, newLine
			syscall
			
			li $v0, 4
			la $a0, noteMsg
			syscall
			
			j Exit		
			
			notThere:
				#Display the message telling the user that value does not exist in the array
				li $v0, 4
				la $a0, notFoundMsg
				syscall
				
				j Exit
		
	
BinarySearch:

	#a1 -> left index
	#a2 -> right index
	#a3 -> base address of array
	#t7 -> target value
	
	subu $sp, $sp, 12
	
	sw $ra, ($sp) #store the value of return address on the stack
	sw $s1, 4($sp) #store left index on the stack
	sw $s2, 8($sp) #store right index on the stack
	
	#if(left_index > right_index) 
	#value does not exits, return -1
	bgt $a1, $a2, doesNotExist
	
	#find mid and store it in $t0
	add $t0, $zero, $a2
	sub $t0, $t0, $a1
	div $t0, $t0, 2
	add $t0, $t0, $a1
	
	#find array[mid] and store it in $t2
	add $t1, $zero, $t0
	add $t1, $t1, $t1
	add $t1, $t1, $t1
	add $t1, $t1, $a3
	
	#t2 contains array[mid]
	lw $t2, 0($t1)
	
	#if arr[mid], value is found and jump to 'found'
	beq $t2, $t7, found	
	
	bgt $t2, $t7, greaterThan
	
	addi $a1, $t0, 1	
	jal BinarySearch
		
	greaterThan:
	
		addi $a2, $t0, -1
		jal BinarySearch
	
	
	found:			
		#if value is found, restore the stack and return
		add $v0, $zero, $t0
		
		lw $ra, ($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		addu $sp, $sp, 12
		
		j nextt
	
	doesNotExist:
	#if value does not exist, return -1
		addi $v0, $zero, -1
		
		lw $ra, ($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		
		addu $sp, $sp, 12
		
		j nextt		
	
	
InsertionSort:
	#$a0 contains the arrray, $a1 contains the number of elements of the array

	#counter i in $t0
	#key in $t1
	#j in $t2
	addi $t0, $zero, 1
	
	wloop1:
		
		beq $t0, $a2, done1
		
		
		add $t3, $zero, $t0
		add $t3, $t3, $t3
		add $t3, $t3, $t3
		add $t3, $t3, $a1
		
		lw $t1, 0($t3)
		
		add $t2, $zero, $t0
		addi $t2, $t2, -1
			#counter i in $t0
			#key in $t1
			#j in $t2
		wloop2:
			
			blt $t2, 0, done2
			
			add $t3, $zero, $t2
			add $t3, $t3, $t3
			add $t3, $t3, $t3
			add $t3, $t3, $a1
			
			lw $t4, 0($t3)
			
			bge $t1, $t4, done2
			
			add $t3, $zero, $t2
			addi $t3, $t3, 1
			add $t3, $t3, $t3
			add $t3, $t3, $t3
			add $t3, $t3, $a1
			
			sw $t4, 0($t3)
			
			addi $t2, $t2, -1
			j wloop2
						
		done2:
					
			#arr[j+1] = key;
			add $t3, $zero, $t2
			addi $t3, $t3, 1
			add $t3, $t3, $t3
			add $t3, $t3, $t3			
			add $t3, $t3, $a1
			sw $t1, 0($t3)		
			j next
		
		next:		
		addi $t0, $t0, 1
		
		j wloop1		
		
	done1:
		j return
		
	return:
		jr $ra	
	
Exit:
#terminate the program
	li $v0, 10
	syscall
