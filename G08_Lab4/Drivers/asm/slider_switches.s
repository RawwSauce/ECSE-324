	.text
	.equ SW_BASE, 0xFF200040 // memory address reserved fo i/o with slider switches
	.global read_slider_switches_ASM

read_slider_switches_ASM:
	PUSH {R1} // push R1 since we are modifying it
	LDR R1, = SW_BASE // load mem address of sliders in R1
	LDR R0, [R1] // load value of slider i/o in R0
	POP {R1} // restore R1 since we are done
	BX LR // branch out of subroutine
	
	.end
