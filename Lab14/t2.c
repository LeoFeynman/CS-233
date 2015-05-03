#include "declarations.h"

#pragma auto_inline(off)
void 
t2(float* restrict A, float* restrict B) {
	for (int nl = 0 ; nl < 10000000 ; nl ++) {
		for (int i = 0 ; i < 1280; i++) {
			A[i] = B[i] * A[i];
		}
		A[0] ++;
	}
}
