#include "declarations.h"

void 
t6(float* A, float* D) {
	for (int nl = 0 ; nl < ntimes ; nl ++) {
		A[0] = 0;
		for (int i = 0 ; i < (LEN6-1); i ++) {
			A[i] = D[i] + (float)1.0;
			D[i+1] = A[i] + (float)2.0;
		}
	}      
}
