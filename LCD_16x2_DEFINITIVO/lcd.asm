
	list		p=16f887	; list directive to define processor
	#include	<p16f887.inc>	; processor specific variable definitions


	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

CounterA equ 0x30
CounterB equ 0x31

	CBLOCK	0X20
		Contador
	ENDC

	ORG	    0x00
   	 GOTO    				C_PUERTOS
    
C_PUERTOS
	CLRF				PORTB			; Puerto B Como Salida
	CLRF				PORTC			; Puerto A como Entrada y Salida
	BSF					STATUS, RP0		; RP0 = Registro Status
	BCF					STATUS, RP1		; RP1 = Registro Status
	CLRF				TRISC			; Limpiar PORTA (Poner en 0's)
	CLRF				TRISB			; Limpiar PORTB (Poner en 0's)
	BCF					STATUS, RP0		; RP0 = Registro Status

INICIO
	CLRF				Contador			; LIMPIRAR EL CONTADOR
    	CALL   	 			CONF_LCD		; SE VA A CONFIGURACION DEL LCD
    	CALL  	 			MEN_LINEA_1		; CONF MENSAJE 1
    	CALL  				LINEA2			; ETIQUETA LINEA2
	CLRF				Contador			;LIMPRIAR EL CONTADOR
    	CALL   	 			MEN_LINEA_2		; CONF MENSAJE 2
    	GOTO    				INICIO			; INICIO

MEN_LINEA_1
	MOVF 				Contador,W		; Contador = W
	CALL				TABLA1			; TABLA DE LA PRIMER LINEA
	MOVWF				PORTB			; MUESTRA EN EL PUERTO B
	CALL    				ENVIAR_DATO	; ENVIAR LOS DATOS
	INCF				Contador, F		; Contador = Contador+1
	MOVLW				B'00001010'		; ES EL TAMAÑO TOTAL DE LA CADENA DEL MENSAJE 2
	XORWF				Contador,W		; XOR  ENTRE Contador y W
	BTFSS				STATUS,Z		; Z = 1?
	GOTO				MEN_LINEA_1    	; NO
    	RETURN								; SI

MEN_LINEA_2
	MOVF 				Contador,W		; Contador = W
	CALL				TABLA2			; TABLA DE LA SEGUNDA LINEA
	MOVWF				PORTB			; MUESTRA EN EL PUERTO B
	CALL    				ENVIAR_DATO	; ENVIAR LOS DATOS
	INCF				Contador, F		; Contador = Contador+1
	MOVLW				B'00001000'		; ES EL TAMAÑO TOTAL DE LA CADENA DEL MENSAJE 2
	XORWF				Contador,W		; XOR ENTRE Contador y W
	BTFSS				STATUS,Z		; Z = 1?
	GOTO				MEN_LINEA_2   	; NO
    	RETURN								; SI

TABLA1
	ADDWF 				PCL,1
	DT "HOLA "
	DT "MUNDO"

TABLA2
	ADDWF 				PCL,1
	DT "ICO "
	DT "2021"

CONF_LCD
        BCF 					PORTC,0     		; RS=0 MODO INSTRUCCION
        MOVLW 				0x01         			; LIMPIA PANTALLA 	
        MOVWF 				PORTB			; MUESTRA EN PUERTO B
        CALL 				ENABLE_LCD     	; DA DE ALTA EL COMANDO
        MOVLW 				0x0C       			; SELECCIÓN DE LA PRIMER LINEA
        MOVWF 				PORTB			; SE MUESTRA EN EL PUERTO B
        CALL 				ENABLE_LCD     	; DA DE ALTA EL COMANDO
        MOVLW 				0x3C       			; CONFIGUACION DEL CURSOS
        MOVWF 				PORTB			; MUESTRA EN EL PUERTO B
        CALL 				ENABLE_LCD     	; DA DE ALTA EL COMANDO
        BSF 					PORTC, 0     		; Rs=1 MODO DATO
        RETURN								


ENABLE_LCD
        BSF 					PORTC,1       		; ENABLE EN 1
        CALL 				RETARDO   		; RUTINA DE RETARDO
        CALL 				RETARDO		;RUTINA DE RETARDO	
        BCF 					PORTC, 1   	 	; ENABLE=0    
        CALL 				RETARDO		;RUTINA DE RETARDO	
        RETURN     


ENVIAR_DATO
        BSF 					PORTC,0     		; RS=1 MODO DATO
        CALL 				ENABLE_LCD    	; DA DE ALTA EL COMANDO
        RETURN

LINEA2
        BCF 					PORTC, 0   		 ; RS=0 MODO INSTRUCCION
        MOVLW 				0xC0      			 ; SELECCIÓN LINEA DOS DE LCD
        MOVWF 				PORTB			; MUESTRA EN PUERTO B
        CALL					ENABLE_LCD  		; DA DE ALTA EL COMANDO
        RETURN


RETARDO 								; 300 ms
        movlw 	.255
        movwf 	CounterB 
ciclo
        movlw 	.255
        movwf 	CounterA
ciclo2
        decfsz	CounterA,1
        goto 	ciclo2
        decfsz 	CounterB,1
        goto 	ciclo
	RETURN
	END                       ; directive 'end of program'

