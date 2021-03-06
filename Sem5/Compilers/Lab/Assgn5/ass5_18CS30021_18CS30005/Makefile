#   Compiler lab assignment 5
#   Group number 47
#   Itish Agarwal - 18CS30021
#   Aditya Singh  - 18CS30005 

all: a.out
	
	@echo "\nTranslating Test File 1 ....."
	./a.out < ass5_18CS30021_18CS30005_test1.c > ass5_18CS30021_18CS30005_quads1.out
	@echo "\nTest File 1 Translated successfully!\n"
	@echo "Translating Test File 2 ....."
	./a.out < ass5_18CS30021_18CS30005_test2.c > ass5_18CS30021_18CS30005_quads2.out
	@echo "\nTest File 2 Translated successfully!\n"
	@echo "Translating Test File 3 ....."
	./a.out < ass5_18CS30021_18CS30005_test3.c > ass5_18CS30021_18CS30005_quads3.out
	@echo "\nTest File 3 Translated successfully!\n"
	@echo "Translating Test File 4 ....."
	./a.out < ass5_18CS30021_18CS30005_test4.c > ass5_18CS30021_18CS30005_quads4.out
	@echo "\nTest File 4 Translated successfully!\n"
	@echo "Translating Test File 5 ....."
	./a.out < ass5_18CS30021_18CS30005_test5.c > ass5_18CS30021_18CS30005_quads5.out
	@echo "\nTest File 5 Translated successfully!\n"
	@echo "\nAll test files are successfully translated !! The outputs are stored in the quads files\n"

a.out: lex.yy.o y.tab.o ass5_18CS30021_18CS30005_translator.o
	g++ lex.yy.o y.tab.o ass5_18CS30021_18CS30005_translator.o -lfl

ass5_18CS30021_18CS30005_translator.o: ass5_18CS30021_18CS30005_translator.cxx ass5_18CS30021_18CS30005_translator.h
	g++ -c ass5_18CS30021_18CS30005_translator.h
	g++ -c ass5_18CS30021_18CS30005_translator.cxx

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

y.tab.o: y.tab.c
	g++ -c y.tab.c

lex.yy.c: ass5_18CS30021_18CS30005.l y.tab.h ass5_18CS30021_18CS30005_translator.h
	flex ass5_18CS30021_18CS30005.l

y.tab.c: ass5_18CS30021_18CS30005.y
	yacc -dtv ass5_18CS30021_18CS30005.y -Wno

y.tab.h: ass5_18CS30021_18CS30005.y
	yacc -dtv ass5_18CS30021_18CS30005.y -Wno

clean:
	rm lex.yy.c y.tab.c y.tab.h lex.yy.o y.tab.o ass5_18CS30021_18CS30005_translator.o y.output a.out ass5_18CS30021_18CS30005_translator.h.gch
