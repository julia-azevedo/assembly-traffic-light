.cseg 
.org 0 

.equ ClockMHz = 16
.equ DelayMs = 500

rjmp RESET 

RESET: 
	ldi r16, 0b11111111 
	out DDRB, r16 

loop:
	; dígito 0
	ldi r16, 0x7E
	out PORTB, r16
	rcall delay1000ms

	; dígito 1
	ldi r16, 0x30
	out PORTB, r16
	rcall delay1000ms

	; dígito 2
	ldi r16, 0x6D
	out PORTB, r16
	rcall delay1000ms

	; dígito 3
	ldi r16, 0x79
	out PORTB, r16
	rcall delay1000ms

	; dígito 4
	ldi r16, 0x33
	out PORTB, r16
	rcall delay1000ms

	; dígito 5
	ldi r16, 0x5B
	out PORTB, r16
	rcall delay1000ms

	; dígito 6
	ldi r16, 0x5F
	out PORTB, r16
	rcall delay1000ms

	; dígito 7
	ldi r16, 0x70
	out PORTB, r16
	rcall delay1000ms

	; dígito 8
	ldi r16, 0x7F
	out PORTB, r16
	rcall delay1000ms

	; dígito 9
	ldi r16, 0x7B
	out PORTB, r16
	rcall delay1000ms

	; dígito 10
	ldi r16, 0x77
	out PORTB, r16
	rcall delay1000ms

	; dígito 11
	ldi r16, 0x1F
	out PORTB, r16
	rcall delay1000ms

	; dígito 12
	ldi r16, 0x4E
	out PORTB, r16
	rcall delay1000ms

	; dígito 13
	ldi r16, 0x3D
	out PORTB, r16
	rcall delay1000ms

	; dígito 14
	ldi r16, 0x4F
	out PORTB, r16
	rcall delay1000ms

	; dígito 15
	ldi r16, 0x47
	out PORTB, r16
	rcall delay1000ms

	rjmp loop    ; volta e repete

; --- Sub-rotina de delay (1000ms) ---
delay1000ms:
	ldi r22,byte3(ClockMHz * 1000 * DelayMs / 5)
	ldi r21,high(ClockMHz * 1000 * DelayMs / 5)
	ldi r20,low(ClockMHz * 1000 * DelayMs / 5)

delay_loop:
	subi r20,1
	sbci r21,0
	sbci r22,0
	brcc delay_loop

	ret
