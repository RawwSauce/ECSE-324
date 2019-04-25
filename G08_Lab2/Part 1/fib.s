			.text
			.global _start

_start: 	MOV R0, #10 // put the n fib number in R0
			BL FIB // call the function

END:		B END // stop the program and answer is in R0

FIB:
			PUSH {R1}
			PUSH {R2}
			PUSH {LR} // push the registers we are going to use onto the stack so that we dont loose their value
			MOV R1, R0 //R1 takes the value of R0 (N) so that we dont lose it when modyfing R0
			CMP R0, #1 // Checks to see if N is less than 1, if it is we have base case
			//MOV R0, #1 
			BLE FIB_D //Exits the fib function since we have base case
			SUB R0, R1, #2 // compute N-2 for the calculation of F(N-2)
			BL FIB //branches back to Fib function to calculate F(N-2)
			MOV R2, R0 //store the value that F(N-2) just returned
			SUB R0, R1, #1 // compute N-1 for the calculation of F(N-1)
			BL FIB //branches back to Fib function to calculate F(N-1)
			ADD R0, R0, R2 // Add F(N-2) and F(N-1) and put result in R0

FIB_D:
			MOV R0, #1 // Put 1 in R0 since we are at the base case (either F(1) or F(0)) and we need to return 1
			POP {R1}
			POP {R2} 
			POP {LR} // Once the program/iteration has finished we pop all the registers off the stack 
			BX LR //Branch and link function used to go to the address saved in the Link Register