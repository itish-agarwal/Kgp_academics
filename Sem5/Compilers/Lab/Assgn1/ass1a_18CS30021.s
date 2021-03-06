	.file	"ass1A.c"
	.text
	.section	.rodata
.LC0:
	.string	"\nThe greater number is: %d"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp                    /*Push the base pointer on the stack*/
                                       /*It is storing the base pointer on the stack to save the callee function frame*/
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp              /*Update base pointer to point to the base of the callee function frame*/
	.cfi_def_cfa_register 6
	subq	$16, %rsp               /*Update stack pointer to point to the top of the callee function frame
                                        Here, the stack creates a space of 16 bytes, which will be required by the function*/
	movl	$45, -8(%rbp)           /*Store num1 on the stack*/
	movl	$68, -4(%rbp)           /*Store num2 on the stack*/
	movl	-8(%rbp), %eax          /*Copy num1 into register eax*/
	cmpl	-4(%rbp), %eax          /*Check if eax is less than num2 or not - compare eax and num2*/
	jle	.L2                       /*If eax is less than num2, then jump to label L2*/
	movl	-8(%rbp), %eax          /*Assign the value of num1 to the variable 'greater' which is in the register eax*/
	movl	%eax, -12(%rbp)         /*Store the value of variable 'greater' on the stack*/
	jmp	.L3                       /*Jump to label L3*/ 
.L2:
	movl	-4(%rbp), %eax          /*Assign the value of num2 to the variable 'greater' which is in the register eax*/
	movl	%eax, -12(%rbp)         /*Store the value of variable 'greater' on the stack*/
.L3:
	movl	-12(%rbp), %eax         /*Load the value of variale 'greater' from the stack into the register eax*/
	movl	%eax, %esi              /*Move the variable 'greater' from eax to esi - which is the 2nd argument of printf (ie, %d)*/
	leaq	.LC0(%rip), %rdi        /*Lead effective address - calculating address of string and moving it to register rdi 
                                         - to be able to pass the string to printf//-//First argument for printf is the string itself
                                         -ie, the string is moved into rdi*/
	movl	$0, %eax                /*Clear the register eax*/
	call	printf@PLT              /*call printf*/
	movl	$0, %eax                /*Move zero to eax so that return value becomes zero*/
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.3.0-10ubuntu2) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
