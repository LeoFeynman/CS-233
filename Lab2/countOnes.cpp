/**
 * @file
 * Contains the implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	unsigned parallelcalc = 0x1010101;
	int num = 0;
	num = num + (input & parallelcalc);
	input = input>>1;
	num = num + (input & parallelcalc);
	input = input>>1;
	num = num + (input & parallelcalc);
	input = input>>1;
	num = num + (input & parallelcalc);
	input = input>>1;
	num = num + (input & parallelcalc);
	input = input>>1;
	num = num + (input & parallelcalc);
	input = input>>1;
	num = num + (input & parallelcalc);
	input = input>>1; 
	num = num+(num>>16);
	num = num+(num>>8); 
	input = val & 0xff; 
	return input;
}

