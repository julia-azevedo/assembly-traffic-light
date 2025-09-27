.include "m328Pdef.inc"

; Código de envio para o Arduino do status dos semáforos via Serial
.equ F_CPU = 16000000
.equ BAUD = 9600
.equ UBRRVAL = ((F_CPU / (16 * BAUD)) - 1)

; Registradores definidos na faixa r16-r31 para compatibilidade
.def current_state_ser = r20
.def time_remaining_ser = r21
.def serial_temp = r18
.def serial_temp2 = r19

; =====================
; SEGMENTO DE CÓDIGO (Flash)
; =====================
.cseg
.org 0x00
rjmp main
.org URXCaddr
reti

; ==========================
; Strings e Tabelas na Flash com alinhamento
; ==========================
semaforo1_str: .db "S1:",0,0 ; Alinhamento adicionado
semaforo2_str: .db " S2:",0,0 ; Alinhamento adicionado
semaforo3_str: .db " S3:",0,0 ; Alinhamento adicionado
semaforo4_str: .db " S4:",0,0 ; Alinhamento adicionado
timer_str: .db " Timer:",0,0 ; Alinhamento adicionado
segundos: .db "s",0,0,0 ; Alinhamento adicionado
nova_linha: .db 13,10,0

vermelho_str: .db "VERMELHO",0,0 ; 8 + 2 = 10 bytes (par)
verde_str: .db "VERDE",0,0,0,0,0 ; 5 + 1 + 4 = 10 bytes (par)
amarelo_str: .db "AMARELO",0,0,0 ; 7 + 1 + 2 = 10 bytes (par)

color_table:
.db 0,1,0,1, 0,1,0,2, 0,1,0,0, 0,2,0,0, 0,0,0,0
.db 0,0,1,0, 1,0,1,0, 2,0,1,0, 2,0,2,0, 0,1,2,0

color_strings:
.dw vermelho_str, verde_str, amarelo_str

; ==========================
; Inicialização da Serial
; ==========================
usart_init:
    push serial_temp
    ldi serial_temp, high(UBRRVAL)
    sts UBRR0H, serial_temp
    ldi serial_temp, low(UBRRVAL)
    sts UBRR0L, serial_temp

    ldi serial_temp, (1<<UCSZ01)|(1<<UCSZ00)
    sts UCSR0C, serial_temp

    ldi serial_temp, (1<<TXEN0)
    sts UCSR0B, serial_temp
    pop serial_temp
    ret

; ==========================
; Transmissão de caractere
; Entrada: r24 contém o caractere a ser transmitido
; ==========================
usart_transmit:
    push r16
usart_transmit_wait:
    lds r16, UCSR0A
    sbrs r16, UDRE0
    rjmp usart_transmit_wait
    sts UDR0, r24
    pop r16
    ret

; ==========================
; Transmissão de string
; Entrada: Z (r30:r31) contém o endereço inicial da string.
; ==========================
usart_print_string:
    push r24
    push r30
    push r31
    usart_print_loop:
        lpm r24, Z+
        cpi r24, 0
        breq usart_print_end
        rcall usart_transmit
        rjmp usart_print_loop
    usart_print_end:
        pop r31
        pop r30
        pop r24
        ret

; ==========================
; Transmissão de número (0-99)
; Entrada: r24 contém o número
; ==========================
usart_print_number:
    push serial_temp
    push serial_temp2
    mov serial_temp, r24
    ldi serial_temp2, '0'
usart_print_tens:
    cpi serial_temp, 10
    brlo usart_print_units
    subi serial_temp, 10
    inc serial_temp2
    rjmp usart_print_tens
usart_print_units:
    mov r24, serial_temp2
    rcall usart_transmit
    mov r24, serial_temp
    subi r24, -'0'
    rcall usart_transmit
    pop serial_temp2
    pop serial_temp
    ret

; ==========================
; Determinar cor do semáforo
; Entrada: r24 = número do semáforo (1-4)
; Saída: Z (r30:r31) contém o endereço da string da cor
; ==========================

get_semaforo_color:
    push r24
    push r25
    push r26
    push r27
    push r30
    push r31

    ; 1. Calcula o offset base na tabela (current_state_ser * 4)
    mov r26, current_state_ser
    lsl r26            ; *2
    lsl r26            ; *4

    ; Adiciona o índice do semáforo (r24 = 1 a 4 → -1 = 0 a 3)
    mov r27, r24
    dec r27
    add r26, r27       ; r26 = offset final

    ; Prepara Z = color_table + offset
    ldi r30, low(color_table)
    ldi r31, high(color_table)
    add r30, r26
    clr r27
    adc r31, r27

    lpm r24, Z         ; r24 = índice da cor (0, 1, 2)

    ; 2. Pega endereço da string da cor via tabela color_strings
    ldi r30, low(color_strings*2)
    ldi r31, high(color_strings*2)
    lsl r24            ; r24 = r24 * 2 (índice de palavra)
    mov r26, r24
    clr r27
    add r30, r26
    adc r31, r27

    ; Lê o ponteiro (endereço da string)
    lpm r24, Z+        ; primeiro byte
    lpm r25, Z         ; segundo byte
    mov r30, r24
    mov r31, r25       ; Z agora aponta para a string

    pop r31
    pop r30
    pop r27
    pop r26
    pop r25
    pop r24
    ret
; ==========================
; Enviar status completo
; ==========================
send_semaforos_status:
    push r24
    push r25
    push r30
    push r31
    
    ; semáforo 1
    ldi r30, low(semaforo1_str)
    ldi r31, high(semaforo1_str)
    rcall usart_print_string
    ldi r24, 1
    rcall get_semaforo_color
    rcall usart_print_string

    ; semáforo 2
    ldi r30, low(semaforo2_str)
    ldi r31, high(semaforo2_str)
    rcall usart_print_string
    ldi r24, 2
    rcall get_semaforo_color
    rcall usart_print_string

    ; semáforo 3
    ldi r30, low(semaforo3_str)
    ldi r31, high(semaforo3_str)
    rcall usart_print_string
    ldi r24, 3
    rcall get_semaforo_color
    rcall usart_print_string

    ; semáforo 4
    ldi r30, low(semaforo4_str)
    ldi r31, high(semaforo4_str)
    rcall usart_print_string
    ldi r24, 4
    rcall get_semaforo_color
    rcall usart_print_string

    ; Timer
    ldi r30, low(timer_str)
    ldi r31, high(timer_str)
    rcall usart_print_string
    mov r24, time_remaining_ser
    rcall usart_print_number
    ldi r30, low(segundos)
    ldi r31, high(segundos)
    rcall usart_print_string
    ldi r30, low(nova_linha)
    ldi r31, high(nova_linha)
    rcall usart_print_string

    pop r31
    pop r30
    pop r25
    pop r24
    ret

; ==========================
; Atualizar status
; ==========================
serial_update_status:
    mov current_state_ser, r24
    mov time_remaining_ser, r22
    rcall send_semaforos_status
    ret

; ==========================
; MAIN (exemplo)
; ==========================
main:
    ; Configura o stack
    ldi r16, high(RAMEND)
    out SPH, r16
    ldi r16, low(RAMEND)
    out SPL, r16

    rcall usart_init
    ldi r24, 0
    ldi r22, 15
    rcall serial_update_status

infinite_loop:
    rjmp infinite_loop