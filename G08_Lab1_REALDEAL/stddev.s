			.text
			.global _start
_start:
			LDR R4, =RESULT  //Store memory address of result in R4
			LDR R2, [R4, #4] //[R4,#4] gives us the value that is stored in memory at the address stored in R4 but shifted by 4bytes(address of N), in this
						     // in our case this corresponds to the value of N, which is the number of elements in the list
			ADD R3, R4, #8   // R3 will hold the address of that was stored inside R4 but shifted by 8 bytes, or 2 words, this corresponds the start the address 
						     // where the number list starts
			LDR R0, [R3]     // load the value that is at the adress inside R3 (so the first number of the list) insisde R0
//find max
LOOPMAX:	SUBS R2, R2, #1// decrease R2 by one
			BEQ DONEMAX    // if R2 = 0 then go to DONEMAX
			ADD R3, R3, #4 // increment R3 by 4, which results in the memory address stored in R3 to be shifted by 4bytes, or in other words by a word/memory slot
						   // R3 is a pointer to every element of the array
			LDR R1, [R3]   // we load in R1 the value that R3 now points at
			CMP R0, R1     // compare R1 to R1 
			BGE LOOPMAX    // if R0 is bigger than R1 then go back to loopmax to iterate over the other elements
			MOV R0, R1     // if R1 is bigger than R0 then put R1 in R0
					       // R0 is a the current max value
			B LOOPMAX      // go back to loopmax to continue iterating over the elements of the array

DONEMAX:
//find min
			LDR R2, [R4, #4] // reset R2 to the number of elements in the array
			ADD R3, R4, #8 // reset R3 to the starting adress of the array of numbers
			LDR R5, [R3] // R5 is the first element of the array

LOOPMIN:	SUBS R2, R2, #1 // decrement
			BEQ DONEMIN // if = 0 then exit loop
			ADD R3, R3, #4 // increment r3 to go to next element in the array
			LDR R1, [R3] // load value at address [R3] in R1
			CMP R5, R1 // compare with current min, ie R5 is the current min
			BLE LOOPMIN // R5 is smaller then R1 then go back to loopmin to iterate over elements 
			MOV R5, R1 // R1 is smaller than R5 so R1 becomes the new global min (R5)
			B LOOPMIN // go back to the loopmin to iterate over the rest of the numbers

DONEMIN:	
			SUBS R6, R0, R5 // substract max(R0) to min (R5) and put result in R6
			LSR R7, R6, #2 // divide R6 by 4, put result in R7
			STR R7, [R4] // store R7 (the standard deviation) in the address stored inside R4, ie store it in result
END:		B END

// memory used in for the program
RESULT:		.word	0
N:			.word 	7
NUMBERS:	.word	4, -5, 3, 19
			.word	1, 8, 2
			