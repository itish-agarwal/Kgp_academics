	.file	"output.s"

.STR0:	.string "TEST FILE 5 running....\n\n"
.STR1:	.string "Program to reverse a number\n\n"
.STR2:	.string "Enter the number: "
.STR3:	.string "\n"
.STR4:	.string "Number on reversing becomes : "
.STR5:	.string "\n"
	.text
	.globl	reverse
	.type	reverse, @function
reverse:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$68, %rsp
	movl	%edi, -4(%rbp)
# 0:res = t000 
	movl	$0, -16(%rbp)
# 1:res = ans argument1 = t000 
	movl	-16(%rbp), %eax
	movl	%eax, -8(%rbp)
# 2:res = t001 argument1 = t000 
	movl	-16(%rbp), %eax
	movl	%eax, -20(%rbp)
# 3:res = t002 
.L3:
	movl	$0, -24(%rbp)
# 4:argument1 = n argument2 = t002 
	movl	-4(%rbp), %eax
	movl	-24(%rbp), %edx
	cmpl	%edx, %eax
	jg .L1
# 5:
	jmp .L2
# 6:
	jmp .L2
# 7:res = t003 
.L1:
	movl	$10, -28(%rbp)
# 8:res = t004 argument1 = n argument2 = t003 
	movl	-4(%rbp), %eax
	cltd
	idivl	-28(%rbp), %eax
	movl	%edx, -32(%rbp)
# 9:res = rem argument1 = t004 
	movl	-32(%rbp), %eax
	movl	%eax, -12(%rbp)
# 10:res = t005 argument1 = t004 
	movl	-32(%rbp), %eax
	movl	%eax, -36(%rbp)
# 11:res = t006 
	movl	$10, -40(%rbp)
# 12:res = t007 argument1 = ans argument2 = t006 
	movl	-8(%rbp), %eax
	imull	-40(%rbp), %eax
	movl	%eax, -44(%rbp)
# 13:res = ans argument1 = t007 
	movl	-44(%rbp), %eax
	movl	%eax, -8(%rbp)
# 14:res = t008 argument1 = t007 
	movl	-44(%rbp), %eax
	movl	%eax, -48(%rbp)
# 15:res = t009 argument1 = ans argument2 = rem 
	movl	-8(%rbp), %eax
	movl	-12(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -52(%rbp)
# 16:res = ans argument1 = t009 
	movl	-52(%rbp), %eax
	movl	%eax, -8(%rbp)
# 17:res = t010 argument1 = t009 
	movl	-52(%rbp), %eax
	movl	%eax, -56(%rbp)
# 18:res = t011 
	movl	$10, -60(%rbp)
# 19:res = t012 argument1 = n argument2 = t011 
	movl	-4(%rbp), %eax
	cltd
	idivl	-60(%rbp), %eax
	movl	%eax, -64(%rbp)
# 20:res = n argument1 = t012 
	movl	-64(%rbp), %eax
	movl	%eax, -4(%rbp)
# 21:res = t013 argument1 = t012 
	movl	-64(%rbp), %eax
	movl	%eax, -68(%rbp)
# 22:
	jmp .L3
# 23:res = ans 
.L2:
	movl	-8(%rbp), %eax
	jmp	.LRT0
.LRT0:
	addq	$-68, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	reverse, .-reverse
	.globl	main
	.type	main, @function
main:
.LFB1:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
# 24:res = t014 
	movl	$1, -12(%rbp)
# 25:res = phi argument1 = t014 
	movl	-12(%rbp), %eax
	movl	%eax, -8(%rbp)
# 26:
	movq	$.STR0,	%rdi
# 27:res = t015 
	pushq %rbp
	call	printStr
	movl	%eax, -16(%rbp)
	addq $0 , %rsp
# 28:
	movq	$.STR1,	%rdi
# 29:res = t016 
	pushq %rbp
	call	printStr
	movl	%eax, -20(%rbp)
	addq $0 , %rsp
# 30:
	movq	$.STR2,	%rdi
# 31:res = t017 
	pushq %rbp
	call	printStr
	movl	%eax, -24(%rbp)
	addq $0 , %rsp
# 32:res = t018 argument1 = phi 
	leaq	-8(%rbp), %rax
	movq	%rax, -32(%rbp)
# 33:res = t018 
# 34:res = t019 
	pushq %rbp
	movq	-32(%rbp), %rdi
	call	readInt
	movl	%eax, -36(%rbp)
	addq $0 , %rsp
# 35:res = n argument1 = t019 
	movl	-36(%rbp), %eax
	movl	%eax, -4(%rbp)
# 36:res = t020 argument1 = t019 
	movl	-36(%rbp), %eax
	movl	%eax, -40(%rbp)
# 37:
	movq	$.STR3,	%rdi
# 38:res = t021 
	pushq %rbp
	call	printStr
	movl	%eax, -44(%rbp)
	addq $0 , %rsp
# 39:
	movq	$.STR4,	%rdi
# 40:res = t022 
	pushq %rbp
	call	printStr
	movl	%eax, -48(%rbp)
	addq $0 , %rsp
# 41:res = n 
# 42:res = t023 
	pushq %rbp
	movl	-4(%rbp) , %edi
	call	reverse
	movl	%eax, -52(%rbp)
	addq $0 , %rsp
# 43:res = t023 
# 44:res = t024 
	pushq %rbp
	movl	-52(%rbp) , %edi
	call	printInt
	movl	%eax, -56(%rbp)
	addq $0 , %rsp
# 45:
	movq	$.STR5,	%rdi
# 46:res = t025 
	pushq %rbp
	call	printStr
	movl	%eax, -60(%rbp)
	addq $0 , %rsp
# 47:res = t026 
	movl	$0, -64(%rbp)
# 48:res = t026 
	movl	-64(%rbp), %eax
	jmp	.LRT1
.LRT1:
	addq	$-64, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE1:
	.size	main, .-main
