.include "m328pdef.inc"
.list
.def tmp = r16
.cseg
.org 0x0000

#define CLOCK 16.0e6 ;clock speed
#define TIMES_PER_SEC 60
#define DELAY 1/TIMES_PER_SEC ;seconds
;#define DELAY 1 ; seconds

.equ PRESCALE = 0b100 ;/256 prescale8
.equ PRESCALE_DIV = 256
.equ TOP = int((CLOCK/PRESCALE_DIV)*DELAY - 1)
.if TOP > 65535
.error "TOP is out of range"
.endif

rjmp RESET

; Vetor de interrupção para Timer1 Compare A
.org OC1Aaddr
rjmp TIM1_COMPA

RESET:
	cli

	; PB5 saída (LED)
	ldi tmp, (1<<DDB5)	
	out DDRB, tmp
	ldi tmp, 0x00
	out PORTB, tmp

	; Timer1: CTC, prescaler = 256
	ldi tmp, 0x00
	sts TCCR1A, tmp
	ldi tmp, (1<<WGM12) | (1<<CS12)
	sts TCCR1B, tmp

	; OCR1A = 62499 (0xF423) para 1s
	ldi tmp, high(TOP)
	sts OCR1AH, tmp
	ldi tmp, low(TOP)
	sts OCR1AL, tmp


	; habilita interrupção Compare A
	lds r16, TIMSK1
	ori r16, 1 <<OCIE1A
	sts TIMSK1, r16

	sei

loop:
	rjmp loop

; ISR: Timer1 Compare A Match
TIM1_COMPA:
	push r16
	push r17
	in r16, SREG
	push r16

	in r16, PORTB
	ldi r17, (1<<PORTB5)
	eor r16, r17
	out PORTB, r16

	pop r16
	out SREG, r16
	pop r17
	pop r16
	reti