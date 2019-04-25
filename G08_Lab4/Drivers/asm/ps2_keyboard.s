	.text
	.equ PS2_BASE_DATA, 0xFF200100
	.global read_PS2_data_ASM
		
read_PS2_data_ASM:
	
	PUSH {R1, R2, R3, LR}
	
	LDR R1, =PS2_BASE_DATA
	LDR R2, [R1] // load keyboard data register in R2
	
	AND R3, R2, #0x8000 // check if we can read data from the keyboard, ie check if Rvalid is one
	CMP R3,  #0x8000
	BEQ STOREDATA
	MOV R0, #0 // nothing has been read so return 0
	POP {R1, R2, R3, LR}
	BX LR
	
STOREDATA:
	AND R2,R2, #255 // end with 255 to get last 8bits
	STRB R2, [R0] // store read keyboard data
	MOV R0, #1 // we read from the keyboard so return 1
	POP {R1, R2, R3, LR}
	BX LR
	
	.end
	
