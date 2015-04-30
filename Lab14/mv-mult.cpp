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
	__m128 acc, X, Y;
	acc = _mm_set1_ps(0.0);
	float temp[4];

	for (int i = 0 ; i < SIZE ; i++) {
		acc = _mm_set1_ps(0.0);
		ret[i] = 0;
		int j = 0; 
		while (j < (SIZE - 3)) {
			X = _mm_loadu_ps(&mat[i][j]);
			Y = _mm_loadu_ps(&vec[j]);
			acc = _mm_add_ps(acc, _mm_mul_ps(X, Y));
			j += 4;
		}
		_mm_storeu_ps(temp, acc);
		ret[i] = temp[0] + temp[1] + temp[2] + temp[3];

		while (j < SIZE){
			ret[i] += mat[i][j] * vec[j];
			j++;
		}

	}

	return ret;
}
