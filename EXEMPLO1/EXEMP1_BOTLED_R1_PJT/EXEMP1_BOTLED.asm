

; 									BOT E LED EXE1
;									DESBRAVANDO O PIC

;							DESCRICAO DO PROJETO
;;SISTEMA SIMPLES PARA REPRESENTAR O ESTADO DE UM BOTAO POR MEIO DE UM LED


;							===================================
;					 				ARQUIVOS DE DEFINICAO 
;							

	#INCLUDE <P16F628.INC> ; BIBLIOTECA A SER USADA PELO CONTROLADOR.

	__CONFIG _BOREN_ON & _CP_OFF & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _MCLRE_ON & _XT_OSC




;							======================================
;									PAGINACAO DE MEMORIA
;							
;			DEFINICAO DE COMANDOS USUARIOS PARA ALTERACAO DA PAGINA DE MEMORIA

	#DEFINE				BANK0	BCF	STATUS,RP0; SETA BANK 0 DE MEMORIA
	#DEFINE				BANK1	BSF STATUS,RP0; SETA BANK 1 DE MEMORIA




;         			==================================================================
;						DEMARCACAO DO BLOCO DE MEMORIAS PARA CRIACAO DAS VARIAVEIS
;					

	CBLOCK 0X20 ; INICIO DO BLOCO DE MEMORIA 

	ENDC		;FIM DO BLOCO DE MEMORIA


;					=====================================================
;								AS FLAGS PARA USO DO SISTEMA
;					



;					====================================================
;							AS CONSTANTES DE USO GERAL
;					


;					========================================================
;							DEFINICAO DAS ENTRADAS- PINOS DE ENTRADA
;

	#DEFINE		BOTAO	PORTA,2 ;PORTA DO BOTAO 
							;0-PRESSIONADO
							;1-LIBERADO


;					========================================================
;							DEFINICAO DAS SAIDAS- PINOS DE SAIDA

	#DEFINE		LED		PORTB,6 ; PORTA DO LED
							;0-APAGADO
							;1-ACESO


;					==================================================
;							VETOR DE RESET


	ORG		0X00
	GOTO	INICIO


;					=================================================
;						INICIO DA INTERRUPCAO

	ORG		0X04
	RETFIE


;================================================================================================
;							CORPO DO PROGRAMA PRINCIPAL


INICIO

	CLRF	PORTA
	CLRF	PORTB

	BANK1
	MOVLW	B'00000100'
	MOVWF	TRISA
	
	
	MOVLW	B'00000000'
	MOVWF	TRISB

	MOVLW	B'10000000'
	MOVWF	OPTION_REG

	MOVLW	B'00000000'
	MOVWF	INTCON
	
	BANK0
	MOVLW	B'00000111'
	MOVWF	CMCON


MAIN

	BTFSC	BOTAO
	GOTO	BOTAO_LIB
	GOTO	BOTAO_PRES
	
	

BOTAO_LIB
	BSF	LED; 		;PARA RESOLVER A QUESTAO 1, BASTA INVERTER AQUI BSF PARA BCF.
	GOTO MAIN		
					
BOTAO_PRES		
	
	BCF	LED 		;PARA RESOLVER A QUESTAO 1, BASTA INVERTER AQUI BCF PARA BSF.
	GOTO MAIN

	END


				







