
	list		p=16f887	; list directive to define processor
	#include	<p16f887.inc>	; processor specific variable definitions


; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.

	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V



;***** VARIABLE DEFINITIONS
	

;**********************************************************************
	val1 	equ 0x30
	val2 	equ 0x31 

	CBLOCK	0X20
		COUNT
	ENDC

	ORG	    0
    GOTO    CONFIGURA_PTOS
    
CONFIGURA_PTOS
    CLRF    PORTB
    CLRF    PORTC	;LIMPIAR PORTB Y PORTC
    BSF	    STATUS,RP0
    BCF	    STATUS,RP1
    CLRF    TRISB
    CLRF    TRISC	;SELECIONAR PORTB Y PORTC COMO SALIDAS
    BCF	    STATUS,RP0 

INICIO
	CLRF	COUNT			;LIMPIRAR EL CONTADOR
    CALL    LCD_Inicializa
    CALL    MENSAJE_1
    CALL    LCD_Linea2
	CLRF	COUNT			;LIMPRIAR EL CONTADOR
    CALL    MENSAJE_2
    GOTO    INICIO

MENSAJE_1
	MOVF 	COUNT,W
	CALL	TABLA_1
	MOVWF	PORTB
	CALL    LCD_Envia
	INCF	COUNT, F
	MOVLW	B'00001010'	;ES EL TAMAÑO TOTAL DE LA CADENA DEL MENSAJE 2
	XORWF	COUNT,W
	BTFSS	STATUS,Z
	GOTO	MENSAJE_1    
    RETURN

MENSAJE_2
	MOVF 	COUNT,W
	CALL	TABLA_2
	MOVWF	PORTB
	CALL    LCD_Envia
	INCF	COUNT, F
	MOVLW	B'00001000'	;ES EL TAMAÑO TOTAL DE LA CADENA DEL MENSAJE 2
	XORWF	COUNT,W
	BTFSS	STATUS,Z
	GOTO	MENSAJE_2    
    RETURN


TABLA_1
	ADDWF 	PCL,1
	DT	"HOLA "
	DT	"MUNDO"

TABLA_2
	ADDWF 	PCL,1
	DT	"ICO "
	DT	"2021"

LCD_Inicializa
        BCF 	PORTC,0      ; RS=0 MODO INSTRUCCION
        MOVLW 	0x01         ; El comando 0x01 limpia la pantalla en el LCD
        MOVWF 	PORTB
        CALL 	LCD_Comando     ; Se da de alta el comando
        MOVLW 	0x0C       ; Selecciona la primera línea
        MOVWF 	PORTB
        CALL 	LCD_Comando     ; Se da de alta el comando
        MOVLW 	0x3C       ; Se configura el cursor
        MOVWF 	PORTB
        CALL 	LCD_Comando     ; Se da de alta el comando
        BSF 	PORTC, 0     ; Rs=1 MODO DATO
        RETURN
;Subrutina para enviar comandos
LCD_Comando
        BSF 	PORTC,1        ; Pone la ENABLE en 1
        CALL 	DELAY      ; Tiempo de espera
        CALL 	DELAY
        BCF 	PORTC, 1    ; ENABLE=0    
        CALL 	DELAY
        RETURN     
;Subrutina para enviar un dato
LCD_Envia
        BSF 	PORTC,0     ; RS=1 MODO DATO
        CALL 	LCD_Comando    ; Se da de alta el comando
        RETURN
;Configuración Lineal 2 LCD
LCD_Linea2
        BCF 	PORTC, 0    ; RS=0 MODO INSTRUCCION
        MOVLW 	0xC0        ; Selecciona linea 2 pantalla en el LCD
        MOVWF 	PORTB
        CALL	LCD_Comando    ; Se da de alta el comando
        RETURN
; Subrutina de retardo
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

