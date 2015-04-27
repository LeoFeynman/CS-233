#include "declarations.h"

void 
t1(float* A, float* B) {
	for (int nl = 0; nl < 1000000; nl ++){
		for (int i = 0; i < 1024; i += 2) {
			A[i+1] = (A[i] + B[i]) / (A[i] + B[i] + 1.);
		}
		B[0] ++;
	}
}
