#This is a script with the purpose of testing the hardware functionality of the timer
# it will require targets (or some visual) to be implemented for the active target register 1

addi $r13 $r0 3
addi $r14 $r0 6
addi $r15 $r0 12

#Testing timera
timera $r13		#start 3 second timer
add $r4 $r0 1		#setting active target 1 to be target 1
nop			#allow stuff to update after timer start
loopa:
	blt $r0, $r6, loopa	#branch to loopa until $r6 = 0, ie timera is done

#Testing timerb
timerb $r14		#start 4 second timer
nop
add $r4 $r0 2		#setting active target 1 to be target 2
loopb:
	blt $r0, $r7, loopb	#branch to loopb until $r7 = 0, ie timerb is done

#Testing timerc
timerc $r15		#start 12 second timer
addi $r4 $r0 3		#setting active target 1 to be target 3
nop
loopc:
	blt $r0, $r8, loopc	#branch to loopb until $r8 = 0, ie timerc is done


