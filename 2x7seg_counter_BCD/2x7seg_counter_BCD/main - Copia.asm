.cseg 
.org 0 

.equ ClockMHz = 16
.equ DelayMs = 1000

rjmp RESET 

RESET: 
    ldi r16, 0b11111111 
    out DDRB, r16
	out DDRD, r16
    ldi r16, 0 ; Inicia o valor do índice da tabela em 0
	ldi r17, 0b00000011

loop:
    out PORTB, r16
	out PORTD, r17
    rcall delay1000ms

    inc r16  ; Incrementa o índice da tabela
    
    ; Verifica se r16 > 9 (0-9 são 10 valores)
    cpi r16, 10
    brlo loop ; Se menor que 10, continua no loop
    
    ; Se chegou a 10, reseta para 0
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