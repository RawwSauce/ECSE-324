			.text
			.global _start

_start: 
		MOV R0, #4 //Put 4 into R0
		MOV R1, #17 //Put 17 into R1
		STMDB SP!, {R0, R1}//Store Multiple Decrement Before 
		
		LDMIA SP!, {R0, R1, R2} //Popping 3 times and putting the results in the registers
		
END:		B END

