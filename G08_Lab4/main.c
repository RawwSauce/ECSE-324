#include <stdio.h>

#include "./drivers/inc/VGA.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"

void test_char(){
	int x,y;
	char c = 0;
	//write 1 char
	for(y=0;y<=59;y++)
		for(x=0;x<=79;x++)
			VGA_write_char_ASM(x,y,c++);
	
}
//write 2 char

void test_byte(){	
	int x,y;
	char c=0;
	for(y=0;y<=59;y++)
		for(x=0;x<=78;x+=3)
			VGA_write_byte_ASM(x,y,c++);
}

void test_pixel(){
	int x,y;
	unsigned short colour=0;
	for(y=0;y<=239;y++)
		for(x=0;x<=319;x++)
			VGA_draw_point_ASM(x,y,colour++);

}

// board samples at 48000 samples per
// so we can write 48000 times per sec
// so the while loop is going to run faster 48000 hz but we are bottlenecked at outputing audio at 48000hz
// we want to have a 100hz square wave input
// 48000/100 = 480 samples per onecycle of our square wave
// so 240 need to be high and 240 need to be low
void audio(){
	int i = 0;
	while(1){
		// try to write 240 high samples, we only increment i when we successfuly output audio, ie write audio outputs return 1
		for(i=0;i<240;i++){
			if(write_audio_data_ASM(0x00FFFFFF) == 0){// if we coulnt write a high sample then keep i at the same value
				i--;
			}
		}
		// similar logic for lows
		for(i=0;i<240;i++){
			if(write_audio_data_ASM(0x00000000) == 0){
				i--;
			}
		}
	}
}


//PART 1 ---------------------------------------------------------------------
/*
int main() {
		
	while(1){
		int keyState = read_PB_data_ASM(); // read and store state of key/push buttons
		int sliderState = read_slider_switches_ASM(); // read and store state of slider switches		
		
		switch(keyState){
			
			case 1:
				if(sliderState > 0){
					test_byte();
				}else{
					test_char();
				}
					break;

			case 2:
				test_pixel();
				break;

			case 4:
				VGA_clear_charbuff_ASM();
				break;
	
			case 8:
				VGA_clear_pixelbuff_ASM();
				break;

			default:
				break;
			
		}
		

	}
		
	return 0;

}
*/
//----------------------------------------------------------------------------


// PART 2 ------------------------------------------------------------------------
/*
int main() {
	
	int x = 0;
	int y =0;
	VGA_clear_charbuff_ASM();
			
	while(1){
		char data = 0;
		char *datapointer = &data;

		if(read_PS2_data_ASM(datapointer)){
			if(x<=78){
				// display read data and increment x
				VGA_write_byte_ASM(x,y,data);
				x+=3;
			}else{
				// reset x since we are at the end of a screen row
				// increment y to next row
				x = 0;
				y+=1;
				// if we reached the bottom of the screen reset y
				if(y>59){
					y = 0;
					VGA_clear_charbuff_ASM();
				}
				// display read data with updated coordinates
				VGA_write_byte_ASM(x,y,data);
			}
		}
	}
	return 0;
}
*/

// PART 3 --------------------------------------------------------------------------------------

int main(){
	audio();
	return 0;
}

//------------------------------------------------------------------------------
