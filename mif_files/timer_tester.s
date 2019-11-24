#This is a script with the purpose of testing the hardware functionality of the timer
# it will require targets (or some visual) to be implemented for the active target register 1

#Testing timera
addi $r10, $r0, 1	#$r10 = 1
timera 2		#start 1 second timer
add $r4, $r10, $r0	#setting active target 1 to be target 1
loopa:
	blt $r6, $r10, loopa	#branch to loopa until $r6 = 0, ie timera is done

#Testing timerb
addi $r10, $r0, 2	#$r10 = 2
timerb 2		#start 1 second timer
add $r4, $r10, $r0	#setting active target 1 to be target 2
loopb:
	blt $r7, $r10, loopb	#branch to loopb until $r7 = 0, ie timerb is done

#Testing timerc
addi $r10, $r0, 3	#$r10 = 3
timerb 3		#start 1 second timer
add $r4, $r10, $r0	#setting active target 1 to be target 3
loopc:
	blt $r8, $r10, loopc	#branch to loopb until $r8 = 0, ie timerc is done


