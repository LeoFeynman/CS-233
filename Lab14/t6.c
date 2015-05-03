#include "declarations.h"
// A[i] D[i+1]
// cannot be vectorized because D[i+1] depends on A[i]
void 
t6(float* A, float* D) {
	for (int nl = 0 ; nl < ntimes ; nl ++) {
		A[0] = 0;
		#pragma novector
		for (int i = 0 ; i < (LEN6-1); i ++) {
			A[i] = D[i] + (float)1.0;
			D[i+1] = A[i] + (float)2.0;
			
		}
	}      
}
