list		p=16f887	; list directive to define processor
#include	<p16f887.inc>	; processor specific variable definitions

	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

	CBLOCK 0X20
		CounterA, CounterB, CounterC
		W_RES, STATUS_RES
		CONT, PUNTERO, HABILITA
		inve, inve2
	ENDC

	ORG 0X00
		GOTO			CONFIGURACION
	ORG 0X04
		GOTO			INTERRUPCION

CONFIGURACION:
	CLRW
	BSF 					STATUS, RP0
	MOVLW				0X00
	MOVWF				TRISB
	MOVLW				0XF0
	MOVWF				TRISA
	BCF					STATUS, RP0
	CLRF					PORTA
	CLRF					PORTB
	BSF					HABILITA,3

CONFI_TMR0:
	MOVLW				b'10100000'
	
INTCONN:
	MOVWF				INTCON
	BSF					STATUS, RP0
	MOVLW				b'10000010'

OPTION_REGG:
	MOVWF				OPTION_REG
	BCF					STATUS, RP0
	CLRF					CONT
	CLRF					PUNTERO

INICIO:
	CALL				RETARDO
	INCF					PUNTERO, 1
	MOVF				PUNTERO, 0
	SUBLW				0X19
	BTFSS				STATUS, Z
	GOTO 				INICIO
	CLRF					PUNTERO
	GOTO 				INICIO


INTERRUPCION:
	MOVWF				W_RES
	SWAPF				STATUS, W
	MOVWF				STATUS_RES
	MOVF				CONT, 0
	SUBLW				0X04
	BTFSS				STATUS, Z
	GOTO 				CICLO
	CLRF					CONT
	CLRF					HABILITA
	BSF					HABILITA, 3

CICLO:
	MOVF				CONT, 0
	ADDWF				PUNTERO, 0
	CALL				TABLA	
	MOVWF				inve									; Variable para invertir
	COMF				inve, W								; Hace el complemento de la salida
	MOVWF				PORTB
	MOVF				HABILITA, 0
	MOVWF				inve2									; Variable para invertir
	COMF				inve2, W								; Hace el complemento de la salida
	MOVWF				PORTA
	INCF					CONT, 1
	RRF					HABILITA, F
	SWAPF				STATUS_RES, W
	MOVWF				STATUS
	SWAPF				W_RES, W_RES
	SWAPF				W_RES, W
	BCF					INTCON, T0IF
	RETFIE

TABLA
	ADDWF				PCL, 1
	RETLW				b'11111111'		; ESPACIO
	RETLW				b'10000110'		; E
	RETLW				b'11000111'		; L
	RETLW				b'11111111'		; ESPACIO
	RETLW				b'10001100'		; P
	RETLW				b'10001000'		; A
	RETLW				b'11000111'		; L
	RETLW				b'11001111'		; I
	RETLW				b'11000111'		; L
	RETLW				b'11000111'		; L		
	RETLW				b'11000000'		; O
	RETLW				b'11111111'		; ESPACIO
	RETLW				b'11000000'		; O
	RETLW				b'11111111'		; ESPACIO
	RETLW				b'10000110'		; E
	RETLW				b'11000111'		; L
	RETLW				b'11111111'		; ESPACIO
	RETLW				b'10001110'		; F
	RETLW				b'11000000'		; O
	RETLW				b'11000110'		; C
	RETLW				b'11000000'		; O
	RETLW				b'11111111'		; ESPACIO
	RETLW				b'10000110'		; E
	RETLW				b'10010010'		; S
	RETLW				b'11111111'		; ESPACIO
	RETLW				b'11000110'		; C
	RETLW				b'10001000'		; A
	RETLW				b'10001110'		; F
	RETLW				b'10000110'		; E
	RETLW				b'11111111'		; ESPACIO
	RETLW 				b'11100001'		; J
	RETLW				b'10001000'		; A
	RETLW 				b'11100001'		; J
	RETLW				b'10001000'		; A
	RETLW				b'11111111'		; ESPACIO

RETARDO 													; 300 ms
	movlw				D'2'
	movwf				CounterC
	movlw				D'134'
	movwf				CounterB
	movlw				D'152'
	movwf				CounterA
loop	decfsz				CounterA,1
	goto					loop
	decfsz				CounterB,1
	goto					loop
	decfsz				CounterC,1
	goto					loop
	retlw					 0
		RETURN
	END