/**
 * @file
 * Contains the implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include "extractMessage.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

using namespace std;

string extractMessage(const bmp & image) {
	string message;
	unsigned char tempChar = 0x00;
	int width = getWidth(bmp);
	int height = getHeight(bmp);
	int flag = 0;
	int counter = 0;

  	for (int y = 0 ; y < height &&flag!=1; y++) 
  	{
	 	for (int x = 0 ; x < width &&flag!=1; x++) 
		{
			pixel p = getPixel(bmpfile, x, y);	
			unsigned char g=p.green;

			unsigned char lsb=g&0x01;
			int tempNum=7-counter;
			tempChar=tempChar|(lsb<<tempNum);
			if(counter==7)
			{
				char c=tempChar;
				printf("%c",c);
				
				if(tempChar==0x00){
					flag=1;

				}
				counter=0;
				tempChar=tempChar&0x00;
			}
			else
			{
				counter++;
			}
		}
  	}
 
        message = string(tempChar);
	return message;
}
