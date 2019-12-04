addi $one, $r0, 1
addi $t0active, $r0, 2
addi $r29, $r29, 3
timera $r29
nop
nop
loop1:
bne $timer1, $one, next1
	j loop1
next1:
addi $t0active, $r0, 5

addi $r29, $r0, 2
timerb $r29
nop
nop
loop2:
bne $timer2, $one, next2
	j loop2
next2:
addi $t0active, $r0, 8

addi $r29, $r0, 3
timerc $r29
nop
nop
loop3:
bne $gametimer, $one, next3
	j loop3
next3:
addi $t0active, $r0, 1
