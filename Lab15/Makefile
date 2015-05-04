COMPILER = g++
LINKER = g++
EXENAME = picalc

FLAGS = -fopenmp -Wall -Werror -g

all: $(EXENAME)

$(EXENAME) : pi_calc.h main.c pi_calc.o
	$(LINKER) -o $(EXENAME) $(FLAGS) main.c pi_calc.o

pi_calc.o : pi_calc.h pi_calc.c
	$(COMPILER) $(FLAGS) -c pi_calc.c

clean:
	rm -rf *.o $(EXENAME)
