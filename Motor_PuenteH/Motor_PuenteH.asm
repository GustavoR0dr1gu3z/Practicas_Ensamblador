list		p=16f887	; list directive to define processor
#include	<p16f887.inc>	; processor specific variable definitions


	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V


ORG 0x000 ; posici�n 0
CBLOCK 0X20
	CounterA, CounterB, CounterC, Aux, Contador
ENDC
NOP
GOTO PUERTOS ; Comienzo del programa

PUERTOS:
; SE ACCEDE AL BANCO 1 PARA USAR LOS TRIS
	BSF 			STATUS, RP0 
; SE CONFIGURAN LOS PUERTOS DE ENTRADAS Y SALIDAS
	MOVLW 		0XFF					;W = 11111111
	MOVWF 		TRISA				;PUERTO A COMO ENTRADA
	MOVLW 		0X00				;W=00000000
	MOVWF		TRISB				;PUERTO B COMO SALIDA
	MOVLW		0X00				;W=00000000
	MOVWF		TRISC				; PUERTO C COMO SALIDA
	MOVLW		0X00				;W=00000000
	MOVWF		TRISD				; PUERTO D COMO SALIDA

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
	CLRF			PORTD
	;BCF		STATUS,C

INICIO:
	BTFSS		PORTA,0 		;Est� en 1
	GOTO 		Cero0		;NO
	GOTO 		Uno0		;SI
	

Uno0:
	BTFSS 		PORTA,1		;Est� en 1
	GOTO 		SEC1		;NO
	GOTO		SEC3		;SI
	

Cero0:
	BTFSS		PORTA,1		;Est� en 1
	GOTO 		SEC0		;NO
	GOTO 		SEC2		;SI

	


; ------------------------------------------------SEC 0-------------------------------------
SEC0: 						; M1 - DERECHA
	CLRF 		Contador
	CLRF			Co

PRINT_M1DER:
	MOVF 		Contador, W
	MOVF		Contador, Co
	CALL		M1DER
	MOVWF		PORTB

PRINT_M1DER2:
	MOVF		Co,W
	CALL		M1DER2
	MOVWF		PORTC
	CALL 		RETARDO_400ms

	INCF			Contador, F
	INCF			Co, F

CONTADOR:
	MOVLW		.11
	XORWF		Contador, W
	BTFSS		STATUS, Z
	GOTO		PRINT_M1DER
	GOTO 		INICIO

; ------------------------------------------------SEC 1-------------------------------------
SEC1:						; M1 - IZQUIERDA
	CLRF 		Contador
	CLRF			Co

PRINT_M1IZQ:
	MOVF 		Contador, W
	MOVF		Contador, Co
	CALL		M1IZQ
	MOVWF		PORTB

PRINT_M1IZQ2:
	MOVF		Co,W
	CALL		M1IZQ2
	MOVWF		PORTC
	CALL 		RETARDO_400ms

	INCF			Contador, F
	INCF			Co, F

CONTADOR:
	MOVLW		.11
	XORWF		Contador, W
	BTFSS		STATUS, Z
	GOTO		PRINT_M1IZQ
	GOTO 		INICIO


; ------------------------------------------------SEC 2-------------------------------------
SEC2:						; M2 - DERECHA
	CLRF 		Contador
	CLRF			Co

PRINT_M2DER:
	MOVF 		Contador, W
	MOVF		Contador, Co
	CALL		M2DER
	MOVWF		PORTB

PRINT_M2DER2:
	MOVF		Co,W
	CALL		M2DER2
	MOVWF		PORTC
	CALL 		RETARDO_400ms

	INCF			Contador, F
	INCF			Co, F

CONTADOR:
	MOVLW		.11
	XORWF		Contador, W
	BTFSS		STATUS, Z
	GOTO		PRINT_M2DER
	GOTO 		INICIO
; ------------------------------------------------SEC 3-------------------------------------
SEC3:						; M3 - IZQUIERDA
	CLRF 		Contador
	CLRF			Co

PRINT_M3IZQ:
	MOVF 		Contador, W
	MOVF		Contador, Co
	CALL		M3IZQ
	MOVWF		PORTB

PRINT_M3IZQ:
	MOVF		Co,W
	CALL		M3IZQ2
	MOVWF		PORTC
	CALL 		RETARDO_400ms

	INCF			Contador, F
	INCF			Co, F

CONTADOR:
	MOVLW		.11
	XORWF		Contador, W
	BTFSS		STATUS, Z
	GOTO		PRINT_M3IZQ
	GOTO 		INICIO

; DISPLAY M1-DERECHA
M1DER:
	ADDWF 		PCL, F
	RETLW		b'00110011'	; M_1
	RETLW		b'11110011'	; 1_1
	RETLW		b'11111111'	; -_1
	RETLW		b'11000000'	; D_1
	RETLW		b'00001100'	; E_1
	RETLW		b'00111000'	; R_1
	RETLW		b'00001100'	; E_1
	RETLW		b'00001100'	; C_1
	RETLW		b'00110011'	; H_1
	RETLW		b'00110000'	; A_1
	RETLW		b'11111111'	; ESPACIO

M1DER2:
	ADDWF		PCL, F
	RETLW		b'11111010'	; M_2
	RETLW		b'11111011'	; 1_2
	RETLW 		b'01110111'	; -_2
	RETLW		b'11011101'	; D_2
	RETLW		b'01111111'	; E_2
	RETLW		b'01100111'	; R_2
	RETLW		b'01111111'	; E_2
	RETLW		b'11111111'	; C_2
	RETLW		b'01110111'	; H_2
	RETLW		b'01110111'	; A_2
	RETLW		b'11111111'	; ESPACIO


; DISPLAY M1-IZQUIERDA
M1IZQ:
	ADDWF 		PCL, F
	RETLW		b'00110011'	; M_1
	RETLW		b'11110011'	; 1_1
	RETLW		b'11111111'	; -_1
	RETLW		b'11001100'	; I_1
	RETLW		b'11001100'	; Z_1
	RETLW		b'00000000'	; Q_1
	RETLW		b'00000011'	; U_1
	RETLW		b'11001100'	; I_1
	RETLW		b'00001100'	; E_1
	RETLW		b'00111000'	; R_1
	RETLW		b'11000000'	; D_1
	RETLW		b'00110000'	; A_1
	RETLW		b'11111111'	; ESPACIO

M1IZQ2:
	ADDWF		PCL, F
	RETLW		b'11111010'	; M_2
	RETLW		b'11111011'	; 1_2
	RETLW 		b'01110111'	; -_2
	RETLW		b'11011101'	; I_2
	RETLW		b'10111011'	; Z_2
	RETLW		b'11101111'	; Q_2
	RETLW		b'11111111'	; U_2
	RETLW		b'11011101'	; I_2
	RETLW		b'01111111'	; E_2
	RETLW		b'01100111'	; R_2
	RETLW		b'11011101'	; D_2
	RETLW		b'01110111'	; A_2
	RETLW		b'11111111'	; ESPACIO


; DISPLAY M2-DERECHA
M2DER:
	ADDWF 		PCL, F
	RETLW		b'00110011'	; M_1
	RETLW		b'10001000'	; 2_1
	RETLW		b'11111111'	; -_1
	RETLW		b'11000000'	; D_1
	RETLW		b'00001100'	; E_1
	RETLW		b'00111000'	; R_1
	RETLW		b'00001100'	; E_1
	RETLW		b'00001100'	; C_1
	RETLW		b'00110011'	; H_1
	RETLW		b'00110000'	; A_1
	RETLW		b'11111111'	; ESPACIO

M2DER2:
	ADDWF		PCL, F
	RETLW		b'11111010'	; M_2
	RETLW		b'01110111'	; 2_2
	RETLW 		b'01110111'	; -_2
	RETLW		b'11011101'	; D_2
	RETLW		b'01111111'	; E_2
	RETLW		b'01100111'	; R_2
	RETLW		b'01111111'	; E_2
	RETLW		b'11111111'	; C_2
	RETLW		b'01110111'	; H_2
	RETLW		b'01110111'	; A_2
	RETLW		b'11111111'	; ESPACIO
	

; DISPLAY M2-IZQUIERDA
M2IZQ:
	ADDWF 		PCL, F
	RETLW		b'00110011'	; M_1
	RETLW		b'10001000'	; 2_1
	RETLW		b'11111111'	; -_1
	RETLW		b'11001100'	; I_1
	RETLW		b'11001100'	; Z_1
	RETLW		b'00000000'	; Q_1
	RETLW		b'00000011'	; U_1
	RETLW		b'11001100'	; I_1
	RETLW		b'00001100'	; E_1
	RETLW		b'00111000'	; R_1
	RETLW		b'11000000'	; D_1
	RETLW		b'00110000'	; A_1
	RETLW		b'11111111'	; ESPACIO

M2IZQ2:
	ADDWF		PCL, F
	RETLW		b'11111010'	; M_2
	RETLW		b'01110111'	; 2_2
	RETLW 		b'01110111'	; -_2
	RETLW		b'11011101'	; I_2
	RETLW		b'10111011'	; Z_2
	RETLW		b'11101111'	; Q_2
	RETLW		b'11111111'	; U_2
	RETLW		b'11011101'	; I_2
	RETLW		b'01111111'	; E_2
	RETLW		b'01100111'	; R_2
	RETLW		b'11011101'	; D_2
	RETLW		b'01110111'	; A_2
	RETLW		b'11111111'	; ESPACIO




; -----------------------------------------------RETARDO---------------------------------
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
