	list		p=16f887	; list directive to define processor
	#include	<p16f887.inc>	; processor specific variable definitions


; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.

__CONFIG   _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT 
__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V


CBLOCK 0X20 ; Dirección de memoria para las variables
CounterA, CounterB, CounterC
CONT, W_RES, STAT_RES, PTA
ENDC ; Fin de bloque de librerías

CBLOCK 0X30
UNIDAD,DECENA,CENTENA,MILLAR ;Variables del programa principal
ENDC

;**********************************************************************
ORG 0x00 ; posición 0
GOTO PUERTOS ; Comienzo del programa

ORG 0X04
GOTO INTERRUPCION

PUERTOS:
	CLRW
	BSF 		STATUS, RP0
	MOVLW 	0X00
	MOVWF	TRISB
	MOVLW	0XF0
	MOVWF	TRISA

	BCF		STATUS, RP1
	BCF 		STATUS, RP0
	CLRF		PORTA
	CLRF 	PORTB
	BCF 		PTA,0

CONFI_TMR0:
	MOVLW	b'10100000'

INTCONN:
	MOVWF	INTCON
	BSF		STATUS, RP0
	MOVLW	b'10000001'

OPTION_REGG:
	MOVWF	OPTION_REG
	BCF		STATUS, RP0
	MOVLW	0X00
	MOVWF	CONT

INICIO:
	MOVLW 	0X00
	MOVWF	UNIDAD
	MOVWF	DECENA
	MOVWF	CENTENA
	MOVWF	MILLAR

UNI:
	CALL 	RETARDO
	INCF		UNIDAD,1
	MOVF	UNIDAD,0
	SUBLW	0AH
	BTFSS	STATUS,Z
	GOTO	UNI
	GOTO 	DECE

DECE:
	CLRF		UNIDAD
	INCF		DECENA,1
	MOVF	DECENA,0
	SUBLW	06H
	BTFSS	STATUS,Z
	GOTO 	UNI
	GOTO	CENTE

CENTE:
	CLRF 	UNIDAD
	CLRF		DECENA
	INCF 	CENTENA,1
	MOVF	CENTENA,0
	SUBLW	0AH
	BTFSS	STATUS,Z
	GOTO	UNI
	GOTO 	MILL

MILL:
	CLRF		UNIDAD
	CLRF		DECENA
	CLRF		CENTENA
	INCF		MILLAR,1
	MOVF	MILLAR,0
	SUBLW	06H
	BTFSS	STATUS,Z
	GOTO 	UNI
	GOTO 	INICIO

INTERRUPCION:
	MOVWF 	W_RES
	SWAPF	STATUS, W
	MOVWF	STAT_RES
	MOVF	CONT,0
	SUBLW	0X04
	BTFSS	STATUS,Z
	GOTO 	CICLO
	CLRF		CONT
	CLRF		PTA
	BSF		PTA, 0

CICLO:
	MOVF	CONT, 0
	ADDLW	0X30
	    MOVWF 			FSR 									; FSR <- W
	    MOVF 				INDF, 0 								; W <- INDF
	    CALL 				TABLA								 ; Llama a la subrutina tabla
	    MOVWF 			PORTB 								; PORTB <- W
	    MOVF 				PTA,0   								; W <- PTA
	    MOVWF 			PORTA								; PORTA <- W
	    INCF 				CONT, 1 								; CONT = CONT+1
	    RLF 				PTA 									; PTA = PTA*2
	    SWAPF 			STAT_RES, W							; W_RES = SWAP(W_RES)
	    MOVWF 			STATUS 								; W = SWAP(W_RES)
	    SWAPF				W_RES, W_RES
	    SWAPF				W_RES, W
	    BCF 				INTCON, T0IF 							; Limpia el bit T0IF del registro INTCON
	    RETFIE 								


TABLA:
	ADDWF		PCL, 1; Suma PCL <- W+PCL
	RETLW		b'11000000'	; 0
	RETLW 		b'11111001'	; 1
	RETLW		b'10100100'	; 2
	RETLW		b'10110000'	; 3
	RETLW		b'10011001'	; 4
	RETLW		b'10010010'	; 5
	RETLW		b'10000010'	; 6
	RETLW 		b'11111000' 	; 7
	RETLW		b'10000000'	; 8
	RETLW		b'10011000'	; 9

RETARDO:
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