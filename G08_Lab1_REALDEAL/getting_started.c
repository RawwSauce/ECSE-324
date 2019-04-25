#include "address_map_arm.h"

/* This program demonstrates the use of parallel ports in the DE1-SoC Computer
 * It performs the following: 
 * 	1. displays the SW switch values on the red lights LEDR
 * 	2. displays a rotating pattern on the HEX displays
 * 	3. if a KEY[3..0] is pressed, uses the SW switches as the pattern
*/
int main(void)
{
	int a[5] = {10,20,7,8,9};
	int size = SIZE_OF_ARRAY(a);
	int i;
	int max_val =0;
	for(i=0; i<size;i++){
		if(a[i]>max_val){
			max = a[i];
		}
	}
	return max_val; // returns the value to register R4 because first 3 values are used in the stack 
}
