/**
 * @file
 * Contains example code for working with bmp objects.
 */

#include <exception>
#include <iostream>
#include "bmp.h"

using namespace std; // just to make those of you in 225 happy

/**
 * Takes an image and tints it blue.
 *
 * @param image The image to tint.
 * @return The tinted image.
 */
bmp tint_blue(bmp image) {
	int width = image.width();
	int height = image.height();
	for (int y = 0; y < height; ++y) {
		for (int x = 0; x < width; ++x) {
			pixel * p = image(x, y);
			p->blue = 255;
		}
	}
	return image;
}


/**
 * Takes an image and inverts its colors.
 *
 * @param image The image to invert.
 * @return The inverted image.
 */
bmp invert(bmp image) {
	int width = image.width();
	int height = image.height();
	for (int y = 0; y < height; ++y) {
		for (int x = 0; x < width; ++x) {
			pixel * p = image(x, y);
			p->red = ~p->red;
			p->green = ~p->green;
			p->blue = ~p->blue;
		}
	}
	return image;
}


/**
 * Takes an input image and produces two outputs - one tinted and one inverted.
 *
 * Don't worry about the exception handling - we take care of it for you in
 * main in p1.cpp. The two functions above should exhibit all the functionality
 * you need.
 */
int main(int argc, char * argv[]) {
	if (argc != 2) {
		cerr << "Usage: " << argv[0] << " image_file.bmp\n";
		return 1;
	}

	string image_name = argv[1];
	try {
		bmp image(image_name);
		bmp tinted_image = tint_blue(image);
		tinted_image.write_to_file("tinted_" + image_name);
		bmp inverted_image = invert(image);
		inverted_image.write_to_file("inverted_" + image_name);
	} catch (const exception & e) {
		cerr << e.what() << "\n";
		return 1;
	}
}
