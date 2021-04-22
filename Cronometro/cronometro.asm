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
ENDC ; Fin de bloque de librerías


;**********************************************************************
	ORG     0x000             ; processor reset vector
	    GOTO CONFIGURAR ; Ir a la etiqueta configurar
	
	CONFIGURAR ; Configuración de puertos

	   BSF 				STATUS, RP0 ; RP0=1 del registro STATUS
	   MOVLW 			0X00 ; Cargar el valor a W
	   MOVWF 			TRISB ; Mover lo de W a TRISB
	   MOVLW 			0XF0 ; Cargar el valor a W
	   MOVWF 			TRISA ; Mover lo de W a TRISA
	   BCF 				STATUS, RP0 ; RP0=0 del registro STATUS
	   CLRF 				PORTA ; Limpia PORTA
	   CLRF 				PORTB ; Limpia PORTB
	    
	INICIO ; Inicio del programa principal
	    MOVLW 			0X00 ; Inicialización de la variable UNIDAD
	    MOVWF 			UNIDAD
	    MOVLW 			0X00 ; Inicialización de la variable DECENA
	    MOVWF 			DECENA
	    MOVLW 			0X00
	    MOVWF 			CENTENA ; Inicialización de la variable CENTENA
	    MOVLW 			0X00
	    MOVWF 			MILLAR ; Inicialización de la variable MILLAR
	    
	UNI ; Etiqueta para las unidades
	    CALL RETARDO_400ms ; Llama a la subrutina RETARDO
	    INCF UNIDAD, 1 ; Incrementa la variable UNIDAD en 1
	    MOVF UNIDAD, 0 ; Mueve el valor de UNIDAD a W
	    SUBLW 0X09 ; Le resta el valor de 10 a W
	    CALL TABLA
   	    MOVWF PORTB
	    BTFSS STATUS, Z ; Testea la bandera Z
	    GOTO UNI
	    GOTO DECE ; Salto en caso de que el bit testeado es igual a 1
	    
	DECE ; Etiqueta para las decenas
	    CLRF UNIDAD ; Limpia la variable UNIDAD
	    INCF DECENA, 1 ; Incrementa la variable DECENA en 1
	    MOVF DECENA, 0 ; Mueve el valor de DECENA a W
	    SUBLW 0X06 ; Le resta el valor de 6 a W
	    CALL TABLA2
   	    MOVWF PORTB
	    BTFSS STATUS, Z ; Testea la bandera Z
	    GOTO UNI
	    GOTO CENTE ; Salto en caso de que el bit testeado es igual a 1
	    
	CENTE ; Etiqueta para las centenas
	    CLRF UNIDAD ; Limpia la variable UNIDAD
	    CLRF DECENA ; Limpia la variable DECENA
	    INCF CENTENA, 1 ; Incrementa la variable CENTENA en 1
	    MOVF CENTENA, 0 ; Mueve el valor de CENTENA a W
	    SUBLW 0X09 ; Le resta el valor de 9 a W
	    CALL TABLA
   	    MOVWF PORTB
	    BTFSS STATUS, Z ; Testea la bandera Z
	    GOTO UNI
	    GOTO MILL ; Salto en caso de que el bit testeado es igual a 1
	    
	MILL ; Etiqueta para los millares
	    CLRF UNIDAD ; Limpia la variable UNIDAD
	    CLRF DECENA ; Limpia la variable DECENA
	    CLRF CENTENA ; Limpia la variable CENTENA
	    INCF MILLAR, 1 ; Incrementa la variable MILLAR en 1
	    MOVF MILLAR, 0 ; Mueve el valor de la variable MILLAR a W
	    SUBLW 0X06 ; Le resta el valor de 6 a W
	    CALL TABLA2
   	    MOVWF PORTB
	    BTFSS STATUS, Z ; Testea la bandera Z
	    GOTO UNI
	    GOTO INICIO ; Salto en caso de que el bit testeado es igual a 1
	    

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