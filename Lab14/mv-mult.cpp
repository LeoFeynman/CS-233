#include <xmmintrin.h>
#include "mv-mult.h"

// Matrix-Vector multiplication
// mat is a SIZE by SIZE matrix, that is arranged in row-column, format,
// That is, you first select a particular row, and then a particular column.
// Each row is laid out as a one-dimensional, array, so if you wanted
// to select a particular row, you would use mat[row].  You can
// also select smaller intervals, by using &mat[row][col].
// The vector is also laid out as a one-dimensional arrow, similar to a row.
// M-V multiplication proceeds by taking the dot product of a matrix row
// with the vector, and doing this for each row in the matrix

// vectorize the below code using SIMD intrinsics
float *
mv_mult_vector(float mat[SIZE][SIZE], float vec[SIZE]) {
	static float ret[SIZE];

	for (int i = 0 ; i < SIZE ; i++) {
		ret[i] = 0;
		for (int j = 0 ; j < SIZE ; j++) {
			ret[i] += mat[i][j] * vec[j];
		}
	}

	return ret;
}
