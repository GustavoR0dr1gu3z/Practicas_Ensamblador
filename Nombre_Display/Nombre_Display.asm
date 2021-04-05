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
ORG     0x000					; processor reset vector

CBLOCK 0X20
				Contador, CounterA, CounterB, CounterC, Co
ENDC


GOTO PUERTOS 				; Comienzo del programa

PUERTOS:
							
	BSF 			STATUS, RP0 	; SE ACCEDE AL BANCO 1 PARA USAR LOS TRIS

							; SE CONFIGURAN LOS PUERTOS DE ENTRADAS Y SALIDAS
	MOVLW 		0X00		;W = 00000000
	MOVWF 		TRISB		;PUERTO B COMO SALIDA
	MOVLW		0X00
	MOVWF		TRISC

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
	CLRF			PORTC

INICIO:
	CLRF 		Contador
	CLRF			Co
DISPLAY1:
	MOVF		Contador,W
	MOVF		Contador,Co
	CALL		TABLA1
	MOVWF		PORTB

DISPLAY2:
	MOVF		Co,W
	CALL 		TABLA2
	MOVWF 		PORTC
	CALL		RETARDO_400ms

	INCF			Contador, F
	INCF			Co,F

CONTADOR:
	MOVLW		.26
	XORWF		Contador,W
	BTFSS		STATUS, Z 	; Si Z = 1      El bit Z se usa mucho para saber si un número es igual a otro.
	GOTO 		DISPLAY1
	GOTO 		INICIO

TABLA1:
	ADDWF		PCL, F
	RETLW		b'11111011'	; G_1
	RETLW		b'11111100'	; U_1
	RETLW		b'10111011'	; S_1
	RETLW		b'00000011'	; T_1
	RETLW		b'11001111'	; A_1
	RETLW		b'11000000'	; V_1
	RETLW		b'11111111'	; O_1
	RETLW		b'00000000'	; ESPACIO
	RETLW		b'11000111'	; R_1
	RETLW		b'11111111'	; O_1
	RETLW		b'00111111'	; D_1
	RETLW		b'11000111'	; R_1
	RETLW		b'00110011'	; I_1
	RETLW		b'11111011'	; G_1
	RETLW		b'11111100'	; U_1
	RETLW		b'11110011'	; E_1
	RETLW		b'00110011'	; Z_1
	RETLW		b'00000000'	; ESPACIO
	RETLW		b'11110011'	; C_1
	RETLW		b'11001111'	; A_1
	RETLW		b'11110000'	; L_1
	RETLW		b'00110011'	; Z_1
	RETLW		b'11001111'	; A_1
	RETLW		b'00111111'	; D_1
	RETLW		b'11001111'	; A_1
	RETLW		b'00000000'	; ESPACIO

TABLA2:
	ADDWF 		PCL,F
	RETLW		b'00001000'	; G_2	
	RETLW		b'00000000'	; U_2
	RETLW		b'10001000'	; S_2
	RETLW		b'00100010'	; T_2
	RETLW		b'10001000'	; A_2
	RETLW		b'01000100'	; V_2
	RETLW		b'00000000'	; O_2
	RETLW		b'00000000'	; ESPACIO
	RETLW		b'10011000'	; R_2
	RETLW		b'00000000'	; O_2
	RETLW		b'00100010'	; D_2
	RETLW		b'10011000'	; R_2
	RETLW		b'00100010'	; I_2
	RETLW		b'00001000'	; G_2	
	RETLW		b'00000000'	; U_2
	RETLW		b'10000000'	; E_2
	RETLW		b'01000100'	; Z_2
	RETLW		b'00000000'	; ESPACIO
	RETLW		b'00000000'	; C_2
	RETLW		b'10001000'	; A_2
	RETLW		b'00000000'	; L_2
	RETLW		b'01000100'	; Z_2
	RETLW		b'10001000'	; A_2
	RETLW		b'00100010'	; D_2
	RETLW		b'10001000'	; A_2
	RETLW		b'00000000'	; ESPACIO



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