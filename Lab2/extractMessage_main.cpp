/**
 * @file
 * This file contains code to run your extractMessage function
 * against a picture to facilitate testing.
 *
 * We will not look at this file during grading, so don't put code
 * you want graded here.
 */



#include <exception>
#include <iostream>
#include "bmp.h"
#include "extractMessage.h"

using namespace std;

int main(int argc, char * argv[]) {
	if (argc != 2) {
		cerr << "Usage: " << argv[0] << " image_file.bmp\n";
		return 1;
	}

	try {
		bmp image(argv[1]);
		string message = extractMessage(image);
		cout << message << "\n";
	} catch (const exception & e) {
		cerr << e.what() << "\n";
		return 1;
	}
}
