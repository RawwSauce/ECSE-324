			.text
			.global _start

_start: 

// R0 address of N
// R1 number of entries, ie how many numbers our signal contains
// R2 address of where the signal begins in permanent memory
// R3 sum of all the numbers of our signal
// R4 value of one of the numbers in the signal
// R5 hold the result of sum/(num_of_entries), ie the average
// compute the sum of all numbers in the signal, and store result in a register
			LDR R0, =N // load the address of where all the data for the program will be
			LDR R1, [R0] // load the number of entries in R1
			ADD R2, R0, #4 // put the address of where the signal begins in memory in R2
			LDR R3, [R2] // load the first entrie/number of the list in R2
			MOV R10, #0 // our flag 
			
LOOPCMP:	SUBS R1, R1, #1 // decrement the number of entries in the array
			BEQ DONELOOP  //went over whole array now send to check 
			ADD R2, R2, #4	// increment the address by 4 so that R2 is now the address of the next element in the list
			LDR R6, [R2]
			CMP R3, R6 // comparing 2 adjacent elements
			BGE SWAP // if R3 is bigger than R2 + 4 then go back to loopmax to iterate over the other elements
			LDR R3, [R2] // overriding R3 because it is the register that stores the element in the array that you are comparing
			B LOOPCMP // go back into loop (not done going through array still comparing adjacent elements)

DONELOOP:	ADD R2, R0, #4
			LDR R3, [R2] // load the first entrie/number of the list in R2
			LDR R1, [R0] // load the number of entries in R1
			CMP R10, #1 
			BGE INTER // if flag is 1 we want to loop again 
			B END // go to the end because it is already sorted

SWAP:		STR R3, [R2] //Put contents of R3 in R2 address 
			STR R6, [R2, #-4] //Go back a spot to put the adjacent value 
			CMP R3, R6 //R3 is less or equal than R6 so don't need to put up flag (we already checked if it was bigger so 
						//when we check if it is less then we have basically checked that it is equal)
			BLE LOOPCMP //Numbers are equal dont need to increment flag 
			ADD R10, R10, #1 //Increment the flag because a different number swap was made
			B LOOPCMP

INTER:		MOV R10, #0 // reset the flag to zero
			B LOOPCMP

END:		B END

N:			.word 8					//nuber of entries in the list
ARRAY:		.word 1, 6, 2, 3		//list of numbers for our signal 
			.word 10, -6, 2, 3
