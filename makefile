#FC = gfortran -O2 -C
#FC = ifort -g -check noarg_temp_created -nowarn

all: add_basic.dll addtest_basic.c
	gcc -c -o addtest_basic.o addtest_basic.c
	gcc -o addtest_basic.exe -s addtest_basic.o -L. -ladd_basic

add_basic.dll: add_basic.f90
	gfortran -c add_basic.f90
	gfortran -shared -o add_basic.dll add_basic.o
	
clean :
	rm *.o *.dll *.exe
