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
		SUMA1, SUMA2	 
ENDC

GOTO INICIO ; Comienzo del programa

INICIO:
; SE ACCEDE AL BANCO 1 PARA USAR LOS TRIS
	BSF STATUS, RP0 
; SE CONFIGURAN LOS PUERTOS DE ENTRADAS Y SALIDAS
	MOVLW 		0XFF			;W = 11111111
	MOVWF 		TRISA		;PUERTO A COMO ENTRADA
	MOVWF 		TRISC		;PUERTO C COMO ENTRADA

	MOVLW 		0X00		;W = 00000000
	MOVWF 		TRISB		;PUERTO B COMO SALIDA
	MOVLW		b'11111110'
	MOVWF 		TRISD		;BIT 0, SE COMPORTA COMO SALIDA 

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
	CLRF 		PORTD

CARGAR_DATOS:
	MOVF		PORTA,W			 ;LEER EL PUERTO A
	MOVWF 		SUMA1 			;SE AGREGA A SUMA1
	MOVF 		PORTC,W
	MOVWF 		SUMA2 			;INFORMACION DEL PUERTO C


	MOVF 		SUMA1,W 		;GUARDAMOS SUMA1 EN W
	ADDWF 		SUMA2,W 		;SUMA1+SUMA2 = W
	MOVWF 		PORTB 			;SALIDA DE LA SUMA

	BTFSS 		STATUS,C 		;SI AL SUMAR ESTO HAY ACARREO
	GOTO 		CARRY_0
	GOTO 		CARRY_1

CARRY_0
	BCF			PORTD,0
	GOTO 		CARGAR_DATOS

CARRY_1
	BSF			PORTD,0		
	GOTO 		CARGAR_DATOS
	END