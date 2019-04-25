	.text
	// define 4 address registers used with pushbuttons, only first 4 bits of each are used
	.equ PB_DATA_BASE, 0xFF200050
	.equ PB_INTER_BASE, 0xFF200058
	.equ PB_EDGE_BASE, 0xFF20005C
	// define subroutines
	.global read_PB_data_ASM
	.global PB_data_is_pressed_ASM
	.global read_PB_edgecap_ASM
	.global PB_edgecap_is_pressed_ASM
	.global PB_clear_edgecp_ASM
	.global enable_PB_INT_ASM
	.global disable_PB_INT_ASM
	
read_PB_data_ASM:
	PUSH {R1}
	LDR R1, =PB_DATA_BASE
	LDR R0, [R1] // load pushbuttons data in R0
	BFC R0, #4, #28 // clear all the bits excep first 4 bits as a precaution
	POP {R1}
	BX LR

PB_data_is_pressed_ASM:
	PUSH {R1}
	LDR R1, =PB_DATA_BASE
	LDR R1, [R1] // load pushbuttons data in R1
	CMP R1, R0 // compare data register with argument
	MOV R0, #0
	MOVEQ R0, #1 // if equal means the buttons the user entered as an argument are pressed
	POP {R1}
	BX LR

read_PB_edgecap_ASM:

	PUSH {R1}
	LDR R1, =PB_EDGE_BASE
	LDR R0, [R1] // load pushbuttons edgecapture data in R0
	AND R0, R0, #0xF // clear all the bits excep first 4 bits as a precaution
	POP {R1}
	BX LR

PB_edgecap_is_pressed_ASM:
	PUSH {R1}
	LDR R1, =PB_EDGE_BASE
	LDR R1, [R1] // load pushbuttons edgecapture data in R0
	CMP R1, R0 // compare data register with argument
	MOV R0, #0
	MOVEQ R0, #1 // if equal means the buttons the user entered as an argument have been pressed (their state changed from 0 to 1)
	POP {R1}
	BX LR
	
PB_clear_edgecp_ASM:

	PUSH {R1}
	LDR R1, =PB_EDGE_BASE
	STR R0, [R1] // store R0 in edgecapture register to reset them
	POP {R1}
	BX LR

enable_PB_INT_ASM: // this uses a one hot encoded scheme to know which buttons to enable interrupts for

	PUSH {R1}
	LDR R1, =PB_INTER_BASE
	AND R0, R0, #0xF // keep only last for bits of R0
	STR R0, [R1] // store desired interrupts bits sequence in the interrupt data register
	POP {R1}
	BX LR

disable_PB_INT_ASM: // this uses a one hot encoded scheme to know which buttons to disable interrupts for
	PUSH {R1}
	LDR R1, =PB_INTER_BASE
	MVN R0, R0 // invert R0
	BFC R0, #4, #28 // clear all the bits excep first 4 bits
	STR R0, [R1] // store desired interrupts bits sequence in the interrupt data register
	POP {R1}
	BX LR
