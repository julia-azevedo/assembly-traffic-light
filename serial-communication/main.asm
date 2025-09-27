; código de envio para o arduino o status dos semáforos através da Serial


.include "m328def.inc"

; velocidade clock 16MHz, 9600bps 
; UBRRn = 16*10^6 / 16 * 9600 - 1
; UBRRn = 103.1666 = 103

.equ UBRRVAL = 103

.def current_state_ser = r4 ; armazenar Estado Atual (0-9)
.def serial_temp = r2 
.def serial_temp2 = r3
.def current_state_ser = r4 ; estado atual (backup)
.def time_remaining_ser = r7 ; tempo restante (backup)

.cseg

; vetor de interrupção USART RX
.org URX0addr
	reti

; definicao de strings constantes

semaforo1: .db "S1:",0
semaforo2: .db " S2:",0  
semaforo3: .db " S3:",0
semaforo4: .db " S4:",0
timer_str: .db " Timer:",0
segundos: .db "s",0
vermelho: .db "VERMELHO",0
verde: .db "VERDE",0
amarelo: .db "AMARELO",0
nova_linha: .db 13,10,0

; ==========================
; INICIALIZAÇÃO DA SERIAL 
;===========================

usart_init:
	push serial_temp

	;config do baud rate (taxa de transmissao de bits/s)
	ldi serial_temp, high(UBRRVAL)
	sts UBRR0H, serial_temp
	ldi serial_temp, low(UBRRVAL)
	sts UBRR0L, serial_temp

	;config do formato do frame
	ldi serial_temp, (1 << UCSZ01) | (1 << UCSZ00)
	sts UCSR0C, serial_temp

	;habilitar transmissão TX
	ldi serial_temp, (1 << TXEN0)
	sts UCSR0B, serial_temp

	pop serial_temp
	ret

; ==================================
;  TRANSMISSÃO DE CARACTERE
;==================================

usart_transmit:
	push serial_temp
	push serial_temp2

usart_transmit_wait:
	lds serial_temp, UCSR0A
	sbrs serial_temp, UDRE0
	rjmp usart_transmit_wait

	sts UDR0, r24

	pop serial_temp2
	pop serial_temp
	ret

; ==================================
;  TRANSMISSÃO DE STRING
;==================================

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

; ==================================
;  TRANSMISSÃO DE número (0-99)
;==================================

usart_print_number:
	push serial_temp
	push serial_temp2
	push r24

	mov serial_temp, r24 ; salva o número

	; Dezenas
	ldi serial_temp2, '0'


usart_print_tens:

	cpi serial_temp, 10
	brlo usart_print_units
	subi serial_temp, 10
	inc serial_temp2
	rjmp usart_print_tens

; impressao das dezenas
mov r24, serial_temp2
rcall usart_transmit


usart_print_units:
	 
	 mov r24, serial_temp
	 subi r24, -'0'
	 rcall usart_transmit

	 pop r24
	 pop serial_temp2
	 pop serial_temp
	 ret

; ==================================
;  DETERMINAR COR DO SEMÁFORO
;==================================

get_semaforo_color:
	push serial_temp
	push serial_temp2

; Cálculo do índice: estado * 4 + (semaforo - 1)

	mov serial_temp, current_state_ser
	lsl serial_temp ; x2
	lsl serial_temp ; x4
	mov serial_temp2, r24
	dec serial_temp2 ; semaforo - 1
	add serial_temp, serial_temp2

	; Ler da tabela de cores

	ldi ZL, low(color_table*2)
	ldi ZH, high(color_table*2)
	add ZL, serial_temp
	adc ZH, r1

	lpm serial_temp, Z ; indice da cor (0, 1 ou 2)
	; Apontar para string correspondente
	ldi ZL, low(color_strings*2)
	ldi ZH, high(color_strings*2)

	; Cada string terá tamanho fixo (11 bytes)
	ldi serial_temp2, 11
	mul serial_temp, serial_temp2
	add ZL, r0
	adc ZH, r1

	pop serial_temp2
	pop serial_temp
	ret

; Tabela de mapeamento (10 estados x 4 semáforos)

color_table:
; Est 0: S1-Verm(0), S2-Verde(1), S3-Verm(0), S4-Verde(1)
.db 0, 1, 0, 1

; Est 1: S1-Verm, S2-Verde, S3-Verm, S4-Amarelo(2)  
.db 0, 1, 0, 2

; Est 2: S1-Verm, S2-Verde, S3-Verm, S4-Verm
.db 0, 1, 0, 0

; Est 3: S1-Verm, S2-Amarelo, S3-Verm, S4-Verm
.db 0, 2, 0, 0

; Est 4: S1-Verm, S2-Verm, S3-Verm, S4-Verm
.db 0, 0, 0, 0

; Est 5: S1-Verm, S2-Verm, S3-Verde, S4-Verm
.db 0, 0, 1, 0

; Est 6: S1-Verde, S2-Verm, S3-Verde, S4-Verm
.db 1, 0, 1, 0

; Est 7: S1-Amarelo, S2-Verm, S3-Verde, S4-Verm
.db 2, 0, 1, 0

; Est 8: S1-Amarelo, S2-Verm, S3-Amarelo, S4-Verm
.db 2, 0, 2, 0

; Est 9: S1-Verm, S2-Verde, S3-Amarelo, S4-Verm
.db 0, 1, 2, 0

color_strings:
	.db "VERMELHO", 0,0,0 ; 11 bytes
	.db "VERDE", 0,0,0,0,0,0 
	.db "AMARELO", 0,0,0,0

; =============================================
; ENVIAR STATUS COMPLETO
; =============================================

send_semaforos_status:
	push r24
	push r30
	push r31

	; semaforo 1
	ldi ZL, low(semaforo1*2)
	ldi ZH, high(semaforo1*2)
	rcall usart_print_string
	ldi r24, 1
	rcall get_semaforo_color
	rcall usart_print_string

	; semaforo 2
    ldi ZL, low(semaforo2*2)
    ldi ZH, high(semaforo2*2)
    rcall usart_print_string
    ldi r24, 2
    rcall get_semaforo_color
    rcall usart_print_string

	; semaforo 3
    ldi ZL, low(semaforo3*2)
    ldi ZH, high(semaforo3*2)
    rcall usart_print_string
    ldi r24, 3
    rcall get_semaforo_color
    rcall usart_print_string
    
    ; semaforo 4
    ldi ZL, low(semaforo4*2)
    ldi ZH, high(semaforo4*2)
    rcall usart_print_string
    ldi r24, 4
    rcall get_semaforo_color
    rcall usart_print_string

	; Timer
    ldi ZL, low(timer_str*2)
    ldi ZH, high(timer_str*2)
    rcall usart_print_string
    mov r24, time_remaining_ser
    rcall usart_print_number
    ldi ZL, low(segundos*2)
    ldi ZH, high(segundos*2)
    rcall usart_print_string
    
    ; Nova linha
    ldi ZL, low(nova_linha*2)
    ldi ZH, high(nova_linha*2)
    rcall usart_print_string
    
    pop r31
    pop r30
    pop r24
    ret

; =============================================
; ATUALIZAR STATUS/ entrada: r24 = novo estado, r22 = tempo restante
; =============================================


serial_update_status:
	mov current_state_ser, r24
	mov time_remaining_ser, r22

	; Preservar registradores críticos
	push r16
    push r17
    push r18
    push r19
    push r20
    push r21
    push r22
    push r23
    push r24
    push r25
    push r30
    push r31
	
	rcall send_semaforos_status

    ; Restaurar registradores
    pop r31
    pop r30
    pop r25
    pop r24
    pop r23
    pop r22
    pop r21
    pop r20
    pop r19
    pop r18
    pop r17
    pop r16
    
    ret
