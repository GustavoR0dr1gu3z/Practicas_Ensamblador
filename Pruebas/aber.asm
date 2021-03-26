;**********************************************************************
;                                                                     *
;    Filename:	    xxx.asm                                           *
;    Date:                                                            *
;    File Version:                                                    *
;                                                                     *
;    Author:                                                          *
;    Company:                                                         *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files Required: P16F887.INC                                      *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;**********************************************************************


	list		p=16f887	; list directive to define processor
	#include	<p16f887.inc>	; processor specific variable definitions


; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.

	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V



;***** VARIABLE DEFINITIONS
	

;**********************************************************************
	ORG     0x000             ; processor reset vector
	
	CBLOCK	0X20
		CounterA, CounterB, CounterC
	ENDC

	NOP
  	GOTO    CONFIGURA_PTOS              ; go to beginning of program


CONFIGURA_PTOS
	BSF 	STATUS, RP0		;Cambiar al Bank_1
	
	MOVLW	0XFF			
	MOVWF	TRISA

	MOVLW	0X00			;Cargar en el acumulador el dato 0X00
	MOVWF	TRISB			;Mover lo que esta en el acumulador al TRISB, se define el puerto B como salida

	BSF 	STATUS, RP1		;Cambiar al Bank_3

	CLRF	ANSEL

	CLRF	ANSELH			;Limpiar el ANSELH, se define el puerto B como digital

	BCF 	STATUS, RP0		;Cambiar al Bank_0
	BCF 	STATUS, RP1		

	CLRF 	PORTA
	CLRF	PORTB			;Limpiar el puerto B
	MOVLW 	B'00000001'
	MOVWF	PORTB	
	CALL 	RETARDO_.400ms
	BCF		STATUS,C

INICIO
	BTFSS 	PORTA,0		
	GOTO 	SI_0		;(_,0)
	GOTO	NO_0		;(_,1)
		


SI_0
	BTFSS	PORTA,1
	GOTO	SEC_0		;(0,0)
	GOTO	SEC_2		;(1,0)

NO_0
	BTFSS	PORTA,1
	GOTO	SEC_1		;(0,1)
	GOTO	SEC_3		;(1,1)


SEC_0
	BTFSS	PORTB, 7
	GOTO	RECORRER_IZQUIERDA
	GOTO	VERIFICAR


RECORRER_IZQUIERDA
	RLF		PORTB,W
	MOVWF 	PORTB
	CALL 	RETARDO_.400ms
	GOTO	INICIO

VERIFICAR
	BTFSS	PORTB,0
	GOTO	RECORRER_DERECHA
	GOTO	INICIO

RECORRER_DERECHA
	RRF		PORTB,W
	MOVWF 	PORTB
	CALL 	RETARDO_.400ms
	GOTO	VERIFICAR

SEC_1
	GOTO 	RECORRER_IZQUIERDA

SEC_2
	RRF		PORTB,W
	MOVWF 	PORTB
	CALL 	RETARDO_.400ms
	GOTO INICIO

SEC_3
	GOTO INICIO

RETARDO_.400ms
	;PIC Time Delay = 0.40000100 s with Osc = 4000000 Hz
		movlw	D'3'
		movwf	CounterC
		movlw	D'8'
		movwf	CounterB
		movlw	D'118'
		movwf	CounterA
loop		decfsz	CounterA,1
		goto	loop
		decfsz	CounterB,1
		goto	loop
		decfsz	CounterC,1
		goto	loop
		retlw	0
		RETURN

	END                       ; directive 'end of program'

