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



;**********************************************************************
list		p=16f887	; list directive to define processor
#include	<p16f887.inc>	; processor specific variable definitions


	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V


ORG 0x000 ; posici�n 0
CBLOCK 0X20

ENDC

GOTO CONF_PUERTOS ; Comienzo del programa

CONF_PUERTOS:
	BSF 					STATUS, RP0		; RP0 = Registro 1 de status
	MOVLW				0X00			; 00000000
	MOVWF				TRISB			; Puerto B Como Salida
	MOVLW				0X00			; 11110000
	MOVWF				TRISA			; Puerto A como Entrada y Salida
	BCF					STATUS, RP0		; RP0 = Registro Status
	CLRF				PORTA			; Limpiar PORTA (Poner en 0's)
	CLRF				PORTB			; Limpiar PORTB (Poner en 0's)



; RETARDO 
RETARDO 								; 300 ms
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
  


; RUTINA DE RETARDO 5ms PARA PROCESAMIENTO DE INSTRUCCIONES
;PIC Time Delay = 0,00500100 s with Osc = 4000000 Hz
		movlw	D'7'
		movwf	CounterB
		movlw	D'124'
		movwf	CounterA
loop		decfsz	CounterA,1
		goto	loop
		decfsz	CounterB,1
		goto	loop
		retlw	0
		END