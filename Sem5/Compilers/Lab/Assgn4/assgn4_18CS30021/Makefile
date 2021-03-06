all: a.out assgn4_18CS30021_test.c 
	./a.out < assgn4_18CS30021_test.c

a.out: lex.yy.c y.tab.c assgn4_18CS30021.c
	gcc lex.yy.c y.tab.c assgn4_18CS30021_main.c -lfl

lex.yy.c: assgn4_18CS30021.l
	flex assgn4_18CS30021.l

y.tab.c: assgn4_18CS30021.y
	yacc -dtv assgn4_18CS30021.y

clean:
	rm lex.yy.c y.tab.c y.tab.h y.output a.out
