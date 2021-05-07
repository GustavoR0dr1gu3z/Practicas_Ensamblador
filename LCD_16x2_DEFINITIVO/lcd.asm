
	list		p=16f887	; list directive to define processor
	#include	<p16f887.inc>	; processor specific variable definitions


	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V


	CBLOCK	0X20
		Contador, val1, val2
	ENDC

	ORG	    0x00
   	 GOTO    				C_PUERTOS
    
C_PUERTOS
	BSF 					STATUS, RP0		; RP0 = Registro 1 de status
	MOVLW				0X00			; 00000000
	MOVWF				TRISB			; Puerto B Como Salida
	MOVLW				0X00			; 00000000
	MOVWF				TRISA			; Puerto A como Entrada y Salida
	BCF					STATUS, RP0		; RP0 = Registro Status
	CLRF				PORTA			; Limpiar PORTA (Poner en 0's)
	CLRF				PORTB			; Limpiar PORTB (Poner en 0's)

INICIO:
	CLRF				Contador			; LIMPIRAR EL CONTADOR
    	CALL   	 			CONF_LCD		; SE VA A CONFIGURACION DEL LCD
    	CALL  	 			MEN_LINEA_1		; CONF MENSAJE 1
    	CALL  				LINEA2			; ETIQUETA LINEA2
	CLRF				Contador			;LIMPRIAR EL CONTADOR
    	CALL   	 			MEN_LINEA_2		; CONF MENSAJE 2
    	GOTO    				INICIO			; INICIO

MEN_LINEA_1:
	MOVF 				Contador,W		; Contador = W
	CALL				TABLA1			; TABLA DE LA PRIMER LINEA
	MOVWF				PORTB			; MUESTRA EN EL PUERTO B
	CALL    				ENVIAR_DATO		
	INCF				Contador, F		; Contador = Contador+1
	MOVLW				B'00001010'		;ES EL TAMAÑO TOTAL DE LA CADENA DEL MENSAJE 2
	XORWF				Contador,W		; XOR  ENTRE Contador y W
	BTFSS				STATUS,Z		; Z = 1?
	GOTO				MEN_LINEA_1    	; NO
    	RETURN								; SI

MEN_LINEA_2:
	MOVF 				Contador,W		; Contador = W
	CALL				TABLA2			; TABLA DE LA SEGUNDA LINEA
	MOVWF				PORTB			; MUESTRA EN EL PUERTO B
	CALL    				ENVIAR_DATO
	INCF				Contador, F		; Contador = Contador+1
	MOVLW				B'00001000'		;ES EL TAMAÑO TOTAL DE LA CADENA DEL MENSAJE 2
	XORWF				Contador,W		; XOR ENTRE Contador y W
	BTFSS				STATUS,Z		; Z = 1?
	GOTO				MEN_LINEA_2   	; NO
    	RETURN								; SI

TABLA1:
	ADDWF 				PCL,1
	DT					"HOLA "
	DT					"MUNDO"

TABLA2:
	ADDWF 				PCL,1
	DT					"ICO "
	DT					"2021"

CONF_LCD:
        BCF 					PORTC,0     		; RS=0 MODO INSTRUCCION
        MOVLW 				0x01         			; LIMPIA PANTALLA 	
        MOVWF 				PORTB			; MUESTRA EN PUERTO B
        CALL 				LCD_Comando     							; Se da de alta el comando
        MOVLW 				0x0C       			; SELECCIÓN DE LA PRIMER LINEA
        MOVWF 				PORTB			; SE MUESTRA EN EL PUERTO B
        CALL 				LCD_Comando     	
        MOVLW 				0x3C       			; CONFIGUACION DEL CURSOS
        MOVWF 				PORTB
        CALL 				LCD_Comando     	
        BSF 					PORTC, 0     		; Rs=1 MODO DATO
        RETURN								


LCD_Comando
        BSF 					PORTC,1       		; ENABLE EN 1
        CALL 				DELAY      						; Tiempo de espera
        CALL 				DELAY			
        BCF 					PORTC, 1   		 ; ENABLE=0    
        CALL 				DELAY			
        RETURN     


ENVIAR_DATO
        BSF 					PORTC,0     		; RS=1 MODO DATO
        CALL 				LCD_Comando    	
        RETURN

LINEA2:
        BCF 					PORTC, 0   		 ; RS=0 MODO INSTRUCCION
        MOVLW 				0xC0      			 ; SELECCIÓN LINEA DOS DE LCD
        MOVWF 				PORTB			; MUESTRA EN PUERTO B
        CALL					LCD_Comando    	
        RETURN


DELAY           
        movlw 	.255
        movwf 	val2 
ciclo
        movlw 	.255
        movwf 	val1
ciclo2
        decfsz	val1,1
        goto 	ciclo2
        decfsz 	val2,1
        goto 	ciclo
        return

	END                       ; directive 'end of program'

