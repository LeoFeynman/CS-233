#include "declarations.h"

#pragma auto_inline(off)
void 
t3(float A[512][512]) {
	for (int nl = 0 ; nl < 1000 ; nl ++) {
		for (int i = 1 ; i < 512 ; i ++) {
			for (int j = 1 ; j < 512 ; j ++) {
				A[i][j] = A[i-1][j] + A[i][j-1];
			}
		}
		A[0][0] ++;
	}
}
