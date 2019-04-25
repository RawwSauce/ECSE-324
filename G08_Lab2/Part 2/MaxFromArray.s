			.text
			.global _start
_start:
//Caller:
			LDR R4, =RESULT // put address of result in R4
			LDR R2, [R4, #4] // put array length in R2
			ADD R3, R4, #8 // put the address of the begining of the array in R3
			LDR R0, [R3] // put first element of the array in R0

			BL MAX
			STR R0, [R4]

END:		B END // infinite loop to stop the program


MAX: 		PUSH {R5-LR}

LOOP:		SUBS R2, R2, #1 // decrement the counter
			BEQ DONE // if R2 is 0, ie we went throught the hole array
			ADD R3, R3, #4 // move pointer to the next element of the array
			LDR R1, [R3] // put the element that R3 now points at in R1
			CMP R0, R1 // compare R0 and R1
			BGE LOOP // if R0 is bigger than R1 then R0 is still our global max and we loop again to compare with another element
			MOV R0, R1 // R1 is bigger than R0 so R1 is now our new global max
			B LOOP // go back to the loop to compare the other elements

DONE:		POP {R5-LR} // store the global max in permanent memory
			BX LR // Go back to the main function 
RESULT:		.word	0
N:			.word 	7
NUMBERS:	.word	4, 5, 3, 6
			.word	1, 8, 2
