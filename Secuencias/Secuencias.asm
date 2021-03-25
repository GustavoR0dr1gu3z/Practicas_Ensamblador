list		p=16f887	; list directive to define processor
#include	<p16f887.inc>	; processor specific variable definitions


	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V


ORG 0x000 ; posici�n 0
CBLOCK 0X20
	CounterA, CounterB, CounterC, Aux, Contador
ENDC


GOTO PUERTOS ; Comienzo del programa

PUERTOS:
; SE ACCEDE AL BANCO 1 PARA USAR LOS TRIS
	BSF 			STATUS, RP0 
; SE CONFIGURAN LOS PUERTOS DE ENTRADAS Y SALIDAS
	MOVLW 		0XFF					;W = 11111111
	MOVWF 		TRISA				;PUERTO A COMO ENTRADA
	MOVLW 		0X00				;W=00000000
	MOVWF		TRISB				;PUERTO B COMO SALIDA

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

INICIO:
	BTFSC		PORTA,0 		;Est� en 0
	GOTO 		TEST_2		;NO
	GOTO 		TEST_1		;SI
	

TEST_1:
	BTFSC 		PORTA,1		;Est� en 0
	GOTO 		SEC2		;NO
	GOTO 		SEC0		;SI

TEST_2:
	BTFSC		PORTA,1		;Est� en 0
	GOTO		SEC3		;NO
	GOTO 		SEC1		;SI	
; ------------------------------------------------SEC 0-------------------------------------
SEC0:
	BCF			STATUS, C
	MOVLW		b'00000001'		;ENCENDER EL BIT 0
	MOVWF 		PORTB
	CALL		RETARDO_400ms

CARGAR_DATOS_IZQ:
	BTFSS		PORTB, 7			;EL BIT 7 DEL PUERTO B EST� EN �1?
	GOTO		CERO			;SINO EST� EN 1 
	GOTO 		UNO				;EST� EN 1

CARGAR_DATOS_DER:
	BTFSS		PORTB, 1			;EL BIT 1  DEL PUERTO B EST� EN �1?
	GOTO		CERO_D			;SINO EST� EN 1 
	GOTO 		FINAL			;EST� EN 1

CERO:
	RLF 			PORTB, 0
	MOVWF 		PORTB
	CALL		RETARDO_400ms
	GOTO 		CARGAR_DATOS_IZQ
UNO:
	RRF			PORTB, 0 
	MOVWF 		PORTB
	CALL		RETARDO_400ms
	GOTO 		CARGAR_DATOS_DER

CERO_D:
	RRF			PORTB, 0
	MOVWF		PORTB
	CALL		RETARDO_400ms
	GOTO 		CARGAR_DATOS_DER

FINAL:
	BCF			STATUS, C
	MOVLW		b'00000001'			;ENCENDER EL BIT 0
	MOVWF 		PORTB
	GOTO		INICIO

; ------------------------------------------------SEC 1-------------------------------------
SEC1:
	BCF			STATUS, C
	MOVLW		b'00000001'		;ENCENDER EL BIT 0
	MOVWF 		PORTB
	CALL		RETARDO_400ms

CARGAR_DATOS_IZQ_SEC1:
	BTFSS		PORTB, 7			;EL BIT 7 DEL PUERTO B EST� EN �1?
	GOTO		CERO_SEC1		;SINO EST� EN 1 
	GOTO 		UNO_SEC1		;EST� EN 1

CERO_SEC1:
	RLF 			PORTB, 0
	MOVWF 		PORTB
	CALL		RETARDO_400ms
	GOTO 		CARGAR_DATOS_IZQ_SEC1	

UNO_SEC1:
	GOTO INICIO
; ------------------------------------------------SEC 2-------------------------------------
SEC2:
	BCF			STATUS, C
	MOVLW		b'10000000'			;ENCENDER EL BIT 7
	MOVWF 		PORTB
	CALL		RETARDO_400ms

CARGAR_DATOS_DER_SEC2:
	BTFSS		PORTB, 0				;EL BIT 0  DEL PUERTO B EST� EN �1?
	GOTO		CERO_D_SEC2			;SINO EST� EN 1 
	GOTO 		UNO_D_SEC2			;EST� EN 1

CERO_D_SEC2:
	RRF			PORTB, 0
	MOVWF		PORTB
	CALL		RETARDO_400ms
	GOTO 		CARGAR_DATOS_DER_SEC2

UNO_D_SEC2:
	BCF			STATUS, C
	MOVLW		b'00000001'			;ENCENDER EL BIT 0
	MOVWF 		PORTB
	GOTO 		INICIO

; ------------------------------------------------SEC 3-------------------------------------
SEC3:
	CLRF			Contador
	

PRIN_SEC3
	MOVF		Contador, W
	CALL 		TABLA
	MOVWF		PORTB
	CALL 		RETARDO_400ms
	INCF			Contador, F	

	MOVLW		.6
	XORWF		Contador,W
	BTFSS		STATUS, Z 	; Si Z = 1
	GOTO 		PRIN_SEC3
	GOTO 		INICIO
	
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
