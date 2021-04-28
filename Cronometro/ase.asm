	list		p=16f887	; list directive to define processor
	#include	<p16f887.inc>	; processor specific variable definitions

	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V


	CBLOCK 0X20 ; Dirección de memoria para las variables
	CounterA, CounterB, CounterC
	W_RES, STATUS_RES
	CONT, PTA
	ENDC ; Fin de bloque de librerías

	CBLOCK 0X30
	UNIDAD, DECENA, CENTENA, MILLAR ;Variables para el display
	inve, inve2
	ENDC

	ORG 0x00													 ; posición 0
	GOTO 				PUERTOS 											; Comienzo del programa
	ORG 0X04													; DIreccion de la interrupcion
	GOTO 				INTERRUPCION	

PUERTOS
	CLRW													; Limpiar W
	BSF 					STATUS, RP0							; RP0 = REGISTRO 1 DE STATUS
	MOVLW 				0X00	
	MOVWF				TRISB								; PUERTO B, SALIDA
	MOVLW				0XF0
	MOVWF				TRISA								; PUERTO A: ENTRADA Y SALIDA

	BCF 					STATUS, RP0							; RP0 = 0 REGISTRO STATIS
	CLRF					PORTA								; LIMPIAR PORTA
	CLRF 				PORTB								; LIMPIAR PORTB
	BSF 					PTA, 0								; PONER EN 1's EL BIT 0 PTA

CONFI_TMR0
	MOVLW				b'10100000'							; CONFIGURAR VALORES DEL TMR0

INTCONN
	MOVWF				INTCON								; Asignación de valores a las banderas del registro
	BSF					STATUS, RP0
	MOVLW				b'10000001'							;Asignacion de valores a las banderas del registro

OPTION_REGG
	MOVWF				OPTION_REG							; COnfiguracion del option_reg
	BCF					STATUS, RP0
	MOVLW				0X00
	MOVWF				CONT								; INICIALIZACION DE LA VARIABLE CONT

INICIO
	MOVLW 				0X00	
	MOVWF				UNIDAD								; Poner en ceros
	MOVLW 				0X00
	MOVWF				DECENA								; Poner en ceros
	MOVLW 				0X00
	MOVWF				CENTENA								; Poner en ceros
	MOVLW 				0X00
	MOVWF				MILLAR								; Poner en ceros

E_UNIDADES
	CALL 				RETARDO								; Manda a llamar retardo (300ms)
	INCF					UNIDAD, 1							; Incrementa la variable
	MOVF				UNIDAD, 0							; W = UNIDAD
	SUBLW				.10									; RESTA 10 A W
	BTFSS				STATUS, Z							; Verifica si es 1
	GOTO				E_UNIDADES							; No
	GOTO 				E_DECENAS							; Si

E_DECENAS
;	MOVLW 	0XFF
;	MOVWF 	UNIDAD
	CLRF					UNIDAD								; Pone en ceros
	INCF					DECENA, 1							; Incrementa la variabla
	MOVF				DECENA, 0							; W = DECENA
	SUBLW				.6									; RESTA 6 A W
	BTFSS				STATUS, Z							; Verifica si es 1
	GOTO 				E_UNIDADES							; No
	GOTO				E_CENTENAS							; Si

E_CENTENAS
	CLRF					UNIDAD								; Pone en ceros
	CLRF					DECENA								; Pone en ceros
;	MOVLW 	0XFF
;	MOVWF 	UNIDAD
;	MOVLW 	0XFF
;	MOVWF 	DECENA
	INCF 				CENTENA, 1							; Incrementa la variable
	MOVF				CENTENA, 0							; W = CENTENA
	SUBLW				.10									; Resta 10 a W
	BTFSS				STATUS, Z							; Verifica si es 1
	GOTO				E_UNIDADES							; No
	GOTO 				E_MILLARES							; Si

E_MILLARES
	CLRF					UNIDAD								; Pone en ceros
	CLRF					DECENA								; Pone en ceros
	CLRF					CENTENA								; Pone en ceros
;	MOVLW 	0XFF
;	MOVWF 	UNIDAD
;	MOVLW 	0XFF
;	MOVWF 	DECENA
;	MOVLW 	0XFF
;	MOVWF 	CENTENA
	INCF					MILLAR, 1								; Incrementa la variable
	MOVF				MILLAR, 0								; W = MILLAR
	SUBLW				.6									; Resta 6 a W
	BTFSS				STATUS, Z							; Verifica si es 1
	GOTO 				E_UNIDADES							; No
	GOTO 				INICIO								; Si

INTERRUPCION
	MOVWF 				W_RES								; Mueve  W a W_RES
	SWAPF				STATUS, W							; Intercambia STATUS en WRES
	MOVWF				STATUS_RES							; W = STATUS_RES
	MOVF				CONT, 0								; MUEVE CONT A W
	SUBLW				0X04								; Resta 4 a W
	BTFSS				STATUS, Z							; Verifica si es 1
	GOTO 				CICLO								; No 
	CLRF					CONT								; Si
	;MOVLW 	0XFF
	;MOVWF 	PTA
	CLRF					PTA									; Pone en ceros
	BsF					PTA, 0								; Pone en 1 el bit 0 de PTA

CICLO
	    MOVF				CONT, 0								; Mueve CONT  a W
	    ADDLW			0X30								; Suma 30 a W
	    MOVWF 			FSR 									; FSR <- W
	    MOVF 				INDF, 0 								; W <- INDF
	    CALL 				TABLA								 ; Llama a la subrutina tabla	
	    MOVWF			inve									; Variable para invertir
	    COMF				inve, W								; Hace el complemento de la salida
	    MOVWF 			PORTB 								; PORTB <- W
	    MOVF 				PTA, 0   								; W <- PTA
	   MOVWF				inve2									; Variable para invertir
	    COMF				inve2, W								; Hace el complemento de la salida
	    MOVWF 			PORTA								; PORTA <- W
	    INCF 				CONT, 1 								; CONT = CONT+1
	    RLF 				PTA									; PTA = PTA*2
	    SWAPF 			STATUS_RES, W						; W_RES = SWAP(W_RES)
	    MOVWF 			STATUS 								; W = SWAP(W_RES)
	    SWAPF				W_RES, W_RES						; Intercambia lo de la variable W_RES
	    SWAPF				W_RES, W							; 
	    BCF 				INTCON, T0IF 							; Limpia el bit T0IF del registro INTCON
	    RETFIE 													; Termina la interrupcion


TABLA
	ADDWF		PCL, 1										; Suma PCL = W+PCL
	RETLW		b'01000000'	; 0
	RETLW 		b'01111001'	; 1
	RETLW		b'00100100'	; 2
	RETLW		b'00110000'	; 3
	RETLW		b'00011001'	; 4
	RETLW		b'00010010'	; 5
	RETLW		b'00000010'	; 6
	RETLW 		b'00111000' 	; 7
	RETLW		b'00000000'	; 8
	RETLW		b'00011000'	; 9


RETARDO 													; 300 ms
		movlw	D'2'
		movwf	CounterC
		movlw	D'134'
		movwf	CounterB
		movlw	D'152'
		movwf	CounterA
loop		decfsz	CounterA,1
		goto	loop
		decfsz	CounterB,1
		goto	loop
		decfsz	CounterC,1
		goto	loop
		retlw	 0
		RETURN
	END