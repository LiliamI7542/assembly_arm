		area	uartdemo,	code,	readonly
		entry
		ldr r1, =0xabcdef12
		ldr sp, =0x40000000
		ldr r0, =0x40000100
		bl func
stop	b stop

func	
		stmia sp! ,{r5, r6, lr}
		ldr r7, =0
		mov r5, r1
loop	
		bic r6, r5, #0xffffff00
		ror r5, #8
		strb r6, [r0, r7]
		add r7, #1
		cmp r7, #4
		blt loop
		ldmdb sp! ,{r5, r6, pc}
		end