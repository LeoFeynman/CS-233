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
	float x1, y1, x2, y2;

	for (int i = 0 ; i < SIZE ; i ++) {
		x1 = y1 = 0.0;

		// Run M_ITER iterations
		for (int j = 0 ; j < M_ITER ; j ++) {
			// Calculate the real part of (x1 + y1 * i)^2 + (x + y * i)
			x2 = (x1 * x1) - (y1 * y1) + x[i];

			// Calculate the imaginary part of (x1 + y1 * i)^2 + (x + y * i)
			y2 = 2 * (x1 * y1) + y[i];

			// Use the new complex number as input for the next iteration
			x1 = x2;
			y1 = y2;
		}

		// caculate the magnitude of the result
		// We could take the square root, but instead we just
		// compare squares
		ret[i] = ((x2 * x2) + (y2 * y2)) < (M_MAG * M_MAG);
	}

	return ret;
}
