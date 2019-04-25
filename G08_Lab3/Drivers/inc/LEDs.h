#ifndef __LEDS_READ //if the macro LEDS READ is not define then continue
#define __LEDS_READ //define __LEDS_READ

	extern int read_LEDs_ASM();

#endif // end above if statement

#ifndef __LEDS_WRITE //if the macro LEDS WRITE is not define then continue
#define __LEDS_WRITE //define LEDS WRITE

	extern int write_LEDs_ASM(int x);

#endif // end above if statement