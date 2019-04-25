#include <stdio.h>

#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"

int main() {

	while(1){
		
		int numberToDisplay = (read_slider_switches_ASM() & 15); // store the state of the first 4 switches in numberToDisplay
		int keyState = read_PB_data_ASM(); // store state of key/push buttons
		
		// map the slider switches to the leds
		write_LEDs_ASM(read_slider_switches_ASM());
		
		// if slider 9 is up then clear all the hex displays
		if(read_slider_switches_ASM() >= 512){
			HEX_clear_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5);	
		}else{
			//flood HEX display 4 and 5
			HEX_flood_ASM(HEX4 | HEX5);

			// check if each pushbutton is pressed, if so then diplay the number represented by
			// the first 4 slider switches on the corresponding HEX display
			
			switch(keyState) {
			
			case 0:
				HEX_clear_ASM(HEX0 | HEX1 | HEX2 | HEX3);
				break;
			case 1:
				HEX_write_ASM(HEX0, numberToDisplay);
				HEX_clear_ASM(HEX1 | HEX2 | HEX3);
				break;
			case 2:
				HEX_write_ASM(HEX1, numberToDisplay);
				HEX_clear_ASM(HEX0 | HEX2 | HEX3);
				break;
			case 3:
				HEX_write_ASM(HEX0 | HEX1, numberToDisplay);
				HEX_clear_ASM(HEX2 | HEX3);
				break;
			case 4:
				HEX_write_ASM(HEX2, numberToDisplay);
				HEX_clear_ASM(HEX0 | HEX1 | HEX3);
				break;
			case 5:
				HEX_write_ASM(HEX0 | HEX2, numberToDisplay);
				HEX_clear_ASM(HEX1 | HEX3);
				break;
			case 6:
				HEX_write_ASM(HEX1 | HEX2, numberToDisplay);
				HEX_clear_ASM(HEX0 | HEX3);
				break;
			case 7:
				HEX_write_ASM(HEX0 | HEX1 | HEX2, numberToDisplay);
				HEX_clear_ASM(HEX3);
				break;
			case 8:
				HEX_write_ASM(HEX3, numberToDisplay);
				HEX_clear_ASM(HEX0 | HEX1 | HEX2);
				break;
			case 9:
				HEX_write_ASM(HEX0 | HEX3, numberToDisplay);
				HEX_clear_ASM(HEX1 | HEX2);
				break;
			case 10:
				HEX_write_ASM(HEX1 | HEX3, numberToDisplay);
				HEX_clear_ASM(HEX0 | HEX2);
				break;
			case 11:
				HEX_write_ASM(HEX0 | HEX1 | HEX3, numberToDisplay);
				HEX_clear_ASM(HEX2);
				break;
			case 12:
				HEX_write_ASM(HEX3 | HEX2, numberToDisplay);
				HEX_clear_ASM(HEX0 | HEX1);
				break;
			case 13:
				HEX_write_ASM(HEX0 | HEX2 | HEX3, numberToDisplay);
				HEX_clear_ASM(HEX1);
				break;
			case 14:
				HEX_write_ASM(HEX1 | HEX2 | HEX3, numberToDisplay);
				HEX_clear_ASM(HEX0);
				break;
			case 15:
				HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3, numberToDisplay);
				break;

			}
		}
	}
	
	return 0;
}
