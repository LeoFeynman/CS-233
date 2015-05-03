#include <xmmintrin.h>
#include "mandelbrot.h"

// mandelbrot() takes a set of SIZE (x,y) coordinates - these are actually
// complex numbers (x + yi), but we can also view them as points on a plane.
// It then runs 200 iterations of f, using the (x,y) point, and checks
// the magnitude of the result.  If the magnitude is over 2.0, it assumes
// that the function will diverge to infinity.

// vectorize the below code using SIMD intrinsics
int *
mandelbrot_vector(float x[SIZE], float y[SIZE]) {
	static int ret[SIZE];
	float temp[4];
	_m128 x1, x2, y1, y2, xx, yy, xy, X, Y, num2, x2sq, y2sq, acc;
	for (int i = 0 ; i < SIZE ; i ++) {
		x1 = y1 = _mm_set1_ps(0.0);
		num2 = _mm_set1_ps(2.0);
		// Run M_ITER iterations
		for (int j = 0 ; j < M_ITER ; j ++) {
			// Calculate the real part of (x1 + y1 * i)^2 + (x + y * i)
			//x2 = (x1 * x1) - (y1 * y1) + x[i];
			X = _mm_loadu_ps(&x[i]);
			xx = _mm_mul_ps(x1, x1);
			yy = _mm_mul_ps(y1, y1);
			x2 = _mm_sub_ps(xx, yy);
			x2 = _mm_add_ps(x2, X);
			// Calculate the imaginary part of (x1 + y1 * i)^2 + (x + y * i)
			//y2 = 2 * (x1 * y1) + y[i];
			Y = _mm_loadu_ps(&y[i]);
			xy = _mm_mul_ps(x1, y1);
			xy = _mm_mul_ps(num2, xy);
			y2 = _mm_add_ps(xy, Y);
			// Use the new complex number as input for the next iteration
			x1 = x2;
			y1 = y2;
		}

		// caculate the magnitude of the result
		// We could take the square root, but instead we just
		// compare squares
		//ret[i] = ((x2 * x2) + (y2 * y2)) < (M_MAG * M_MAG);
		x2sq = _mm_mul_ps(x2, x2);
		y2sq = _mm_mul_ps(y2, y2);
		acc = _mm_add_ps(x2sq, y2sq);
		m_magsq = _mm_mul_ps(M_MAG, M_MAG);
		acc = _mm_cmplt_ps(acc, m_magsq);
		
		_mm_storeu_ps(temp, acc);
		ret[i] = temp[0];
		ret[i+1] = temp[1];
		ret[i+2] = temp[2];
		ret{i+3] = temp[3];
	}

	return ret;
}
