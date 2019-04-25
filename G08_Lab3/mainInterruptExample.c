#include <stdio.h>

#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/pushbuttons.h"

int main(){
		
		// setup interruptions
		int_setup(2, (int []){199, 73});
		
		int count = 0;
		HPS_TIM_config_t hps_tim;
		// enable interrupt on push buttons
		enable_PB_INT_ASM(PB0 | PB1 | PB2);

		hps_tim.tim = TIM0;
		hps_tim.timeout = 1000000;
		hps_tim.LD_en = 1;
		hps_tim.INT_en = 1; // enable interupts on the timer
		hps_tim.enable = 1;

		HPS_TIM_config_ASM(&hps_tim);

		while(1){
			// when timer creates an interrup the isr code is executed and the hps_tim0_int_flag is set
			if(hps_tim0_int_flag){
				hps_tim0_int_flag = 0;
				if(++count == 16){
					count = 0;
				}
				HEX_write_ASM(HEX0,count);
			}

			if(hps_pb_int_flag){
				HEX_write_ASM(HEX3,hps_pb_int_flag);
				hps_pb_int_flag = 0;
			}
		}
		return 0;
}
