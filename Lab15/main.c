/**
 * main.cpp
 *
 * Main program for pi calculation.
 */

#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

#include "pi_calc.h"


int main( int argc, char ** argv ) { 
	if( argc < 2 ) {
		printf("Usage: ./pi STEPS");
		printf("\t where STEPS is the number of steps to run the approximation algorithm");
		return 0;
	}

	// find number of steps from cli parameter
	long num_steps = atol( argv[1] );
	printf("Running pi calculation with %ld steps\n", num_steps);

	// get our starting wall time
	double start_time = omp_get_wtime();
	// run our pi calculation, serially
	double pi = serialCalculatePi( num_steps );
	// get our finish wall time
	double serial_time = omp_get_wtime() - start_time;

	printf("Serial execution (1 thread): pi is %f, time is %f\n\n", pi, serial_time);
	
	// get our starting wall time
	start_time = omp_get_wtime();
	// run our pi calculation, this time in parallel
	pi =  parallelcalculatePi( num_steps );
	// get our finish wall time
	double parallel_time = omp_get_wtime() - start_time;
	
	printf("Parallel execution with %d threads: pi is %f, time is %f (speedup is %f)\n\n", 
			 omp_get_max_threads(), pi, parallel_time, (serial_time/parallel_time));	
	
	return 0;
}
