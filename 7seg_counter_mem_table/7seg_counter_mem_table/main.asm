.cseg 
.org 0 

.equ ClockMHz = 16
.equ DelayMs = 1000

; Define a tabela com valores de 0 a 15 para o display de 7 segmentos
Tabela_7seg:
    .db 0x7E, 0x30 ; 0 e 1
    .db 0x6D, 0x79 ; 2 e 3
    .db 0x33, 0x5B ; 4 e 5
    .db 0x5F, 0x70 ; 6 e 7
    .db 0x7F, 0x7B ; 8 e 9
    .db 0x77, 0x1F ; A e B
    .db 0x4E, 0x3D ; C e D
    .db 0x4F, 0x47 ; E e F

rjmp RESET 

RESET: 
    ldi r16, 0b11111111 
    out DDRB, r16
    ldi r16, 0 ; Inicia o valor do índice da tabela em 0

loop:
    ; Acesso a um elemento da tabela via registrador Z (R30/R31)
    ldi ZH, high(Tabela_7seg * 2)
    ldi ZL, low(Tabela_7seg * 2)    
    add ZL, r16 ; Adiciona o offset ao Z
    lpm r17, Z ; Carrega o valor da Flash em r17

    out PORTB, r17
    rcall delay1000ms

    inc r16  ; Incrementa o índice da tabela
    
    ; Verifica se r16 > 15 (0-15 são 16 valores)
    cpi r16, 16
    brlo loop ; Se menor que 16, continua no loop
    
    ; Se chegou a 16, reseta para 0
    ldi r16, 0
    rjmp loop

; --- Sub-rotina de delay (1000ms) ---
delay1000ms:
    ldi r22, byte3(ClockMHz * 1000 * DelayMs / 5)
    ldi r21, high(ClockMHz * 1000 * DelayMs / 5)
    ldi r20, low(ClockMHz * 1000 * DelayMs / 5)

delay_loop:
    subi r20, 1
    sbci r21, 0
    sbci r22, 0
    brcc delay_loop
    ret