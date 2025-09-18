;
; timer.asm
;
; Created: 03/09/2025 10:19:12
; Author : marlo
;


; Replace with your application code

.equ ClockMHz = 16
.equ DelayMs = 1000



delay1000ms:
	ldi r22, byte3(ClockMHz * 1000 * DelayMs / 5)
	ldi r21, high(ClockMHz * 1000 * DelayMs / 5)
	ldi r20, low(ClockMHz * 1000 * DelayMs / 5)

	subi r20, 1
	sbci r21, 0
	sbci r22, 0
	brcc pc-3

	ret