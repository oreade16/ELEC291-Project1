$NOLIST
$MOD52
$LIST

org 0000H
   ljmp Check_If_Correct


DSEG at 30H
ranint: ds 1 ; showing the random digit
rand: ds 16
round: ds 4
level: ds 4
Sensor1_pressed: ds 1
Sensor2_pressed: ds 1
Sensor3_pressed: ds 1
Sensor4_pressed: ds 1



cseg
LevelCode:
mov a, level
cjne a,#0x15, RoundCode
ljmp You_Win

RoundCode: 
mov b, round
mov a,level
cjne a,b,Check_If_Correct
LevelIncrement: 
mov b,#0x00
add a,#0x01
mov round, b
mov level, a
ljmp LevelCode



Check_If_Correct: 
push acc
push psw
mov a,ranint
cjne a, #0x01,random2
mov a,Sensor1_pressed
cjne a, #0x01,endgame
random2:
cjne a, #0x02,random3
mov a,Sensor2_pressed
cjne a, #0x01,endgame
random3:
cjne a, #0x03,random4
mov a,Sensor3_pressed
cjne a, #0x01,endgame
random4:
cjne a, #0x00,checkedall
mov a,Sensor4_pressed
cjne a, #0x01,endgame
checkedall: 
mov a,round
add a,#0x01
mov round,a 
ljmp LevelIncrement
endgame:


pop psw
push acc


You_Win:

end