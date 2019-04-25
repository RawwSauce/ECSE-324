	.text
	
	.global write_audio_data_ASM

	.equ FIFOSPACE, 0xFF203044
	.equ LEFTDATA, 0xFF203048
	.equ RIGHTDATA, 0xFF20304C
	
write_audio_data_ASM:

	PUSH {R1-R9, LR}
	LDR R1, =FIFOSPACE
	LDR R2, [R1] // load fifo space in R2 so that we can check WSRC and WSLC
	LSR R2, R2, #16 // get rid of the first 16bits and only keep the last 16
	AND R3, R2, #255 // keep the first 8bits, ie keep WSRC
	LSR R2, R2, #8 // get rid of first 8bits
	AND R4, R2, #255 // keep the last 8bits. ie keep WSLC
	// check if can wirte to left and right data, ie if WSLC and WSRC are bigger than 1, they indicate how much space is left 
	CMP R3, #1
	BLT TOEND
	CMP R4, #1
	BLT TOEND
	// we can write to audio so do so
 	LDR R7,=LEFTDATA		
   	LDR R8,=RIGHTDATA		
    STR R0,[R7]			
    STR R0,[R8]			
    MOV R0, #1 // return 1 since we outputed audio
	BX LR
	
TOEND:
	POP {R1-R9, LR}
	MOV R0, #0 // return 0 since we didnt write audio
	BX LR
	.end
