#//////////////////////////////////////////////////////////////////////////////////
#// Create Date: 11.11.2020 13:55:12
#// Module Name: MIPS program to sort an array using Insertion Sort
#// Project Name: Ass_7_Grp_6
#//
#// SEMESTER 5
#// Assignment 7 - COA Lab (Problem 2)
#//
#// GROUP 6
#// 18CS30005 - Aditya Singh
#// 18CS30021 - Itish Agarwal
#//////////////////////////////////////////////////////////////////////////////////

.data

array: .space 32
newLine: .asciiz "\n"
space: .asciiz " "
message: .asciiz "=> Array after sorting is : \n"
prompt: .asciiz "***Enter 8 numbers (enter each number in new line) :\n"
threeSpace: .asciiz "   "
num: .word 0

.text
.globl main

main:
	
	li $v0, 4
	la $a0, prompt
	syscall
	 
	#take 8 numbers as input and store them in 'array'
	addi $t0, $zero, 0
	while:
		beq $t0, 32, done
		
		li $v0, 4
		la $a0, threeSpace
		syscall
		
		li $v0, 5
		syscall
		sw $v0, num
		
		lw $t1, num
		
		sw $t1, array($t0)				
		addi $t0, $t0, 4
		j while
			
	done:
	
	#load address of array into register $a1, 1st parameter to InsertionSort function
	la $a1, array
	
	#$a2 stores size of the array, 2nd parameter to InsertionSort function
  addi $a2, $zero, 8
  
  li $v0, 4
  la $a0, newLine
  syscall
	
	#Call InsertionSort
	jal InsertionSort 	
	
	#print the array now
	li $v0, 4
	la $a0, message
	syscall
	
	li $v0, 4
  la $a0, threeSpace
  syscall
	addi $t0, $zero, 0
	
	#loop to print the array
	wloop3:
		beq $t0, 32, done3
		
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
		j Exit
		
	
InsertionSort:
	#$a0 contains the arrray, $a1 contains the number of elements of the array
	
	#Pseudo code for insertion sort is :
	#int i, key, j
	#for(i = 1; i < n; i++) {
	#  key = arr[i]
	#  j = i - 1
	#  while(j>=0 && arr[j]>key) {
	#    arr[j+1] = ar[i]
	#    j = j - 1
	#  }
	#  arr[j+1] = key
	#
	
	#Implementing this in MIPS
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
	#return back to where this function was called
		jr $ra	
	
Exit:
  #terminate the program
	li $v0, 10
	syscall
