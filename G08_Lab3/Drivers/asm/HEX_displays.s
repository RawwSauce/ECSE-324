	.text
	.equ HEX_BASE_3_TO_0, 0xFF200020
	.equ HEX_BASE_5_TO_4, 0xFF200030
	.global HEX_clear_ASM
	.global HEX_flood_ASM
	.global HEX_write_ASM
	
HEX_clear_ASM:// put zeros on the displays that were passed in R0 as arguments
	MOV R1, #0
	B Main_Sub
HEX_flood_ASM: // put all ones on the displays that were passed in R0 as arguments
	MOV R1, #-1 // negative one is all ones in 2s complement
	B Main_Sub
HEX_write_ASM: // put what is in R1 the displays that were passed in R0 as arguments
	PUSH {R0, LR}
	MOV R0, R1
	BL Convert // call convert subroutine to convert val to display into correct binary value
	MOV R1, R0
	POP {R0, LR}
	B Main_Sub

Main_Sub:
	PUSH {LR}
	PUSH {R2,R3,R4}
	MOV R2, #1 // initialize comparator, this will be used to know which register will be modified and as a counter
	MOV R4, #0 //counter
LOOP:
	AND R3, R2, R0 // compare R0 (argument) and R2 (comparator), put result in R3
	PUSH {R0, LR}
	MOV R0, R3 // Put nth enabled hex display in R0 so that it can be passed as an argument to UPDATE_HEX
	CMP R3,R2 // compare to see if nth enabled bit is enabled
	BLEQ UPDATE_HEX // if equal means nth was enabled and that hex display needs to be modified, branch to that subroutine
	POP {R0, LR}
	LSL R2,#1 // update comparator, i.e. double its value
	CMP R2, #16 // compare R2 to know if we have iterated more than 6 times
	ADD R4, R4, #1	// invrement counter
	CMP R4, #6 // check if we have iterated 5 times
	BLT LOOP
	// loop is over we are done updating the HEX displays register and we can store the result in memory
	POP {R2,R3,R4}
	POP {LR}
	BX LR

UPDATE_HEX:// update an HEX display
		   // display to be updated is one hot encoded in R0
		   // value to update to is in R1
	PUSH {R2, R3}
	CMP R0, #8 // compare R0 with to know if we are working with register 0 to 3 or 4 to 5 
	LDRLE R2, =0xFF200020 // load address of HEX displays 0 to 3
	LDRGT R2, =0xFF200030 // load address of HEX displays 4 to 5
	LDR R3, [R2] // load current value of HEX display in R3
	// update a register according to the value one hot encoded in R0
	CMP R0, #1
	BEQ HEX0
	CMP R0, #2
	BEQ HEX1
	CMP R0, #4
	BEQ HEX2
	CMP R0, #8
	BEQ HEX3
	CMP R0, #16
	BEQ HEX4
	CMP R0, #32
	BEQ HEX5

DONE:
	STR R3, [R2] // store modified display value back in memory
	POP {R2, R3}
	BX LR

HEX0:
	BFI R3, R1, #0, #8
	// take the first 8 bits in R1 and put them aside
	// overwrite 8 consecutives bits in R3 starting at index 0 by what we just put aside
	B DONE
HEX1:
	BFI R3, R1, #8, #8
	B DONE
HEX2:
	BFI R3, R1, #16, #8
	B DONE
HEX3:
	BFI R3, R1, #24, #8
	B DONE
HEX4:
	BFI R3, R1, #0, #8
	B DONE
HEX5:
	BFI R3, R1, #8, #8
	B DONE
	

Convert:
	CMP R0, #0
	BEQ seg0
	CMP R0, #1
	BEQ seg1
	CMP R0, #2
	BEQ seg2
	CMP R0, #3
	BEQ seg3
	CMP R0, #4
	BEQ seg4
	CMP R0, #5
	BEQ seg5
	CMP R0, #6
	BEQ seg6
	CMP R0, #7
	BEQ seg7
	CMP R0, #8
	BEQ seg8
	CMP R0, #9
	BEQ seg9
	CMP R0, #10
	BEQ seg10
	CMP R0, #11
	BEQ seg11
	CMP R0, #12
	BEQ seg12
	CMP R0, #13
	BEQ seg13
	CMP R0, #14
	BEQ seg14
	CMP R0, #15
	BEQ seg15

seg0: 
	MOV R0, #63
	BX LR

seg1: 
	MOV R0, #6
	BX LR

seg2: 
	MOV R0, #91
	BX LR

seg3: 
	MOV R0, #79
	BX LR

seg4: 
	MOV R0, #102
	BX LR

seg5: 
	MOV R0, #109
	BX LR

seg6: 
	MOV R0, #125
	BX LR

seg7: 
	MOV R0, #7
	BX LR

seg8: 
	MOV R0, #127
	BX LR

seg9: 
	MOV R0, #103
	BX LR

seg10: //A
	MOV R0, #247
	BX LR

seg11: //B
	MOV R0, #255
	BX LR

seg12: //C
	MOV R0, #185
	BX LR

seg13: //D
	MOV R0, #191
	BX LR

seg14: //E
	MOV R0, #249
	BX LR

seg15: //F
	MOV R0, #241
	BX LR

	.end


