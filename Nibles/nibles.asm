;**********************************************************************
;   This file is a basic code template for assembly code generation   *
;   on the PIC16F887. This file contains the basic code               *
;   building blocks to build upon.                                    *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler (Document DS33014).                     *
;                                                                     *
;   Refer to the respective PIC data sheet for additional             *
;   information on the instruction set.                               *
;                                                                     *
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


	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

ORG 0x000 ; posición 0

;* VARIABLE DEFINITIONS
CBLOCK 	0X20
		NIBLES, SUMA_PORTA, SUMA_PORTC, ICO_8
ENDC
CBLOCK 0X50
		CounterA, CounterB, CounterC
ENDC


GOTO INICIO ; Comienzo del programa

INICIO:
; SE ACCEDE AL BANCO 1 PARA USAR LOS TRIS
	BSF 			STATUS, RP0 
; SE CONFIGURAN LOS PUERTOS DE ENTRADAS Y SALIDAS
	MOVLW 		0XFF		;W = 11111111
	MOVWF 		TRISA		;PUERTO A COMO ENTRADA
	MOVWF 		TRISC		;PUERTO C COMO ENTRADA
	MOVLW 		0X00		; W=00000000
	MOVWF		TRISB		;PUERTO B COMO SALIDA

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
	CLRF 		PORTC
	CLRF 		PORTA


CARGAR_DATOS:
	MOVF 		PORTA,W			;   W = 1010 1111
	MOVWF		NIBLES			;   NIBLES = 1010 1111
	SWAPF 		NIBLES,W 		;   W = 1111 1010
	ANDLW		0X0F			;   W = 1111 1010 AND 0000 1111
	MOVWF		ICO_8			;   ICO_8 = 0000 1010

	MOVF		NIBLES,W		;  W = NIBLES = 1010 1111 
	ANDLW		0X0F			;  W = 1010 1111 AND 0000 1111 = 0000 1111
	
	ADDWF		ICO_8, W			;  W = 0000 1010 + 0000 1111 = 0001 1000
	MOVWF 		SUMA_PORTA	         ;  SUMA_PORTA = 0001 1001  
		 
	;CLRF 		NIBLES			;   LIMPIAR/COLOCAR EN CEROS LA VARIABLE NIBLES
	CALL 		RETARDO_400ms
	MOVF 		PORTC,W			;   W = 1101 0001
	MOVWF		NIBLES			;   NIBLES = 1101 0001
	SWAPF 		NIBLES,W 		;   W = 0001 1101
	ANDLW		0X0F			;   W = 0001 1101 AND 0000 1111
 	MOVWF		ICO_8			;   ICO_8 = 0000 1101

	MOVF		NIBLES,W		;  W = NIBLES = 1101 0001
	ANDLW		0X0F			;  W = 1101 0001 AND 0000 1111 = 0000 0001
	
	ADDWF		ICO_8, W			;  W = 0000 1101 + 0000 0001 = 0001 1000 = 0000 1110

	ADDWF 		SUMA_PORTA,W	; SE SUMA 0001 1001 + 0000 1110 = 0010 0111
	MOVWF 		PORTB			; SE MUESTRA AL PUERTOB

RETARDO_400ms
	;PIC Time Delay = 0,40000100 s with Osc = 4000000 Hz
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