/**
 * pi_calc.h
 */
#include <omp.h>
#define NUM_THREADS 32

double serialCalculatePi( long num_steps );
double parallelcalculatePi( long num_steps );
double parallelfalsecalculatePi( long num_steps);
