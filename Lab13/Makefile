CFLAGS = -Wall -g -O2
CXX = g++
LIBS = -lm

all: transpose filter

main-transpose.o: main-transpose.c transpose.h
	$(CXX) $(CFLAGS) -c main-transpose.c

transpose.o: transpose.c transpose.h
	$(CXX) $(CFLAGS) -c transpose.c

transpose: main-transpose.o transpose.o
	$(CXX) $(CFLAGS) main-transpose.o transpose.o -o transpose

filter.o: filter.c filter.h
	$(CXX) $(CFLAGS) -c filter.c

main-filter.o: main-filter.c filter.h
	$(CXX) $(CFLAGS) -c main-filter.c

filter: main-filter.o filter.o 
	$(CXX) $(CFLAGS) main-filter.o filter.o -o filter

clean:
	rm -f *.o *.exe transpose filter
