;			CONTADOR SIMPLIFICADO EX2-DESBRAVANDO O PIC.



;============================================================
;SISTEMA SIMPLES PARA INCREMENTAR OU DECREMENTAR AT� UM VALOR
; DETERMINADO POR MIM OU MAX.


			
;				OBJETIVO:

;RESPOSTA EXERCICIO 3: NESTE EXERCICIO FOI IMPLEMENTADO O BOTAO2, ASSIM, 
;O BOTAO1 (RA1) INCREMENTARA O CONTADOR,E O BOTAO2 (RA2) DECREMENTARA O CONTADOR.

;===============================================================

;	ARQUIVOS DE DEFINI��ES

	#INCLUDE<P16F628A.INC>; BIBLIOTECA DE ARQUIVOS DO PIC UTILIZADO EM PROJETO.

		__CONFIG _BOREN_ON & _CP_OFF & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _MCLRE_ON & _XT_OSC

;=========================================================================

;							PAGINA��O DE MEMORIAS

	#DEFINE BANK0 BCF STATUS,RP0; MUDA PARA BANK 0 DA MEMORIA.
	#DEFINE BANK1 BSF STATUS,RP0; MUDA PARA BANK 1 DA MEMORIA. 

;=======================================================================

;			DEFINI��O E NOMES DAS VARIAVEIS A SEREM USADAS PELO SISTEMA.

	CBLOCK	0X20; ENDERE�O INICIAL DA MEMORIA.

		CONTADOR	;ARMAZENA O VALOR DA CONTAGEM
		FLAGS		;ARMAZENA OS FLGS DE CONTROLE
		FILTRO		;FILTRO PARA O FUNCIONAMENTO CORRETO DO BOT�O.
	ENDC			;FINALIZA O BLOCO DE MEMORIA.

;=======================================================================
;				FLGS INTERNOS

	#DEFINE	SENTIDO FLAGS,0 	;SENTIDO DO FLAG.
						;0-SOMANDO
						;1-SUBTRAINDO.

;====================================================================
;				CONSTANTES UTILIZADAS NO SISTEMA

MIN			EQU	.01	;VALOR MINIMO PARA O CONTADOR.
MAX			EQU	.16	;VALOR MAXIMO PARA O CONTADOR.
T_FILTRO	EQU	.256	;FILTRO PARA FUNCIONAMENTO CORRETO DE BOTOES.

;=======================================================================

;			DEFINI��O DAS ENTRADAS 

	#DEFINE		BOTAO1	PORTA,1		;BOTAO SETADO NO BIT 1 DA PORTA.
	#DEFINE		BOTAO2	PORTA,2		;BOTAO SETADO NO BIT 2 DA PORTA.					
							;0-PRESS
							;1-SOLTO

;========================================================================
;			DEFINI��O DAS SAIDAS

;========================================================================

;					VETOR DE RESET

	ORG 0X00		;ENDERE�O INICIAL DE PROCESSAMENTO.
	GOTO INICIO		; PULA PARA O INICIO DO PROGRAMA.


;====================================================================

;				VETOR DE INTERRUP��O

	ORG	0X04	;ENDERE�O DO BANKO DE MEMORIA PARA INTERRUP��O.
	RETFIE		;RETORNA DO ENDERE�O DE INTERRUP��O.

;====================================================================

;			INICIO DO PROGRAMA

INICIO

	BANK1
	MOVLW	B'00000110'; BITS 1 E 2 DA PORTA S�O SETADOS COMO ENTRADA
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

;====================================================================
;		INICIALIZA��O DAS VARIAVEIS

	CLRF	PORTA
	CLRF	PORTB
	MOVLW	MIN
	MOVWF	CONTADOR
					
	MOVWF	PORTB;; LINHA PARA ESCREVER O VALOR DO CONTADOR DIRETO NA SAIDA PORTB.

;						ROTINA PRINCIPAL DO PROGRAMA

MAIN
	MOVLW	T_FILTRO
	MOVWF	FILTRO
	
CHECA_BT1; 				BOTAO CONFIGURADO PARA INCREMENTAR.
	BTFSC	BOTAO1
	GOTO	CHECA_BT2
	DECFSZ	FILTRO,F
	GOTO	CHECA_BT1
	GOTO	SOMA


CHECA_BT2; 				BOTAO2 CONFIGURADO PARA DECREMENTAR.
	BTFSC	BOTAO2
	GOTO 	MAIN
	DECFSZ	FILTRO,F
	GOTO	CHECA_BT2



SUBTRAI
	DECF	CONTADOR,F
	MOVLW	MIN
	SUBWF	CONTADOR,W
	BTFSC	STATUS,C
	
	GOTO	ATUALIZA
	INCF	CONTADOR,F;INCREMENTO DO CONTADOR EM UM, PARA O RESULTADO DA CONTA VOLTAR A SER O VALOR (MIN).
	GOTO	MAIN

SOMA
	INCF	CONTADOR,F
	MOVLW	MAX
	SUBWF	CONTADOR,W
	BTFSS	STATUS,C

	GOTO	ATUALIZA
	DECF	CONTADOR,F;DECREMENTO DO CONTADOR EM UM, PARA O RESULTADO DA CONTA VOLTAR A SER O VALOR (MAX).
	GOTO	CHECA_BT2

	




ATUALIZA

	MOVF	CONTADOR,W
	MOVWF	PORTB
	BTFSS	BOTAO1
	GOTO	$-1
	BTFSS	BOTAO2
	GOTO	$-1
	
	GOTO	MAIN
	
	END
	
	
	


 







