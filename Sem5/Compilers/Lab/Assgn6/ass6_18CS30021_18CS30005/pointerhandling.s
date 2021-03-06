	.file	"output.s"

.STR0:	.string "\n"
.STR1:	.string "\n"
.STR2:	.string "Test string 1\n"
.STR3:	.string "Test string 2\n"
.STR4:	.string "\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$121, %rsp
# 0:res = t000 
	movl	$5, -16(%rbp)
# 1:res = i argument1 = t000 
	movl	-16(%rbp), %eax
	movl	%eax, -12(%rbp)
# 2:res = t001 argument1 = i 
	leaq	-12(%rbp), %rax
	movq	%rax, -24(%rbp)
# 3:res = p argument1 = t001 
	movq	-24(%rbp), %rax
	movq	%rax, -8(%rbp)
# 4:res = t002 argument1 = t001 
	movq	-24(%rbp), %rax
	movq	%rax, -32(%rbp)
# 5:res = t003 
	movl	$45, -36(%rbp)
# 6:res = p argument1 = t003 
	movq	-8(%rbp), %rax
	movl	-36(%rbp), %edx
	movl	%edx, (%rax)
# 7:res = t004 argument1 = t003 
	movl	-36(%rbp), %eax
	movl	%eax, -40(%rbp)
# 8:res = i 
# 9:res = t005 
	pushq %rbp
	movl	-12(%rbp) , %edi
	call	printInt
	movl	%eax, -44(%rbp)
	addq $0 , %rsp
# 10:
	movq	$.STR0,	%rdi
# 11:res = t006 
	pushq %rbp
	call	printStr
	movl	%eax, -48(%rbp)
	addq $0 , %rsp
# 12:res = q argument1 = p 
	movq	-8(%rbp), %rax
	movq	%rax, -56(%rbp)
# 13:res = t007 
	movl	$120, -60(%rbp)
# 14:res = q argument1 = t007 
	movq	-56(%rbp), %rax
	movl	-60(%rbp), %edx
	movl	%edx, (%rax)
# 15:res = t008 argument1 = t007 
	movl	-60(%rbp), %eax
	movl	%eax, -64(%rbp)
# 16:res = i 
# 17:res = t009 
	pushq %rbp
	movl	-12(%rbp) , %edi
	call	printInt
	movl	%eax, -68(%rbp)
	addq $0 , %rsp
# 18:
	movq	$.STR1,	%rdi
# 19:res = t010 
	pushq %rbp
	call	printStr
	movl	%eax, -72(%rbp)
	addq $0 , %rsp
# 20:res = t011 
	movb	$90, -74(%rbp)
# 21:res = c argument1 = t011 
	movzbl	-74(%rbp), %eax
	movb	%al, -73(%rbp)
# 22:res = t012 argument1 = c 
	leaq	-73(%rbp), %rax
	movq	%rax, -90(%rbp)
# 23:res = d argument1 = t012 
	movq	-90(%rbp), %rax
	movq	%rax, -82(%rbp)
# 24:res = t013 argument1 = t012 
	movq	-90(%rbp), %rax
	movq	%rax, -98(%rbp)
# 25:res = t014 
	movb	$107, -99(%rbp)
# 26:res = d argument1 = t014 
	movq	-82(%rbp), %rax
	movl	-99(%rbp), %edx
	movl	%edx, (%rax)
# 27:res = t015 argument1 = t014 
	movzbl	-99(%rbp), %eax
	movb	%al, -100(%rbp)
# 28:res = t016 
	movb	$107, -101(%rbp)
# 29:argument1 = c argument2 = t016 
	movzbl	-73(%rbp), %eax
	cmpb	-101(%rbp), %al
	je .L1
# 30:
	jmp .L2
# 31:
	jmp .L3
# 32:
.L1:
	movq	$.STR2,	%rdi
# 33:res = t017 
	pushq %rbp
	call	printStr
	movl	%eax, -105(%rbp)
	addq $0 , %rsp
# 34:
	jmp .L3
# 35:
.L2:
	movq	$.STR3,	%rdi
# 36:res = t018 
	pushq %rbp
	call	printStr
	movl	%eax, -109(%rbp)
	addq $0 , %rsp
# 37:
	jmp .L3
# 38:res = i 
.L3:
# 39:res = t019 
	pushq %rbp
	movl	-12(%rbp) , %edi
	call	printInt
	movl	%eax, -113(%rbp)
	addq $0 , %rsp
# 40:
	movq	$.STR4,	%rdi
# 41:res = t020 
	pushq %rbp
	call	printStr
	movl	%eax, -117(%rbp)
	addq $0 , %rsp
# 42:res = t021 
	movl	$0, -121(%rbp)
# 43:res = t021 
	movl	-121(%rbp), %eax
	jmp	.LRT0
.LRT0:
	addq	$-121, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	main, .-main
