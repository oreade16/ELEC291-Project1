$NOLIST
$MOD52
$LIST

org 0000H
   ljmp MyProgram

; These register definitions needed by 'math32.inc'
DSEG at 30H
x:   ds 4
y:   ds 4
bcd: ds 5

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
Pb:  db 'Press button to ', 0
Play:    db 'Play      ', 0
GR: db 'Get Ready ',0

tres: db '3',0
dos: db '2', 0
uno: db '1', 0
Overtime: db 'Overtime ',0
Game_Over: db 'Game Over ',0
Score: db ' Score:       ',0
You_Win: db 'You win     ',0

; Sends 10-digit BCD number in bcd to the LCD


;Initializes timer/counter 2 as a 16-bit timer


;---------------------------------;
; Hardware initialization         ;
;---------------------------------;

    

;---------------------------------;
; Main program loop               ;
;---------------------------------;
MyProgram:
    ; Initialize the hardware:
    mov SP, #7FH
    setb P0.0 ; Pin is used as input
    lcall LCD_4BIT ; Initialize LCD
    


    
     Set_Cursor(1, 1)
    Send_Constant_String(#Pb)
    ;Wait_milli_seconds(#250)   
   
    Set_Cursor(2, 1)
    Send_Constant_String(#Play)
    ;Wait_milli_seconds(#250)
    
 WriteCommand(#0x01)
   
   
    Set_Cursor(1, 1)
    Send_Constant_String(#GR)
    ;Wait_milli_seconds(#250)
    Set_Cursor(2, 1)
    Send_Constant_String(#tres)
    ;Wait_milli_seconds(#250)
    ;Wait_milli_seconds(#250)
    ;Wait_milli_seconds(#250)
    ;Wait_milli_seconds(#250)
    Send_Constant_String(#dos)
    ;Wait_milli_seconds(#250)
    ;Wait_milli_seconds(#250)
    ;Wait_milli_seconds(#250)
    ;Wait_milli_seconds(#250)
    Send_Constant_String(#uno)
    ;Wait_milli_seconds(#250)
    ;Wait_milli_seconds(#250)
    ;Wait_milli_seconds(#250)
    ;Wait_milli_seconds(#250)
    
    
     WriteCommand(#0x01)
     
      Set_Cursor(1, 1)
    Send_Constant_String(#Game_Over)
    ;Wait_milli_seconds(#250)
     WriteCommand(#0x01)
    
      Set_Cursor(1, 1)
    Send_Constant_String(#Score)
    ;Wait_milli_seconds(#250)
    
    WriteCommand(#0x01)
      Set_Cursor(1, 1)
    Send_Constant_String(#You_win)
    ;Wait_milli_seconds(#250)
    
    
    
 
    
    
    
    
 
   
   
    
    

    


end
