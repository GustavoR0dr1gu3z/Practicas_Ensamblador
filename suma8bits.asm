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

	SUMA
	SUMA_1
	SUMA_2
	ADENDO
	RESU

	NOP
	GOTO INICIO

INICIO:
	BSF STATUS, RP0

	MOVLW D'255'	;MANDAR 11111111 A LA ENTRADA
	MOVWF TRISA		;PUERTO A COMO ENTRADA

	MOVLW 0X00		;MANDAR 0 A LA SALIDA
	MOVWF TRISB		;PUERTO B COMO SALIDA

	MOVLW D'255'	;MANDAR 11111111 A LA ENTRADA
	MOVWF TRISC		;PUERTO C COMO ENTRADA


	BSF STATUS, RP1

	MOVLW	0X00			
	MOVWF 	ANSEL			
	CLRF	ANSELH


	BCF STATUS, RP0
	BCF STATUS, RP1
	
	CLRF PORTA
	CLRF PORTB
	CLRF PORTC
	
CARGAR:  	
	MOVF PORTA,W	;VAMOS A LEER EL PUERTO A Y SE QUEDA EN W
	MOVWF SUMA		;LA INFO DEL PUERTO A, SE QUEDA EN SUMA

	MOVF PORTC,W	;VAMOS A LEER EL PUERTO C Y SE QUEDA EN W
	MOVWF ADENDO	;LA INFO DEL PUERTO C, SE QUEDA EN ADENDO

	MOVF SUMA,W		;LEEMOS LA VARIABLE SUMA Y SE QUEDA EN W
	ADDWF ADENDO,W	;SUMAMOS W CON ADENDO
	MOVF ADENDO, RESU

	MOVF RESU,W
	MOVWF PORTB	;AQUI SE MOSTRARÁ EL RESULTADO DE LA SUMA
	GOTO CARGAR

END              

