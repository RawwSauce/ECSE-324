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
	PUSH {R2}
	B Convert // call convert subroutine to convert val to display into correct binary value
	MOV R1, R2
DONECONV:	
	POP {R2}
	B Main_Sub

Main_Sub:
	PUSH {R2,R3,R4}
	MOV R2, #1 // initialize comparator, this will be used to know which register will be modified and as a counter
	MOV R4, #0 //counter
LOOP:
	AND R3, R2, R0 // compare R0 (argument) and R2 (comparator), put result in R3
	CMP R3,R2 // compare to see if nth enabled bit is enabled
	BEQ UPDATE_HEX // if equal means nth was enabled and that hex display needs to be modified, branch to that subroutine
DONEHEX:	
	LSL R2,#1 // update comparator, i.e. double its value
	CMP R2, #16 // compare R2 to know if we have iterated more than 6 times
	ADD R4, R4, #1	// increment counter
	CMP R4, #6 // check if we have iterated 5 times
	BLT LOOP
	// loop is over we are done updating the HEX displays register and we can store the result in memory
	POP {R2,R3,R4}
	BX LR

UPDATE_HEX:// update an HEX display
		   // display to be updated is one hot encoded in R0
		   // value to update to is in R1
	PUSH {R2, R4}
	CMP R3, #8 // compare R0 with to know if we are working with register 0 to 3 or 4 to 5 
	LDRLE R2, =0xFF200020 // load address of HEX displays 0 to 3
	LDRGT R2, =0xFF200030 // load address of HEX displays 4 to 5
	LDR R4, [R2] // load current value of HEX display in R4
	// update a register according to the value one hot encoded in R0
	CMP R3, #1
	BEQ HEX0
	CMP R3, #2
	BEQ HEX1
	CMP R3, #4
	BEQ HEX2
	CMP R3, #8
	BEQ HEX3
	CMP R3, #16
	BEQ HEX4
	CMP R3, #32
	BEQ HEX5

DONE:
	STR R4, [R2] // store modified display value back in memory
	POP {R2, R4}
	B DONEHEX

HEX0:
	BFI R4, R1, #0, #8
	// take the first 8 bits in R1 and put them aside
	// overwrite 8 consecutives bits in R3 starting at index 0 by what we just put aside
	B DONE
HEX1:
	BFI R4, R1, #8, #8
	B DONE
HEX2:
	BFI R4, R1, #16, #8
	B DONE
HEX3:
	BFI R4, R1, #24, #8
	B DONE
HEX4:
	BFI R4, R1, #0, #8
	B DONE
HEX5:
	BFI R4, R1, #8, #8
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
	MOV R2, #63
	B DONECONV

seg1: 
	MOV R2, #6
	B DONECONV

seg2: 
	MOV R2, #91
	B DONECONV

seg3: 
	MOV R2, #79
	B DONECONV

seg4: 
	MOV R2, #102
	B DONECONV

seg5: 
	MOV R2, #101
	B DONECONV

seg6: 
	MOV R2, #125
	B DONECONV

seg7: 
	MOV R2, #7
	B DONECONV

seg8: 
	MOV R2, #127
	B DONECONV

seg9: 
	MOV R2, #103
	B DONECONV

seg10: //A
	MOV R2, #247
	B DONECONV

seg11: //B
	MOV R2, #255
	B DONECONV

seg12: //C
	MOV R2, #189
	B DONECONV

seg13: //D
	MOV R2, #191
	B DONECONV

seg14: //E
	MOV R2, #249
	B DONECONV

seg15: //F
	MOV R2, #241
	B DONECONV

	.end


