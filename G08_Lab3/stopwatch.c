#include <stdio.h>
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/HPS_TIM.h"

int main(){
	//create counters
	int count10_ms = 0;
	int count100_ms = 0;
	int count1_sec = 0;
	int count10_sec = 0;
	int count1_min = 0;
	int count10_min = 0;
		
	int flag1 = 0;
	int flag2 = 0;
	int flag3 = 0;
	int flag4 = 0;
	int flag5 = 0;

	int run = 1;

	//create timer structures
	HPS_TIM_config_t hps_tim;
	HPS_TIM_config_t hps_tim_pb;
	
	// construct the timer struct for 10ms timer
	hps_tim.tim = TIM0; // use only one timer
	hps_tim.timeout = 10000; // 10ms timeouts
	hps_tim.LD_en = 1; // 1 means we want to enable loading the timer
	hps_tim.INT_en = 1; // 1 means we want to enable the timer to generate interruptions
	hps_tim.enable = 1; // means if we want to enable the timer

	// configure the hardware timer for 10ms timer
	HPS_TIM_config_ASM(&hps_tim);

	// construct the timer struct for 4ms timer
	hps_tim_pb.tim = TIM1; // use only one timer
	hps_tim_pb.timeout = 4000; // 4ms timeouts
	hps_tim_pb.LD_en = 1;
	hps_tim_pb.INT_en = 1;
	hps_tim_pb.enable = 1;
	
	// configure the hardware timer for 4ms timer
	HPS_TIM_config_ASM(&hps_tim_pb);

	while(1){
	
		//start counter if pushbutton 0 is pressed
		if(read_PB_data_ASM() == 1){
			
			run = 1;
	
			//stop timer if reset button is pressed
			while(read_PB_data_ASM() != 4){
				
				// if start button is pressed run
				if(read_PB_data_ASM() == 1){
					run = 1;
				}
				
				// if stop button is pressed dont run
				if(read_PB_data_ASM() == 2){
					run = 0;
				}
		
				if(run){
					// poll timer to know if 10 ms has passed
					//if 10ms has passed then increment counters
					if(HPS_TIM_read_INT_ASM(TIM0)){
						//reset timer interrupt register
						HPS_TIM_clear_INT_ASM(TIM0);
						count10_ms = count10_ms + 1;
					
						// if we reached 100ms then reset 10ms counter and set flag1 up
						if(count10_ms == 10){
							count10_ms = 0;
							flag1 = 1;
						}
					}
				
					// increment 100ms counter
					if(flag1){
						flag1 = 0;
						count100_ms = count100_ms + 1;
						// if we reached 1s then reset 100ms counter and set flag2 up
						if(count100_ms == 10){
							count100_ms = 0;
							flag2 = 1;
						}
					}

					if(flag2){
						flag2 = 0;
						count1_sec = count1_sec + 1;
						// if we reached 10s then reset 1s counter and set flag3 up
						if(count1_sec == 10){
							count1_sec = 0;
							flag3 = 1;
						}
					}
	
					if(flag3){
						flag3 = 0;
						count10_sec = count10_sec + 1;
						// if we reached 60s then reset 10s counter and set flag4 up
						if(count10_sec == 6){
							count10_sec = 0;
							flag4 = 1;
						}
					}
		
					if(flag4){
						flag4 = 0;
						count1_min = count1_min + 1;
						// if we reached 10m then reset 1min counter and set flag5 up
						if(count1_min == 10){
							count1_min = 0;
							flag5 = 1;
						}
					}	

					if(flag5){
						flag5 = 0;
						count10_min = count10_min + 1;
						// if we reached 60m then reset 10min counter and reset all counters
						if(count10_min == 6){
							count10_min = 0;
							count10_ms = 0;
							count100_ms = 0;
							count1_sec = 0;
							count10_sec = 0;
							count1_min = 0;
						}
					}
				}
				// display counters
				HEX_write_ASM(HEX0, count10_ms);
				HEX_write_ASM(HEX1, count100_ms);
				HEX_write_ASM(HEX2, count1_sec);
				HEX_write_ASM(HEX3, count10_sec);
				HEX_write_ASM(HEX4, count1_min);
				HEX_write_ASM(HEX5, count10_min);
			}
		}
		
		//reset counter if pushbutton 2 is pressed
		if(read_PB_data_ASM() == 4){
			count10_min = 0;
			count10_ms = 0;
			count100_ms = 0;
			count1_sec = 0;
			count10_sec = 0;
			count1_min = 0;
			HEX_write_ASM(HEX0, count10_ms);
			HEX_write_ASM(HEX1, count100_ms);
			HEX_write_ASM(HEX2, count1_sec);
			HEX_write_ASM(HEX3, count10_sec);
			HEX_write_ASM(HEX4, count1_min);
			HEX_write_ASM(HEX5, count10_min);
		}	
	
	}

	return 0;
}
