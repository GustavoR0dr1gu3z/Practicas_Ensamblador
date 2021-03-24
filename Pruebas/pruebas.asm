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

;**********************************************************************
ORG     0x000             ; processor reset vector

CBLOCK 0X20
	Contador
ENDC

GOTO 	INICIO           ; go to beginning of program

INICIO
; SE ACCEDE AL BANCO 1 PARA USAR LOS TRIS
	BSF STATUS, RP0 
; SE CONFIGURA EL PUERTO B COMO SALIDA
	MOVLW 		0X00		;W = 00000000
	MOVWF 		TRISB		;PUERTO B COMO SALIDA
	
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
REINICIAR
	CLRF			Contador

PRINCIPAL:
	MOVF		Contador, W
	CALL 		TABLA
	MOVWF		PORTB
	CALL 		RETARDO_400ms
	INCF			Contador, F	

	MOVLW		.6
	XORWF		Contador
	BTFSS		STATUS, Z 	; Si Z = 1
	GOTO 		PRINCIPAL
	GOTO 		REINICIAR


TABLA:
	ADDWF		PCL, F
	RETLW		b'10000001'
	RETLW		b'01000010'
	RETLW		b'00100100'
	RETLW		b'00011000'
	RETLW		b'00100100'
	RETLW		b'01000010'

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