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
;First I decide to move the random numbers for comparison inside the round
mov a, round
cjne a,#0x00,rand1
mov ranint, (rand+0)
ljmp check_round_end
rand1:
cjne a,#0x01,rand2
mov ranint, (rand+1)
ljmp check_round_end
rand2:
cjne a,#0x02,rand3
mov ranint, (rand+2)
ljmp check_round_end
rand3:
cjne a,#0x03,rand4
mov ranint, (rand+3)
ljmp check_round_end
rand4:
cjne a,#0x04,rand5
mov ranint, (rand+4)
ljmp check_round_end
rand5:
cjne a,#0x05,rand6
mov ranint, (rand+5)
ljmp check_round_end
rand6:
cjne a,#0x06,rand7
mov ranint, (rand+6)
ljmp check_round_end
rand7:
cjne a,#0x07,rand8
mov ranint, (rand+7)
ljmp check_round_end
rand8:
cjne a,#0x08,rand9
mov ranint, (rand+8)
ljmp check_round_end
rand9:
cjne a,#0x09,rand10
mov ranint, (rand+9)
ljmp check_round_end
rand10:
cjne a,#0x0a,rand11
mov ranint, (rand+10)
ljmp check_round_end
rand11:
cjne a,#0x0b,rand12
mov ranint, (rand+11)
ljmp check_round_end
rand12:
cjne a,#0x0c,rand13
mov ranint, (rand+12)
ljmp check_round_end
rand13:
cjne a,#0x0d,rand14
mov ranint, (rand+13)
ljmp check_round_end
rand14:
cjne a,#0x0e,check_round_end
mov ranint, (rand+14)


check_round_end:
;then I check when the round is equalt to the level which is where it ends

mov b, round
mov a,level
cjne a,b,Check_If_Correct
LevelIncrement: 
;if so i increment the level, if not the game keeps playing
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