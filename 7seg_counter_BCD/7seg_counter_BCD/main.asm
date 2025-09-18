.cseg 
.org 0 

.equ ClockMHz = 16
.equ DelayMs = 1

rjmp RESET 

RESET: 
    ldi r16, 0b11111111 
    out DDRB, r16	
    ldi r16, 0 ; Inicia o valor do índice da tabela em 0

loop:
    out PORTB, r16
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