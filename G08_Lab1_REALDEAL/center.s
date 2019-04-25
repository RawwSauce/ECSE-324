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
			
LOOPSUM:	SUBS R1, R1, #1 // decrement the number of entries in the signal
			BEQ DONESUM // if R1 = 0, we went over all the elements, go to donesum
			ADD R2, R2, #4 // increment the address by 4 so that R2 is now the address of the next element in the list
			LDR R4, [R2] // put the value at address in R2 in R4
			ADD R3, R3, R4 // add R2 (number that we are at in the list) to the current sum, which is stored in R3
			B LOOPSUM // go back to loopsum to iterate over another element of the list
 
DONESUM: // sum is done and is now in R3		
// divide the sum by the number of entries in the list, store the average in a register
			STR R3, [R0, #-4]
			LDR R1, [R0] // load the number of entries in R1 again
			// now R3 will be where the average will be
LOOPDIV: // loop that divides the sum by two at each iteration
			ASR R3, R3, #1 // divide the sum by two  
			ASR R1, R1, #1 // divide by two numbers of entry
			CMP R1, #1 // compare R1 with 1
			BLE DONEDIV // if R1 is less or equal to one then we divided enough time and we go to donediv
			B LOOPDIV // go back to LOOPDIV so that we can divide once more
			
DONEDIV: // we divided the sum by the number of entries and so average is in R3
// substract the average from each entries in the list and overwrite it in permanent memory
			STR R3, [R0, #-8]
			LDR R1, [R0] // load the number of entries in R1 again
			ADD R2, R0, #4 // put the address of where the signal begins in memory in R2
			LDR R4, [R0, #4] // load the first entrie of the list in R4
			SUBS R4, R4, R3 // substract the average from the first value in the signal
			STR R4, [R2] // load the now centered value back in permanent memory
			
LOOPSUB:	SUBS R1, R1, #1 // decrement the number of entries in the signal
			BEQ DONESUB // if R1 = 0, we went over all the elements, go to donesum
			ADD R2, R2, #4 // increment the address by 4 so that R2 is now the address of the next element in the list
			LDR R4, [R2] // put the value at address in R2 in R4			
			SUBS R4, R4, R3 // substract the average from the first value in the signal
			STR R4, [R2] // load the now centered value back in permanent memory			
			B LOOPSUB // do the same operation on the next number so go back to LOOPSUB
DONESUB:

END:		B END					//infinite loop!

N:			.word 8					//number of entries in the list
SIGNAL:		.word 7, 8, 12, 44, 123, 1000, 55, 91		//list of numbers for our signal 
			
