Stack      EQU 0x00000100
DivbyZ     EQU 0xD14
SYSHNDCTRL EQU 0xD24
Usagefault EQU 0xD2A
NVICBase   EQU 0xE000E000
;410440241 lai peng jun
           AREA STACK, NOINIT, READWRITE, ALIGN = 3
StackMem                   ;???????0x20000000
           SPACE Stack     ;???0x100???,????????0x20000100
           PRESERVE8

;410440241 lai peng jun
           AREA RESET, CODE, READONLY
           THUMB

           DCD StackMem + Stack  ; Top of Stack ;0 x 4
           DCD Reset_Handler     ; Reset Handler ;1 x 4
           DCD NmiISR            ; NMI Handler ;2 x 4
           DCD FaultISR          ; Hard Fault Handler ;3 x 4
           DCD IntDefaultHandler ; MPU Fault Handler ;4 x 4
           DCD IntDefaultHandler ; Bus Fault Handler ;5 x 4
           DCD IntDefaultHandler ; Usage Fault Handler ;6 x 4
        
           EXPORT Reset_Handler
           ENTRY
        
		;410440241 lai peng jun
Reset_Handler
        
		   MRS r0, CONTROL
		   ORR r8, r8, #1
		   MSR CONTROL, r8
		   
           ; Enable the divide-by-zero trap
           LDR r6, =NVICBase
           LDR r7, =DivbyZ
           LDR r1, [r6, r7]
           ORR r1, #0x10 ; enable bit 4
	       STR r1, [r6, r7]
        
           ; Turn on the usage fault exception
           ;LDR r7, =SYSHNDCTRL
           ;LDR r1, [r6, r7]
           ;ORR r1, #0x40000
           ;STR r1, [r6, r7]
        
		;410440241 lai peng jun
           MOV r0, #0
           MOV r1, #0x11111111
           MOV r2, #0x22222222
           MOV r3, #0x33333333
        
           ;????0,?????????
           UDIV r4, r2, r1
           ;????0???,???????????????
           UDIV r5, r3, r0
        
Exit       B     Exit
NmiISR     B NmiISR
FaultISR	LDR r10, =0x77777777
			BX LR
			
IntDefaultHandler
        
           ;??0xE000ED2A?bit 9?1,?????divide-by-zero,?0xDEADDEAD??r9
           LDR r7, =Usagefault
           LDRH r1, [r6, r7]
           TST r1, #0x200
           LDRNE r9, =0xDEADDEAD
		   
         
		 ;410440241 lai peng jun
  	;set to user thread mode to let system to become unpriviledged
		   MRS r8, CONTROL
		   ORR r8, r8, #1
		   MSR CONTROL, R8
	;give value of lr(0xfffffff9, the nine->0x1001, the first bit is zero, which means it is a main stack pointer) is to point to the main stack
           BX    LR   
           
done       B done
           ALIGN
           END



