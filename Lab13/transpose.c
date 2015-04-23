#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "transpose.h"

// will be useful
// remember that you shouldn't go over SIZE
using std::min;

// modify this function to add tiling
void 
transpose_tiled(int** src, int** dest) {
	int tiling_size = 32;
	for (int i = 0 ; i < SIZE ; i += tiling_size) { 
		for (int j = 0 ; j < SIZE ; j += tiling_size) {
			int min1 = SIZE;
			int min2 = SIZE;
			if(i + tiling_size < min1){
				min1 = i + tiling_size;
			}
			if(j + tiling_size < min2){
				min2 = j + tiling_size;
			}
			for (int p = i; p < min1; p++)
			{
				for(int q = j; q < min2; q++)
				{
					dest[p][q] = src[q][p];
				}
			}
		} 
	}
}	
