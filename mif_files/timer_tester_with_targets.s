addi $one, $r0, 1		# Target 2 becomes active at start
addi $t0active, $r0, 2
addi $r29, $r0, 3
timera $r29
nop
nop
loop1:
bne $timer1, $one, next1
	j loop1

next1:			# Target 5 becomes acgive after 3 secs
addi $t0active, $r0, 5
addi $r29, $r0, 2
timerb $r29
nop
nop
loop2:
bne $timer2, $one, next2
	j loop2

next2:			# Target 8 becomes active after 2 secs
addi $t0active, $r0, 8
addi $r29, $r0, 3
timerc $r29
nop
nop
loop3:
bne $gametimer, $one, next3
	j loop3

next3:			# Target 9 becomes active at end after 3 secs
addi $t0active, $r0, 9
