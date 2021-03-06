a.out : 	main.o libtoylib.a
			g++ main.o -L. -ltoylib

main.o : 	main.cpp toylib.h
			g++ -Wall -c main.cpp

libtoylib.a : ass2_18CS30021.o
			ar -rcs libtoylib.a ass2_18CS30021.o

ass2_18CS30021.o : ass2_18CS30021.cpp toylib.h
			g++ -Wall -c ass2_18CS30021.cpp
