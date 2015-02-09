// a code generator for the ALU chain in the 32-bit ALU
// see example_generator.cpp for inspiration

// make generator
// ./generator

#include<stdio.h>

int main() {
int width =32;

for(int i = 2; i < width; i++)
printf(" alu1 a%d(out[%d], cout[%d], A[%d], B[%d], cout[%d], control);\n", i, i, i, i, i, i-1);
  
  printf("   wire  [%d:1] chain;\n\n", width - 1);

  printf("   or o1(chain[1], out[0], out[1]);\n");
  for (int i = 2 ; i < width ; i ++) {
    printf("   or o%d(chain[%d], out[%d], chain[%d]);\n", i, i, i, i-1);
  }
  printf("   not n0(zero, chain[%d]);\n", width - 1);

  return 0;
}
