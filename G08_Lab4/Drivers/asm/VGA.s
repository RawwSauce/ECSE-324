	.text
	.equ VGA_BASE_PIXELBUFF, 0xC8000000
	.equ VGA_BASE_CHARBUFF, 0xC9000000
	.global VGA_clear_charbuff_ASM
	.global VGA_clear_pixelbuff_ASM
	.global VGA_write_char_ASM
	.global VGA_write_byte_ASM
	.global VGA_draw_point_ASM
	
	.equ H_PIXEL_MAX_MEM, 638
	.equ V_PIXEL_MAX_MEM, 244736
	.equ H_CHARACTER_RESOL, 79
	.equ V_CHARACTER_RESOL, 15104
	.equ H_PIXEL_MAX_RESOL, 319
	.equ V_PIXEL_MAX_RESOL, 239

VGA_clear_pixelbuff_ASM:
	
	PUSH {R0-R9, LR}
	MOV R3, #255
	ADD R3, R3, # 64
	MOV R4, #239
	LDR R0, =VGA_BASE_PIXELBUFF // base address
	MOV R1, #0 // x counter
	MOV R2, #0 // y counter
	MOV R6, #0 // R6 is going to be what we load in the buffer address during each iteration
	
LOOPX:
	
	STRH R6, [R0] // write R6 at that memory address	
	ADD R0, R0, #2 // base memory + x memory base offset
	ADD R1, R1, #1 // increment to next the horizontal pixel, ie increment x 
	CMP R1, R3
	BLE LOOPX

	
	ADD R2, R2, #1 // increment y
	ADD R0, R0, #1024 // add one row memory offset to base memory address
	MOV R1, #255  // compute mem offset to remove from R0 to start at the begining of the row
	ADD R1, R1, # 65 
	LSL R1, R1, #1
	SUB R0, R0, R1 // 
	MOV R1, #0 // reset x memory base offset
	CMP R2, R4
	BLE LOOPX
	
	POP {R0-R9, LR}
	BX LR
	
VGA_clear_charbuff_ASM:
	
	PUSH {R0-R9, LR}
	MOV R3, #79
	MOV R4, # 59
	LDR R0, =VGA_BASE_CHARBUFF // base address
	MOV R1, #0 // x counter
	MOV R2, #0 // y counter
	MOV R6, #0 // R6 is going to be what we load in the buffer address during each iteration
	
LOOPCHAR:
	
	STRB R6, [R0] // write R6 at that memory address	
	ADD R0, R0, #1 // base memory + x memory base offset
	ADD R1, R1, #1 // increment to next the horizontal pixel, ie increment x 
	CMP R1, R3
	BLE LOOPCHAR

	
	ADD R2, R2, #1 // increment y
	ADD R0, R0, #128 // add one row memory offset to base memory address
	MOV R1, #80  // mem offset to remove from R0 to start at the begining of the row
	SUB R0, R0, R1 
	MOV R1, #0 // reset x memory base offset
	CMP R2, R4
	BLE LOOPCHAR
	
	POP {R0-R9, LR}
	BX LR

VGA_write_char_ASM:
	PUSH {R0-R9, LR}
	
	//check x coordinate
	CMP R0, #0
	BLT DONEWRITECHAR
	CMP R0, #79
	BGT DONEWRITECHAR       

	//check y coordinate
	CMP R1, #0
	BLT DONEWRITECHAR
	CMP R1, #59
	BGT DONEWRITECHAR	

	LDR R3, =VGA_BASE_CHARBUFF
	MOV R4, #128
	MUL R1, R1, R4
	ADD R3, R1, R3
	ADD R3, R3, R0
	STRB R2, [R3]
DONEWRITECHAR:
	POP {R0-R9, LR}
	BX LR

VGA_write_byte_ASM:
	PUSH {R0-R9, LR}
	LDR R7, =CHAR_HEX
	//check x coordinate
	CMP R0, #0
	BLT DONEWRITECHAR
	CMP R0, #78
	BGT DONEWRITECHAR

	//check y coordinate
	CMP R1, #0
	BLT DONEWRITECHAR
	CMP R1, #59
	BGT DONEWRITECHAR	
	MOV R6, R2 //save value of R2 (what we want to display)
	LSR R2, R6, #4 //shift right 4 bits
	AND R2, R2, #15 		// only want the last 4 bits
	LDRB R2, [R7, R2] //R7 points to first elem in array and we want to offset by the value that is in R2 to get to other elem in the array
	BL VGA_write_char_ASM // display the first character on the screen
	ADD R0, R0, #1
	MOV R2, R6
	AND R2, R2, #15 //only want the last 4 bits
	LDRB R2, [R7, R2] //R7 points to first elem in array and we want to offset by the value that is in R2 to get to other elem in the array
	BL VGA_write_char_ASM //display the second character on the screen
	
	POP {R0-R9, LR}
	BX LR

CHAR_HEX:
	.byte 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46
	//      0     1     2     3     4     5     6     7     8     9     A     B     C     D     E     F  //


VGA_draw_point_ASM:
	PUSH {R0-R9, LR}
	
	//check x coordinate
	CMP R0, #0
	BLT DONEWRITECHAR
	MOV R8, #0
	ADD R8, R8, #255
	ADD R8, R8, #64
	CMP R0, R8
	BGT DONEWRITECHAR

	//check y coordinate
	CMP R1, #0
	BLT DONEWRITECHAR
	MOV R8, #0
	ADD R8, R8, #239
	CMP R1, R8
	BGT DONEWRITECHAR	

	LDR R3, =VGA_BASE_PIXELBUFF
	LSL R1, R1, #10
	LSL R0, R0, #2
	ADD R3, R3, R1 // add x mem offset to base address
	ADD R3, R3, R0 // add y mem offset to base address
	STRH R2, [R3]

	POP {R0-R9, LR}
	BX LR

	.end


