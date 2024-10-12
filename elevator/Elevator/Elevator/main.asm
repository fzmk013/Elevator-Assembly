

		.INCLUDE "M32DEF.INC"
		.ORG 0
		RJMP main
		.ORG $002
		RJMP rout_0
		.ORG $004
		RJMP rout_1
		.ORG $100
main:	CBI DDRD,0 ; in
        CBI DDRD,1 ; out
        CBI DDRD,2 ; req
		CBI DDRD,3 ; alarm
    	CLR R16
		SER R17
		OUT SFIOR, R16   ; PUD= enable
		OUT PORTD, R17
g1:     IN R16,PIND
        MOV R17,R16
		ANDI R16,$01
        CPI R16,$01
		BREQ  g2
		ANDI R17,$02
		CPI R17,$02
		BREQ g2
		RJMP g1
g2:		LDI R16,$C0
		LDI R17,$02
		OUT GICR, R16   ; INT0 : ENABLE
		OUT MCUCR,R17    ; falling edge
		LDI R21,0
		LDI R22,$05
		OUT SPH, R22
		OUT SPL, R21  ; SP= 0500 h
		SEI             ; interrupt enable
wait:   RJMP wait

rout_0: SBI PORTA,0 ;open on
        RCALL twenty
		CBI PORTA,0 ;open off
		RCALL twenty
		RCALL twenty
		RCALL twenty
		SBI PORTA,1 ;close on
        RCALL twenty
		CBI PORTA,1 ;close off
	    RETI

rout_1: SBI PORTA,0 ;open on
        RCALL thirty
		CBI PORTA,0 ;open off

twenty: LDI R18,$B0
L1:     INC R18
        LDI R17,$0F
L2:     INC R17
        CLR R16
L3:     INC R16
        CPI R16,$FF
		BRNE L3
		CPI R17,$FF
		BRNE L2
		CPI R18,$FF
		BRNE L1
        RET

thirty: LDI R18,$8D
L4:     INC R18
        CLR R17
L5:     INC R17
        CLR R16
L6:     INC R16
        CPI R16,$FF
		BRNE L6
		CPI R17,$FF
		BRNE L5
		CPI R18,$FF
		BRNE L4
        RET
