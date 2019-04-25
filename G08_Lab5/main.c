#include "./drivers/inc/vga.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/audio.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/wavetable.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/slider_switches.h"

//array to store the keys currently pressed
// initially no keys are pressed so set all elements to 0
int keysPressed[8] = {0,0,0,0,0,0,0,0};
//array holding the frequencies, index matched to the keys pressed
double frequencies[] = {130.813, 146.832, 164.814, 174.614, 195.998, 220.000, 246.942, 261.626};

fitParameter = 505000;

// Write names at the top of the screen
void drawWelcome(){
	//Screen is 79 x 59 in pixel dimensions
	VGA_write_char_ASM(0, 0, 'R');
	VGA_write_char_ASM(1, 0, 'e');
	VGA_write_char_ASM(2, 0, 'n');
	VGA_write_char_ASM(3, 0, 'e');

	VGA_write_char_ASM(5, 0, 'R');
	VGA_write_char_ASM(6, 0, 'e');
	VGA_write_char_ASM(7, 0, 'b');
	VGA_write_char_ASM(8, 0, 'e');
	VGA_write_char_ASM(9, 0, 'c');
	VGA_write_char_ASM(10, 0, 'c');
	VGA_write_char_ASM(11, 0, 'a');

	VGA_write_char_ASM(13, 0, 'M');
	VGA_write_char_ASM(14, 0, 'a');
	VGA_write_char_ASM(15, 0, 't');
	VGA_write_char_ASM(16, 0, 't');
	VGA_write_char_ASM(17, 0, 'h');
	VGA_write_char_ASM(18, 0, 'e');
	VGA_write_char_ASM(19, 0, 'w');

}

void drawWords(){
	int i = 0;
	VGA_write_char_ASM(70, 59, 'V');
	VGA_write_char_ASM(71, 59, 'o');
	VGA_write_char_ASM(72, 59, 'l');
	VGA_write_char_ASM(73, 59, 'u');
	VGA_write_char_ASM(74, 59, 'm');
	VGA_write_char_ASM(75, 59, 'e');
	VGA_write_char_ASM(76, 59, ':');
}


// method that returns the corresponding sine value for a particular frequency and time
double computeSignalSimple(double *freqToPlay, int t){
	int i;
	double signalSum = 0;

	for(i=0; i<8; i++){
		if(freqToPlay[i]){
			int index = ((((int) freqToPlay[i])*t)%48000);
			signalSum += sine[index];
		}
	}
	return signalSum;

}


int main() {
	
	char data = 0;
	int vol = 0;
	double freqToPlay[8] = {0,0,0,0,0,0,0,0};
	int keyReleasedFlag = 0;
	int t = 0;
	double totalSignal;
	int i;
	// setup interruptions
	int_setup(2, (int []){199});

	//create timer structure
	HPS_TIM_config_t hps_tim;

	// construct the timer struct for 10ms timer
	hps_tim.tim = TIM0; // use only one timer
	hps_tim.timeout = 20; // 1/48000 = 20.8 us
	hps_tim.LD_en = 1; // 1 means we want to enable loading the timer
	hps_tim.INT_en = 1; // 1 means we want to enable the timer to generate interruptions
	hps_tim.enable = 1; // means if we want to enable the timer

	// configure the hardware timer for 10ms timer
	HPS_TIM_config_ASM(&hps_tim);
	
	// clear screen and display info
	VGA_clear_charbuff_ASM();
	VGA_clear_pixelbuff_ASM();
	drawWelcome();
	drawWords();

	double history[320] = { 0 };
	
	// do look up table
	//2d array, 

	while(1) {
		
		//read keyboard 

		char *datapointer = &data;

		if(read_ps2_data_ASM(datapointer)){
		switch(data){
			case 0x1C: //A has been pressed
				// if a key was previously released, ie keyreleasedflag is 1
				// we now know it was the 'a' key that was released
				// and we set the associated bit with the 'a' key to 0 in the keypressed array
				// also reset the keypressed flag to 0 since we aknowledge the released key
				if(keyReleasedFlag == 1){
					keysPressed[0] = 0;
					keyReleasedFlag = 0;
				}else{// 'a' key has been pressed/is currently being pressed so set its associated bit to 1
					keysPressed[0] = 1;
				}
				break;
			case 0x1B: //S has been pressed
				if(keyReleasedFlag == 1){
					keysPressed[1] = 0;
					keyReleasedFlag = 0;
				}else{
					keysPressed[1] = 1;
				}
				break;
			case 0x23: //D
				if(keyReleasedFlag == 1){
					keysPressed[2] = 0;
					keyReleasedFlag = 0;
				}else{
					keysPressed[2] = 1;
				}
				break;	
			case 0x2B: //F
				if(keyReleasedFlag == 1){
					keysPressed[3] = 0;
					keyReleasedFlag = 0;
				}else{
					keysPressed[3] = 1;
				}
				break;
			case 0x3B: //J
				if(keyReleasedFlag == 1){
					keysPressed[4] = 0;
					keyReleasedFlag = 0;
				}else{
					keysPressed[4] = 1;
				}
				break;
			case 0x42: //K
				if(keyReleasedFlag == 1){
					keysPressed[5] = 0;
					keyReleasedFlag = 0;
				}else{
					keysPressed[5] = 1;
				}
				break;
			case 0x4B: //L
				if(keyReleasedFlag == 1){
					keysPressed[6] = 0;
					keyReleasedFlag = 0;
				}else{
					keysPressed[6] = 1;
				}
				break;
			case 0x4C: //;
				if(keyReleasedFlag == 1){
					keysPressed[7] = 0;
					keyReleasedFlag = 0;
				}else{
					keysPressed[7] = 1;
				}
				break;
			case 0xF0: //break code, ie a key has been released
				keyReleasedFlag = 1;
				break;
			case 0x55: //increase vol
				if(keyReleasedFlag == 1){
					if(vol<10){
						vol++;
					}
					keyReleasedFlag = 0;
				}
				break;
			case 0x4E: //decrease vol
				if(keyReleasedFlag == 1){
					if(vol>0){
						vol--;
					}
					keyReleasedFlag = 0;
				}
				break;
			
			default:
				keyReleasedFlag = 0;
			
		}
		}
		// clear freq to play array
		for(i=0;i<8;i++){
			freqToPlay[i] = 0;
		}
		
		// add the frequencies to be played
		for(i=0;i<8;i++){
			if(keysPressed[i]){//if a key is pressed
				freqToPlay[i] = frequencies[i];// add that frequencies to the array of freq to play
			}
		
		}
		// construct the signal
		totalSignal = vol*computeSignalSimple(freqToPlay,t);
		
		// play the signal			
		if(hps_tim0_int_flag == 1) {
			// Every 20 microseconds the timer flag goes high
			hps_tim0_int_flag = 0;// reset flag back to 0 since we assest the intertupt
			audio_write_data_ASM(totalSignal,totalSignal);
			t++;
		}
	
		// display the signal
		int drawIndex =0;
		double valToDraw = 0;
		if((t%12 == 0)){
				drawIndex = (t/12)%320;
				//clear previously drawn points
				VGA_draw_point_ASM(drawIndex, history[drawIndex], 0);
				
				//120 centers the signal on the screen, fitParameter makes it fit on the screen
				valToDraw = 120 + totalSignal/fitParameter;
				//add new points to history array
				history[drawIndex] = valToDraw;
				//draw new points
				VGA_draw_point_ASM(drawIndex, valToDraw, 63);		
		}
		
		// display the volume
		if(vol == 10){
			VGA_write_char_ASM(77, 59, '1');
			VGA_write_char_ASM(78, 59, '0');
		}else{
			VGA_write_char_ASM(77, 59, '0');
			VGA_write_char_ASM(78, 59, vol + 48);
		}

		// display the frequency		

		//reset signal
		totalSignal = 0;
		// reset time
		if(t==48000){
			t=0;
		}
		
	}

	return 0;
}
