
.cseg
.org 0

rjmp RESET

RESET:
	ldi r16, 0b11111111
	out DDRB, r16
	ldi r16, 0b01001111
	out PORTB, r16

	