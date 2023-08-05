		area	prog1,	code,	readonly
		entry
		
;410440241 LAI PENG JUN
		LDR	r5, =0xD36

		;Extract 8bit of data

		MOV	r1, r5
		ROR	r1, r1, #2 
		AND	r0, r1, #1 
					
		ROR	r1, r1, #1
		AND	r3, r1, #0xE
		ORR	r0, r3, r0
					
		ROR	r1, r1, #1
		AND	r3, r1, #0xF0
		ORR	r0, r3, r0
		;------------------------------------------------------------------------------
		;compute checksum
								   ;
								   ; calculate c0 using bits 76543210
								   ;                          * ** **
								   ; even parity, so result of XORs is the value of c0
								   ;
		MOV r4, r0                 ; make a copy
		EOR r4, r4, r0, ROR #1     ; 1 XOR 0
		EOR r4, r4, r0, ROR #3     ; 3 XOR 1 XOR 0
		EOR r4, r4, r0, ROR #4     ; 4 XOR 3 XOR 1 XOR 0
		EOR r4, r4, r0, ROR #6     ; 6 XOR 4 XOR 3 XOR 1 XOR 0
		AND r2, r4, #1             ; create c0 -> R2
				
;410440241 LAI PENG JUN				   ;
								   ; calculate c1 using bits 76543210
								   ;                          ** ** *
		MOV r4, r0
		EOR r4, r4, r0, ROR #2     ; 2 XOR 0
		EOR r4, r4, r0, ROR #3     ; 3 XOR 2 XOR 0
		EOR r4, r4, r0, ROR #5     ; 5 XOR 3 XOR 2 XOR 0
		EOR r4, r4, r0, ROR #6     ; 6 XOR 5 XOR 3 XOR 2 XOR 0
		AND r4, r4, #1             ; isolate bit
		ORR r2, r2, r4, LSL #1     ; 7 6 5 4 3 2 c1 c0
								   ;
								   ; calculate c2 using bits 76543210
								   ;                         *   ***
		ROR r4, r0, #1             ; get bit 1
		EOR r4, r4, r0, ROR #2     ; 2 XOR 1
		EOR r4, r4, r0, ROR #3     ; 3 XOR 2 XOR 1
		EOR r4, r4, r0, ROR #7     ; 7 XOR 3 XOR 2 XOR 1
		AND r4, r4, #1             ; isolate bit
		ORR r2, r2, r4, ROR #29    ; 7 6 5 4 c2 2 c1 c0
								   ;
								   ; calculate c3 using bits 76543210
								   ;                         ****
		ROR r4, r0, #4             ; get bit 4
		EOR r4, r4, r0, ROR #5     ; 5 XOR 4
		EOR r4, r4, r0, ROR #6     ; 6 XOR 5 XOR 4
		EOR r4, r4, r0, ROR #7     ; 7 XOR 6 XOR 5 XOR 4
		AND r4, r4, #1             ; isolate bit
		ORR r2, r2, r4, ROR #25    ; c3 6 5 4 c2 2 c1 c0

		EOR	r2,  r2, r5

		MOV	r8,  #0		     ;counter
		MOV	r9,  #1		     ;r11=j
					
		TST	r2,  #1
		ADDNE   r11, r9, LSL #0
		ADDNE   r8,  r8, #1
					
		TST	r2,  #2
		ADDNE   r11, r9, LSL #1
		ADDNE   r8,  r8, #1
					
		TST	r2,  #8
		ADDNE   r11, r9, LSL #2
		ADDNE   r8,  r8, #1
					
		TST	r2,  #0x80
		ADDNE   r11, r9, LSL #3
		ADDNE   r8,  r8, #1
					
		SUB     r11, r11, #1        ;j
;410440241 LAI PENG JUN
		CMP	r8, #0
		MOVEQ   r6, r0		     ;correct data
					
		CMP	r8, #1
		MOVEQ   r6, r0		     ;correct da

		CMP	r8,  #2		     ;two error checksum 
		MOV	r10, #1 	     ;modify data
		LSLEQ	r10, r10, r11
		EOREQ	r5,  r5, r10 	     ;inverse bit of j

									;Extract correct 8bit of data to r6
		MOVEQ	r1, r5
		ROREQ	r1, r1, #2 
		ANDEQ	r6, r1, #1 
					
		ROREQ	r1, r1, #1
		ANDEQ	r3, r1, #14
		ORREQ	r6, r3, r6
				
;410440241 LAI PENG JUN	
		ROREQ	r1, r1, #1
		ANDEQ	r3, r1, #0xF0
		ORREQ	r6, r3, r6
stop	b	stop
		end
				