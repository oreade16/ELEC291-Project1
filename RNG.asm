$NOLIST
$MOD52
$LIST

org 0000H
   ljmp MyProgram

; These register definitions needed by 'math32.inc'
DSEG at 30H
x:   ds 4
y:   ds 4
z:   ds 4
bcd: ds 5
seed: ds 4
rand: ds 16

BSEG
mf: dbit 1

$NOLIST
$include(math32.inc)
$LIST

cseg
; These 'equ' must match the hardware wiring
LCD_RS equ P3.2
;LCD_RW equ PX.X ; Not used in this code, connect the pin to GND
LCD_E  equ P3.3
LCD_D4 equ P3.4
LCD_D5 equ P3.5
LCD_D6 equ P3.6
LCD_D7 equ P3.7

$NOLIST
$include(LCD_4bit_MS.inc) ; A library of LCD related functions and utility macros
$LIST



;                     1234567890123456    <- This helps determine the location of the counter
Initial_Message:  db 'Random Number ', 0
No_Signal_Str:    db 'No signal      ', 0

; Sends 10-digit BCD number in bcd to the LCD
Display_10_digit_BCD:
	Display_BCD(bcd+4)
	Display_BCD(bcd+3)
	Display_BCD(bcd+2)
	Display_BCD(bcd+1)
	Display_BCD(bcd+0)
	ret

;Initializes timer/counter 2 as a 16-bit timer
InitTimer2:
	mov T2CON, #0 ; Stop timer/counter.  Set as timer (clock input is pin 22.1184MHz).
	; Set the reload value on overflow to zero (just in case is not zero)
	mov RCAP2H, #0
	mov RCAP2L, #0
    ret

;---------------------------------;
; Hardware initialization         ;
;---------------------------------;
Initialize_All:
    lcall InitTimer2
    lcall LCD_4BIT ; Initialize LCD
	ret

;---------------------------------;
; Main program loop               ;
;---------------------------------;
MyProgram:
    ; Initialize the hardware:
    mov SP, #7FH
    lcall Initialize_All
    setb P0.0 ; Pin is used as input

	Set_Cursor(1, 1)
    Send_Constant_String(#Initial_Message)
    mov r7,#0x00
    
forever:
    ; synchronize with rising edge of the signal applied to pin P0.0
    clr TR2 ; Stop timer 2
    mov TL2, #0
    mov TH2, #0
    clr TF2
    setb TR2
synch1:
	jb TF2, fail1 ; If the timer overflows, we assume there is no signal
	sjmp skip1
fail1: ljmp no_signal
skip1: jb P0.0, synch1
synch2:    
	jb TF2, fail2
	sjmp skip2
fail2: ljmp no_signal
skip2:    jnb P0.0, synch2
    
    ; Measure the period of the signal applied to pin P0.0
    clr TR2
    mov TL2, #0
    mov TH2, #0
    clr TF2
    setb TR2 ; Start timer 2
measure1:
	jb TF2, fail3
	sjmp skip3
fail3: ljmp no_signal	
skip3:    jb P0.0, measure1
measure2:    
	jb TF2, fail4
	sjmp skip4
fail4: ljmp no_signal	
skip4: jnb P0.0, measure2
    clr TR2 ; Stop timer 2, [TH2,TL2] * 542.5347ns is the period


rng:
	; Using integer math, convert the period to frequency:
	mov x+0, Seed+0
	mov x+1, Seed+1
	mov x+2, Seed+2
	mov x+3, Seed+3
	; Make sure [TH2,TL2]!=0
	;mov a, TL2
	;orl a, TH2
	;jz no_signal
	Load_y(214013) ; One clock pulse is 12.0/22.1184E6 = 542.5347ns 
	lcall mul32
	Load_y(2531011)
	lcall add32
	mov Seed+0,x+0
	mov Seed+1,x+1
	mov Seed+2,x+2
	mov Seed+3,x+3
	
	Load_y(88); This number is variable. It can be used to generate different numbers in the array. 
	lcall div32
	mov x+3,#0x00
	mov x+2,#0x00
	mov x+1,#0x00
	mov a,x+0
	mov b,#0x04
	div ab
	mov x+0,b
	;Set the cursor to display the digits
	;Set_Cursor(2, 1)
	;lcall hex2bcd
	;lcall Display_10_digit_BCD
	cjne r7,#0x00,not0
	mov rand+0,x+0
	;Set_Cursor(2, 1)
	;Display_BCD(rand+0)
	ljmp addreg
not0:
    cjne r7,#0x01,not1
	mov rand+1,x+0
	;Set_Cursor(2, 1)
	;Display_BCD(rand+1)
	ljmp addreg
not1:
 cjne r7,#0x02,not2
	mov rand+2,x+0
	ljmp addreg
not2:
 cjne r7,#0x03,not3
	mov rand+3,x+0
	ljmp addreg
not3:
 cjne r7,#0x04,not4
	mov rand+4,x+0
	ljmp addreg
not4:
 cjne r7,#0x05,not5
	mov rand+5,x+0
	ljmp addreg
not5:
 cjne r7,#0x06,not6
	mov rand+6,x+0
	ljmp addreg
not6:
 cjne r7,#0x07,not7
	mov rand+7,x+0
	ljmp addreg
not7:
 cjne r7,#0x08,not8
	mov rand+8,x+0
	ljmp addreg
not8:
 cjne r7,#0x09,not9
	mov rand+9,x+0
	ljmp addreg
not9:
 cjne r7,#0x0a,nota
	mov rand+10,x+0
	ljmp addreg
nota:
 cjne r7,#0x0b,notb
	mov rand+11,x+0
	ljmp addreg
notb:
 cjne r7,#0x0c,notc
	mov rand+12,x+0
	ljmp addreg
notc:
 cjne r7,#0x0d,notd
	mov rand+13,x+0
	ljmp addreg
notd:
 cjne r7,#0x0e,note
	mov rand+14,x+0
	ljmp addreg
note:	

addreg:	
	mov a,r7
	add a, #0x01
	mov r7,a	
	cjne r7, #0x0f,repeat
	ljmp finito
repeat:    ljmp forever ; Repeat! 
    
no_signal:	
	Set_Cursor(2, 1)
    Send_Constant_String(#No_Signal_Str)
    ljmp forever ; Repeat!             
    
finito:
WriteCommand(#0x01)

end
