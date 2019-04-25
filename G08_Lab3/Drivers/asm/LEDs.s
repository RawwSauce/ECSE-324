	.text
	.equ LEDs_BASE, 0xFF200000 // memory address reserved fo i/o with leds
	.global read_LEDs_ASM
	.global write_LEDs_ASM

read_LEDs_ASM:
	PUSH {R1} // push R1 since we are modifying it
	LDR R1, = LEDs_BASE // load mem address of leds in R1
	LDR R0, [R1] // load value of leds i/o in R0
	POP {R1} // restore R1 since we are done
	BX LR // branch out of subroutine
write_LEDs_ASM:
	PUSH {R1} // push R1 since we are modifying it
	LDR R1, = LEDs_BASE // load mem address of leds in R1
	STR R0, [R1] // write what is in R0 in the mem address for LEDs
	POP {R1} // restore R1 since we are done
	BX LR // branch out of subroutine
	
	.end
