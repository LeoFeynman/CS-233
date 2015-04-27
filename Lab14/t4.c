#include "declarations.h"

#pragma auto_inline(off)
void 
t4(float**  M1, float** M2, float** M3) {
	for (int nl = 0 ; nl < ntimes/(10*LEN4) ; nl ++) {
		for (int i = 0 ; i < LEN4 ; i ++) {
			for (int j = 0 ; j < LEN4 ; j ++) {
				for (int k = 0 ; k < LEN4 ; k ++) {
					M3[i][j] += M1[i][k] * M2[k][j];
				}
			}
		}
		M3[0][0] ++;
	}
}
