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

	CBLOCK 0X20							; Direcció De Memoria Para Las Variables
		CounterA, CounterB, CounterC			; Variable Para El Retardo
		Cont	
	ENDC		


	#DEFINE 	RS 			PORTA, 0			; Rs
	#DEFINE	E			PORTA, 1 			; Enable

ORG 0x000 ; posición 0

GOTO CONF_PUERTOS ; Comienzo del programa

CONF_PUERTOS:
	BSF 					STATUS, RP0		; RP0 = Registro 1 de status
	MOVLW				0X00			; 00000000
	MOVWF				TRISB			; Puerto B Como Salida
	MOVLW				0X00			; 00000000
	MOVWF				TRISA			; Puerto A como Entrada y Salida
	BCF					STATUS, RP0		; RP0 = Registro Status
	CLRF				PORTA			; Limpiar PORTA (Poner en 0's)
	CLRF				PORTB			; Limpiar PORTB (Poner en 0's)


; INICIALIZACION DE LA PANTALLA LCD
	MOVLW				H'38'			; Bus de datos de 8 pines 
	CALL 				CONTROL
	MOVLW				h'0C'				; Enciende LCD y apaga cursor
	CALL				CONTROL
	MOVLW				H'01'			; Limpia la pantala
	CALL 				CONTROL	

REINICIAR:
	CLRF 				Cont
VISUALIZAR_LCD:
	MOVWF				Cont,W
	CALL				TABLA
	CALL				CARACTER
	INCF				Cont, F
	MOVLW				.30
	XORWF				Cont	
	BTFSS				STATUS, Z
	GOTO				VISUALIZAR_LCD	; Z = 0
	CALL				RETARDO		; Z = 1
	MOVLW				H'01'
	CALL				CONTROL
	CALL				RETARDO
	GOTO 				REINICIAR

TABLA:
	ADDWF				PCL,F
	DT					"Hola Mundo ICO Gustavo Calzada"

CARACTER:
	BSF					RS
	GOTO				CARGA
CONTROL:
	BCF					RS				; Decir a la LCD que le mandaremos una instrucción de control
	MOVWF				PORTB			; Mostrara la literal
	BSF					E				; Habilita el enable
	CALL				RETARDOP	
	BCF					E				; Desabilita el Enable
	CALL				RETARDOP
	RETURN

; RETARDO 
RETARDO: 								; 300 ms
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
RETARDOP:
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