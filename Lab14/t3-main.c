#include "declarations.h"

#ifdef SCALAR
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
#endif

int 
main() {
	float A[512][512] __attribute__ ((aligned(16)));
	for (int i = 0 ; i < 512 ; i ++) {
		for (int j = 0 ; j < 512 ; j ++) {
			A[i][j] = 0.1/(i+j+1);
		}
	}

	unsigned long long start_c, end_c, diff_c;
	start_c = _rdtsc();

	t3(A);

	end_c=_rdtsc();
	diff_c = end_c - start_c;
	float giga_cycle = diff_c / 1000000000.0;
	float ret = 0.;
	int i = 0;
	for (int i = 0 ; i < 4 ; i ++) {
		for (int j = 0 ; j < 512 ; j += 2) {
			ret += A[i][j] - A[i][j+1];
		}
	}
	printf("t3 took %f giga cycles and the result is: %f\n", giga_cycle, ret);
}
