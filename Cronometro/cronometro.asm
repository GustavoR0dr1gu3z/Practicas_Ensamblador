	list		p=16f887	; list directive to define processor
	#include	<p16f887.inc>	; processor specific variable definitions


; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.

	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

CBLOCK 0X20 ; Dirección de memoria para las variables
CounterA, CounterB, CounterC
UNIDAD, CENTENA, DECENA, MILLAR
CONT, W_RES, STAT_RES
ENDC ; Fin de bloque de librerías


;**********************************************************************

GOTO PUERTOS ; Comienzo del programa

PUERTOS:
; SE ACCEDE AL BANCO 1 PARA USAR LOS TRIS
	BSF 			STATUS, RP0 
; SE CONFIGURAN LOS PUERTOS DE ENTRADAS Y SALIDAS
	MOVLW 		0XF0						;W = 11110000
	MOVWF 		TRISA					;PINES PUERTO A, SALIDA Y ENTRADAS
	MOVLW 		0X00					;W = 00000000
	MOVWF		TRISB					;PUERTO B COMO SALIDA

;SE ACCEDE AL BANCO 3 PARA LOS ANSEL, ANSELH
	BSF 			STATUS, RP1
;SE LIMPIAN (coloca 0's)LOS REGISTROS ANSEL, ANSELH PARA E/S DIGITAL
	CLRF 		ANSEL
	CLRF 		ANSELH

;SE ACCEDE AL BANCO 0 PARA LOS PUERTOS
	BCF 			STATUS, RP1
	BCF 			STATUS, RP0
;SE COLOCA EN CEROS LOS PUERTOS
	CLRF 		PORTA
	CLRF 		PORTB
; PONER EL BIT 0 DE LA VARIABLE PTA EN 0
	BSF 			PTA, 0 

CONFIGURAR_TMR0									 ; Configuración del TMR0 (Interrupción)
	MOVLW B'10100000' 						 ; Asignación de valores a las banderas del registro
	
INTCONN:
	    MOVWF 			INTCON 					; Asignarle 10100000 a INTCON
	    BSF				STATUS. RP0
	    MOVLW 			b'10000001'				; Asignación de valores a las banderas del registro
OPTION_REGG:
	    MOVWF 			OPTION_REG				; Asignar los valores a option_reg
	    BCF STATUS, RP0
	    MOVLW 0X00							 	; Inicialización de la variable CONT
	    MOVWF CONT								; Poner en 0's la variable contador

INICIO
	    MOVLW 			0X00 
	    MOVWF 			UNIDAD					; Poner en ceros la variable UNIDAD
	    MOVLW 			0X00
	    MOVWF 			DECENA  					; Poner en ceros la variable DECENA
	    MOVLW 			0X00
	    MOVWF 			CENTENA 				; Poner en ceros la variable CENTENA
	    MOVLW 			0X00
	    MOVWF 			MILLAR 					; Poner en ceros la variable MILLAR
	    
E_UNIDADES ; Etiqueta para las unidades
	    CALL 				RETARDO_400ms 						; Llama a la subrutina RETARDO
	    INCF 				UNIDAD, 1 								; UNIDAD = UNIDAD+1
	    MOVF 				UNIDAD, 0 								; W <- UNIDAD
	    SUBLW 0X09 								; W <- 0X09 (00001001)-W
	    BTFSS 				STATUS, Z 								; Comprueba si la bandera Z = 1
	    GOTO 				E_UNIDADES							; Si es 0 se repite
	    GOTO 				E_DECENAS 							; Si es 1 se va a E_DECENAS
	    
E_DECENAS ; Etiqueta para las decenas
	    CLRF 				UNIDAD 								; Pone en 0's la variable UNIDAD
	    INCF 				DECENA, 1 								; DECENA = DECENA+1
	    MOVF 				DECENA, 0 								; W <- DECENA
	    SUBLW 			0X06 								; W <- 0x06 (00000110)-W
	    BTFSS 				STATUS, Z 								; Comprueba si la bandera Z = 1
	    GOTO 				E_UNIDADES							; Si es 0 se repite el ciclo a E_UNIDADES
	    GOTO	 			E_CENTENAS							; Si es 1 se va a E_CENTENAS
	    
E_CENTENAS ; Etiqueta para las centenas
	    CLRF 				UNIDAD 								; Pone en 0's la variable UNIDAD
	    CLRF 				DECENA 								; Pone en 0's la variable DECENA
	    INCF 				CENTENA, 1 								; CENTENA = CENTENA+1
	    MOVF 				CENTENA, 0 							; W <- CENTENA
	    SUBLW 			0X09 								; W <- 0X09 (00001001)-W
	    BTFSS 				STATUS, Z 								; Comprueba si la bandera Z = 1
	    GOTO 				E_UNIDADES							; Si es 0 se repite el ciclo a E_UNIDADES
	    GOTO 				E_MILLARES 							; Si es 1 se va a E_MILLARES
	    
E_MILLARES ; Etiqueta para los millares
	    CLRF 				UNIDAD								; Poner en 0's la variable UNIDAD
	    CLRF 				DECENA 								; Poner en 0's la variable DECENA
	    CLRF 				CENTENA	 							; Poner en 0's la variable CENTENA
	    INCF 				MILLAR, 1 								; MILLAR = MILLAR+1
	    MOVF 				MILLAR, 0 								; W <- MILLAR
	    SUBLW 			0X06 								; W <- OXO6 (00000110)-W
	    BTFSS 				STATUS, Z 								; Comprueba si la bandera Z = 1
	    GOTO 				E_UNIDADES							; Si es 0 se repite el cicli a E_UNIDADES
	    GOTO 				INICIO 								; Si es 1 se va a INICIO
	    

INTERRUPCION:
	MOVWF 				W_RES								 ; W_RES = WS
	SWAPF 				STATUS, W	 							 ; W = SWAP (STATUS)
	MOVWF 				STAT_RES 								 ; STAT_RES = W
    	MOVF 				CONT, 0 								 ; W <- CONT
	SUBLW 				0X04 								; Resta 4 a W
	BTFSS 				STATUS, Z 							; Testea la bandera Z
	GOTO 				CICLO
	CLRF 				CONT	 							; Salto en caso de que el bit testeado es igual a 1
	CLRF 				PTA 									; Limpia la variable PTA
	BSF 					PTA, 0 								; Pone el bit 0 de la variable PTA en 0		


	TABLA ; Tabla del 0 al 9 en hexadecimal
	    ADDWF PCL,1 ; Suma PCL <- W+PCL
	    RETLW B'11000000' ; 0
	    RETLW B'11111001' ; 1
	    RETLW B'10100100' ; 2
	    RETLW B'10110000' ; 3
	    RETLW B'10011001' ; 4
	    RETLW B'10010010' ; 5
	    RETLW B'10000010' ; 6
	    RETLW B'10111000' ; 7
	    RETLW B'10000000' ; 8
	    RETLW B'10011000' ; 9


	TABLA2 ; Tabla del 0 al 9 en hexadecimal
	    ADDWF PCL,1 ; Suma PCL <- W+PCL
	    RETLW B'11000000' ; 0
	    RETLW B'11111001' ; 1
	    RETLW B'10100100' ; 2
	    RETLW B'10110000' ; 3
	    RETLW B'10011001' ; 4
	    RETLW B'10010010' ; 5
	    RETLW B'10000010' ; 6

	    
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