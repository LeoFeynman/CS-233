#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <math.h>

#define ntimes 100000

void t1(float *A, float *B);

void t2(float* restrict A, float* restrict B);

void t3(float A[512][512]);

#define LEN4 256
void t4(float** M1, float** M2, float** M3);

#define LEN5 1024
void t5(float* restrict A, float* restrict B, float* restrict C, float* restrict D, float* restrict E);

#define LEN6 1024
void t6(float* A, float* D);
