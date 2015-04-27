GCC = g++
GCCFLAGS = -Wall -g -msse -mfpmath=sse -O2

ICC = icpc
ICCFLAGS = -Wall -g -O2 -restrict
VECTOR_FLAGS = -vec-report2
NO_VECTOR_FLAGS = -no-vec

.PHONY: all
all: mv-mult mandelbrot t1-scalar t1-vector t2-scalar t2-vector t3-scalar t3-vector t4-scalar t4-vector t5-scalar t5-vector t6-scalar t6-vector

mv-mult-main.o: mv-mult-main.cpp mv-mult.h
	$(GCC) $(GCCFLAGS) -c mv-mult-main.cpp

mv-mult.o: mv-mult.cpp mv-mult.h
	$(GCC) $(GCCFLAGS) -c mv-mult.cpp

mv-mult: mv-mult-main.o mv-mult.o
	$(GCC) $(GCCFLAGS) mv-mult-main.o mv-mult.o -o mv-mult

mandelbrot-main.o: mandelbrot-main.cpp mandelbrot.h bmp.h
	$(GCC) $(GCCFLAGS) -c mandelbrot-main.cpp

mandelbrot.o: mandelbrot.cpp mandelbrot.h
	$(GCC) $(GCCFLAGS) -c mandelbrot.cpp

bmp.o: bmp.cpp bmp.h
	$(GCC) $(GCCFLAGS) -c bmp.cpp

mandelbrot: mandelbrot-main.o mandelbrot.o bmp.o
	$(GCC) $(GCCFLAGS) mandelbrot-main.o mandelbrot.o bmp.o -o mandelbrot

######  t1

t1-scalar: t1-main.c
	$(ICC) $(ICCFLAGS) $(NO_VECTOR_FLAGS) -DSCALAR t1-main.c -o t1-scalar

t1-main.o: t1-main.c 
	$(ICC) $(ICCFLAGS) $(NO_VECTOR_FLAGS) -c t1-main.c

t1-vector.o: t1.c
	$(ICC) $(ICCFLAGS) $(VECTOR_FLAGS) -c t1.c -o t1-vector.o

t1-vector: t1-main.o t1-vector.o
	$(ICC) $(ICCFLAGS) t1-main.o t1-vector.o -o t1-vector

######  t2

t2-scalar: t2-main.c
	$(ICC) $(ICCFLAGS) $(NO_VECTOR_FLAGS) -DSCALAR t2-main.c -o t2-scalar

t2-main.o: t2-main.c 
	$(ICC) $(ICCFLAGS) $(NO_VECTOR_FLAGS) -c t2-main.c

t2-vector.o: t2.c
	$(ICC) $(ICCFLAGS) $(VECTOR_FLAGS) -c t2.c -o t2-vector.o

t2-vector: t2-main.o t2-vector.o
	$(ICC) $(ICCFLAGS) t2-main.o t2-vector.o -o t2-vector

######  t3

t3-scalar: t3-main.c
	$(ICC) $(ICCFLAGS) $(NO_VECTOR_FLAGS) -DSCALAR t3-main.c -o t3-scalar

t3-main.o: t3-main.c 
	$(ICC) $(ICCFLAGS) $(NO_VECTOR_FLAGS) -c t3-main.c

t3-vector.o: t3.c
	$(ICC) $(ICCFLAGS) $(VECTOR_FLAGS) -c t3.c -o t3-vector.o

t3-vector: t3-main.o t3-vector.o
	$(ICC) $(ICCFLAGS) t3-main.o t3-vector.o -o t3-vector

######  t4

t4-scalar: t4-main.c
	$(ICC) $(ICCFLAGS) $(NO_VECTOR_FLAGS) -DSCALAR t4-main.c -o t4-scalar

t4-main.o: t4-main.c 
	$(ICC) $(ICCFLAGS) $(NO_VECTOR_FLAGS) -c t4-main.c

t4-vector.o: t4.c
	$(ICC) $(ICCFLAGS) $(VECTOR_FLAGS) -c t4.c -o t4-vector.o

t4-vector: t4-main.o t4-vector.o
	$(ICC) $(ICCFLAGS) t4-main.o t4-vector.o -o t4-vector

######  t5

t5-scalar: t5-main.c
	$(ICC) $(ICCFLAGS) $(NO_VECTOR_FLAGS) -DSCALAR t5-main.c -o t5-scalar

t5-main.o: t5-main.c 
	$(ICC) $(ICCFLAGS) $(NO_VECTOR_FLAGS) -c t5-main.c

t5-vector.o: t5.c
	$(ICC) $(ICCFLAGS) $(VECTOR_FLAGS) -c t5.c -o t5-vector.o

t5-vector: t5-main.o t5-vector.o
	$(ICC) $(ICCFLAGS) t5-main.o t5-vector.o -o t5-vector

######  t6

t6-scalar: t6-main.c
	$(ICC) $(ICCFLAGS) $(NO_VECTOR_FLAGS) -DSCALAR t6-main.c -o t6-scalar

t6-main.o: t6-main.c 
	$(ICC) $(ICCFLAGS) $(NO_VECTOR_FLAGS) -c t6-main.c

t6-vector.o: t6.c
	$(ICC) $(ICCFLAGS) $(VECTOR_FLAGS) -c t6.c -o t6-vector.o

t6-vector: t6-main.o t6-vector.o
	$(ICC) $(ICCFLAGS) t6-main.o t6-vector.o -o t6-vector

clean:
	rm -f mv-mult mandelbrot t*-scalar t*-vector *.o *.exe
