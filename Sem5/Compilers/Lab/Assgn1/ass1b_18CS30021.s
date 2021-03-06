	.file	"ass1B.c"
	.text
	.section	.rodata
	.align 8
.LC0:
	.string	"\nGCD of %d %d %d and %d is: %d"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp                        /*Push the base pointer on the stack*/
	.cfi_def_cfa_offset 16     
	.cfi_offset 6, -16
	movq	%rsp, %rbp                  /*Update base pointer to point to the base of the callee function frame*/
	.cfi_def_cfa_register 6 
	subq	$32, %rsp                   /*Update stack pointer to point to the top of the callee function frame
                                            Here, the stack creates a space of 32 bytes, which will be required by the function*/
	movl	$45, -20(%rbp)              /*Store variable 'a' on the stack*/
	movl	$99, -16(%rbp)              /*Store variable 'b' on the stack*/
	movl	$18, -12(%rbp)              /*Store variable 'c' on the stack*/
	movl	$180, -8(%rbp)              /*Store variable 'd' on the stack*/
	movl	-8(%rbp), %ecx              /*Copy value of variable 'd' into register ecx*/
	movl	-12(%rbp), %edx             /*Copy value of variable 'c' into register edx*/
	movl	-16(%rbp), %esi             /*Copy value of variable 'b' into register esx*/
	movl	-20(%rbp), %eax             /*Copy value of variable 'a' into register eax*/
	movl	%eax, %edi                  /*copy eax into edi*/
	call	GCD4                        /*calling GCD4 function --> control passes onto line 53 directly*/
	movl	%eax, -4(%rbp)              /*eax now contains the result of GCD4*/
                                            /* Register -4(%rbp) contains varibale 'result' --> 
                                            and beacuse eax now contains the result of GCD4, -4(%4bp) now gets the value of eax*/
                                           /*movl a b --> a is copied into b
	movl	-4(%rbp), %edi              /*Pass value of varibale 'result' into edi - one of the arguments to pass onto printf*/
	movl	-8(%rbp), %esi              /*Pass value of variable 'd' into esi*/
	movl	-12(%rbp), %ecx             /*Pass value of variable 'c' into ecx*/
	movl	-16(%rbp), %edx             /*Pass value of varibale 'b' into edx*/
	movl	-20(%rbp), %eax             /*Pass value of varibale 'a' into eax*/
	movl	%edi, %r9d                  /*Pass value of edi into r9d*/
	movl	%esi, %r8d                  /*Pass value of esi into r8d*/
	movl	%eax, %esi                  /*Pass value of eax into esi*/ 
	leaq	.LC0(%rip), %rdi            /*first argument of printf - move address of string into rdi ( which is the 1st register for passing on the arguments )*/
	movl	$0, %eax                    /*Clear register eax*/
	call	printf@PLT                  /*Call printf*/
	movl	$10, %edi                   /*This is for the single backslash "n" at the end of main - pass first argument "\n" into edi*/
	call	putchar@PLT                 /*prints a single character*/
	movl	$0, %eax                    /*make self return value of the function  zero*/
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.globl	GCD4
	.type	GCD4, @function
GCD4:                     
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp                       /*Push the base pointer on the stack*/
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp                 /*Update base pointer to point to the base of the callee function frame*/
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)            /*Pass the value of call-by-value variable 'n1' on the stack*/
	movl	%esi, -24(%rbp)            /*Pass the value of call-by-value variable 'n2' on the stack*/
	movl	%edx, -28(%rbp)            /*Pass the value of call-by-value variable 'n3' on the stack*/
	movl	%ecx, -32(%rbp)            /*Pass the value of call-by-value variable 'n4' on the stack*/       
	movl	-24(%rbp), %edx            /*Pass value of variable 'n2' into edx*/ 
	movl	-20(%rbp), %eax            /*Pass value of variable 'n1' into eax*/
	movl	%edx, %esi                 /*Copy edx into esi*/
	movl	%eax, %edi                 /*Copy eax into edi*/ /*We copy first two arguments into esi and edi to call GCD as function parameters are passed in esi and edi*/
	call	GCD                        /*call function GCD*/
	movl	%eax, -12(%rbp)            /*store the result of GCD (variable 't1') (ie, eax) onto stack*/
	movl	-32(%rbp), %edx            /*Pass the value of variable 'n4' into edx*/
	movl	-28(%rbp), %eax            /*Pass the value of variable 'n3' into eax*/
	movl	%edx, %esi                 /*Copy edx into esi*/
	movl	%eax, %edi                 /*Copy eax into edi*/
	call	GCD                        /*call function GCD*/
	movl	%eax, -8(%rbp)             /*store the result of GCD (variable 't2') (ie, eax) onto stack*/
	movl	-8(%rbp), %edx             /*Pass value of variable 't1' into edx*/
	movl	-12(%rbp), %eax            /*Pass value of variable 't2' into eax*/
	movl	%edx, %esi                 /*Copy edx into esi*/
	movl	%eax, %edi                 /*Copy eax into edi*/ 
	call	GCD                        /*call function GCD with arguments as esi and edi(ie, variables 't1' and 't2')*/
	movl	%eax, -4(%rbp)             /*store the final result (variable 't3') (ie, eax ) onto stack/
	movl	-4(%rbp), %eax             /*redundant step*/
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	GCD4, .-GCD4
	.globl	GCD
	.type	GCD, @function
GCD:                                      /*this is a leaf function(does not call any other function) hence it does not create space for itself*/
.LFB2:
	.cfi_startproc
	endbr64
	pushq	%rbp       
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp          
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)
	movl	%esi, -24(%rbp)
	jmp	.L6                        /*Jump to label L6*/
.L7:                                      /*L7 - body of while loop*/
	movl	-20(%rbp), %eax           /*Put num1 into eax*/
	cltd                    
	idivl	-24(%rbp)                 /*Divide num1 by num2*/
	movl	%edx, -4(%rbp)            /*temp was in edx, moved onto the stack at -4(%rbp)*/
	movl	-24(%rbp), %eax           /*Move value at -24(%rbp) into eax*/
	movl	%eax, -20(%rbp)           /*Move value of eax into -20(%rbp)*/ /*Lines 115 ans 116 basically copy value of num2 into num1*/
	movl	-4(%rbp), %eax            /*Move value at -4(%rbp) into eax*/
	movl	%eax, -24(%rbp)           /*Move value of eax into -4(%rbp)*/  /*Lines 117 and 118 basically copy value of temp into num2*/
.L6:
	movl	-20(%rbp), %eax           /*Pick num1 and put into eax*/
	cltd                              /*converts the signed long in eax to a signed double long in edx*/
	idivl	-24(%rbp)                 /*i divide l*/ /*(divisor is -24(%rbp) which is num2*/  
	movl	%edx, %eax                /*Move remainder to eax*/
	testl	%eax, %eax                /*testl - bitwise and operator --> similar to comparing eax with 0*/
	jne	.L7                         /*Jump if not equal (jne) --> jump if not zero --> jump to label L7*/
	movl	-24(%rbp), %eax           /*Can come here only if while loop terminates --> take value of num2 ( at -24(%rbp) ) and copy to eax and return*/
	popq	%rbp                      /*pop rbp*/
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	GCD, .-GCD
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
