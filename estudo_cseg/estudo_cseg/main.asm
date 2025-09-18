; Define a tabela na Flash (memória de programa)
.cseg
.org 0x0000 ; (opcional) Define o endereço inicial

; Define a tabela com valores de 0 a 15 para o display de 7 segmentos
Tabela_7seg:
    .db 0x7E, 0x30 ; 0 e 1
	.db 0x6D, 0x79 ; 2 e 3
	.db 0x33, 0x5B ; etc
	.db 0x5F, 0x70
	.db 0x7F, 0x7B
	.db 0x77, 0x1F
	.db 0x4E, 0x3D
	.db 0x4F, 0x47


ldi r16, 0 ; Inicia o valor do índice da tabela em 0

loop:
	; Acesso a um elemento da tabela via registrador Z (R30/R31)
	; Ajuste para endereçamento de byte: Endereço byte = Endereço word * 2
	ldi ZH, high(Tabela_7seg * 2)
	ldi ZL, low(Tabela_7seg * 2)	
	add ZL, r16 ; Adiciona o offset ao Z. 
	; Ex: Se Z = 0x0200 e r16 = 0x01, ZL = 0x00, então add ZL, r16 -> ZL = 0x01 -> Z = 0x0201
	lpm r17, Z ; Carrega o valor da Flash em r17 (resultado: 0x30 para o índice 1)

	inc r16  ; Incrementa o índice da tabela

	rjmp loop