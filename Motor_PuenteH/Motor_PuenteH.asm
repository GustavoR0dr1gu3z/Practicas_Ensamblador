list		p=16f887	; list directive to define processor
#include	<p16f887.inc>	; processor specific variable definitions


	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V


ORG 0x000 ; posición 0
CBLOCK 0X20
	CounterA, CounterB, CounterC, Aux, Contador
ENDC
NOP
GOTO PUERTOS ; Comienzo del programa

PUERTOS:
; SE ACCEDE AL BANCO 1 PARA USAR LOS TRIS
	BSF 			STATUS, RP0 
; SE CONFIGURAN LOS PUERTOS DE ENTRADAS Y SALIDAS
	MOVLW 		0XFF					;W = 11111111
	MOVWF 		TRISA				;PUERTO A COMO ENTRADA
	MOVLW 		0X00				;W=00000000
	MOVWF		TRISB				;PUERTO B COMO SALIDA
	MOVLW		0X00				;W=00000000
	MOVWF		TRISC				; PUERTO C COMO SALIDA
	MOVLW		0X00				;W=00000000
	MOVWF		TRISD				; PUERTO D COMO SALIDA

;SE ACCEDE AL BANCO 3 PARA LOS ANSEL, ANSELH
	BSF 			STATUS, RP1
;SE LIMPIAN (coloca 0's)LOS REGISTROS ANSEL, ANSELH PARA E/S DIGITAL
	CLRF 		ANSEL
	CLRF 		ANSELH

;SE ACCEDE AL BANCO 0 PARA LOS PUERTOS
	BCF 			STATUS, RP1
	BCF 			STATUS, RP0
;SE COLOCA EN CEROS LOS PUERTOS
	CLRF 		PORTB
	CLRF 		PORTA
	CLRF 		PORTC
	CLRF			PORTD
	;BCF		STATUS,C

INICIO:
	BTFSS		PORTA,0 		;Está en 1
	GOTO 		Cero0		;NO
	GOTO 		Uno0		;SI
	

Uno0:
	BTFSS 		PORTA,1		;Está en 1
	GOTO 		SEC1		;NO
	GOTO		SEC3		;SI
	

Cero0:
	BTFSS		PORTA,1		;Está en 1
	GOTO 		SEC0		;NO
	GOTO 		SEC2		;SI

	


; ------------------------------------------------SEC 0-------------------------------------
SEC0: 						; M1 - DERECHA
	CLRF 		Contador
	CLRF			Co

PRINT_M1DER:
	MOVF 		Contador, W
	MOVF		Contador, Co
	CALL		M1DER
	MOVWF		PORTB

PRINT_M1DER2:
	MOVF		Co,W
	CALL		M1DER2
	MOVWF		PORTC
	CALL 		RETARDO_400ms

	INCF			Contador, F
	INCF			Co, F

CONTADOR:
	MOVLW		.26
	XORWF		Contador, W
	BTFSS		STATUS, Z
	GOTO		PRINT_M1DER
	GOTO 		INICIO

; ------------------------------------------------SEC 1-------------------------------------
SEC1:						; M1 - IZQUIERDA

; ------------------------------------------------SEC 2-------------------------------------
SEC2:						; M2 - DERECHA

; ------------------------------------------------SEC 3-------------------------------------
SEC3:						; M3 - IZQUIERDA

; -----------------------------------------------RETARDO---------------------------------

PRINT_M1DER:
	ADDWF 		PCL, F
	RETLW		b'00110011'	; M_1
	RETLW		b'11110011'	; 1_1
	RETLW		b'11111111'	; -_1
	RETLW		b'11000000'	; D_1
	RETLW		b'00001100'	; E_1
	RETLW		b'00111000'	; R_1
	RETLW		b'00001100'	; E_1
	RETLW		b'00001100'	; C_1
	RETLW		b''




RETARDO_400ms:
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
	END                      
