
#define TIMES_PER_SEC 20 ; quantidades de vezes que um led pisca por segundo
#define DELAY 1/TIMES_PER_SEC ;seconds
#define DelayMs DELAY * 1000

.equ ClockMHz = 16
.def tmp = r16 

rjmp RESET

RESET:

	; PB5 saída (LED)
	ldi tmp, (1<<DDB5)	
	out DDRB, tmp
	ldi tmp, 0x00
	out PORTB, tmp


blink:

	in r16, PORTB
	ldi r17, (1<<PORTB5)
	eor r16, r17
	out PORTB, r16

	rcall delay1000ms

	rjmp blink



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