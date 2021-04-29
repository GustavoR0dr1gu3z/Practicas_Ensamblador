list		p=16f887	; list directive to define processor
#include	<p16f887.inc>	; processor specific variable definitions

	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

	CBLOCK 0X20
		CounterA, CounterB, CounterC
		W_RES, STATUS_RES
		CONT, PUNTERO, HABILITA
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
	MOVLW				OXF0
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


