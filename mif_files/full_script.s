#To Do
	#have to check to make sure score doesnt go too high

#initialize ie load constants
addi $civilian1, $r0, 0		#$r10 = 0, target number of civilian 1
addi $civilian2, $r0, 1		#$r11 = 1, target number of civilian 2
addi $civilian3, $r0, 2		#$r12 = 2, target number of civilian 3
addi $civilian4, $r0, 3		#$r21 = 3, target number of civilian 4
addi $civilianscore, $r0, 100	#$r13 = 100, score to be subtracted if civilian hit
addi $villainscore, $r0, 150   #$r14 = 200, score to be added if villain hit
addi $one, $r0, 1		#$r15 = 1, often need to compare a reg to number 1
addi $scoreincrement, $r0, 1000	#$r18 = 500, every time the score threshold is met, it is incremented by 500
addi $timermax, $r0, 5		#$r20 = 5, number of seconds targets are on with a score of 0

#waiting for button to be pressed for initial start
waitButton:
	bne $bp, $one, waitButton	#if button register ~= 1, branch back to waitButton

#reset/start everything
start:
	addi $scorethreshold, $r0, 500	#$scorethreshold = 500, every 500 pts the time the targets stay live decreases
	add $score, $r0, $r0		#$score = 0
	add $timeoffset, $r0, $r0	#$timeroffset = 0, this is subtracted from the base time for how long targets stay active
	
	addi $r29, $r0, 120		#$r29 = 120, number of seconds the game will last
	timerc $r29			#starting game timer, currently 60 seconds long

	#starting target 1
	jal generaterand
	add $t0active, $r0, $rand		#set new target
	sub $r29, $timermax, $timeoffset	#calculating how long the target should be active for
	timera $r29
	nop
	nop

	#starting a new target 2
	jal generaterand
	add $t1active, $r0, $rand		#set new target
	sub $r29, $timermax, $timeoffset	#calculating how long the target should be active for
	addi $r28, $r20, 2
	sub $r29, $r29, $r28			#initial timer for target 2 is two seconds shorter so that the targets are offset
	timerb $r29
	nop
	nop

gameloop: 

#check if time is up
bne $gametimer, $one, waitButton

#check if button is pressed
bne $bp, $r0, start

#check score
updatescore:
	checkhit1:
		bne $t0hit, $one, checkhit2	#if target 0 isnt hit, branch to check target 1
		addi $r29, $r0, 4	#$r29 = 4
		blt $t0active, $r29, civilian1	#branching if it's a civilian
		
		#if havent branched, hit a villain
		add $score, $score, $villainscore
		j starttarget1	#skip score for civilian

		civilian1:
		blt $score, $civilianscore, starttarget1	#if the score is less than what a civilian score would cost, branches to avoid -score
		sub $score, $score, $civilianscore
		
		#starting a new target 1
		starttarget1:
			addi $activetarget, $r0, 1	#setting target that will be staying active as target 1
			jal generaterand
			add $t0active, $r0, $rand		#set new target
			sub $r29, $timermax, $timeoffset	#calculating how long the target should be active for
			timera $r29
			nop
			nop
		

	checkhit2:
		bne $t1hit, $one, updatetimeoffset	#if target 1 isnt hit, branch to update time offset
		addi $r29, $r0, 4	#$r29 = 4
		blt $t1active, $r29, civilian2		#branch if hit target is civilian
		
		#if havent branch yet, hit a civilian
		add $score, $score, $villainscore
		j starttarget2	#skip score for civilian

		civilian2:
		blt $score, $civilianscore, starttarget2	#if the score is less than what a civilian score would cost, branches to avoid -score
		sub $score, $score, $civilianscore

		#starting a new target 2
		starttarget2:
			addi $activetarget, $r0, 0	#setting target that will be staying active as 0
			jal generaterand
			add $t1active, $r0, $rand		#set new target
			sub $r29, $timermax, $timeoffset	#calculating how long the target should be active for
			timerb $r29
			nop
			nop
	
	updatetimeoffset:
		addi $r29, $r0, 4
		blt $score, $scorethreshold, scorecheck		#branch if the score isnt greater than the threshold
		add $scorethreshold, $scorethreshold, $scoreincrement	#scorethreshold = scorethreshold + increment
		add $timeoffset, $timeoffset, $one		#timeoffset++
		bne $timeoffset, $r29, scorecheck		#if time offset doesnt equal 4, branch
		addi $timeoffset, $r0, 2		#if didn't branch, time offset hit 4 and we don't want it to exceed 3

	scorecheck:
		addi $r29, $r0, 9950
		blt $score, $r29, timers	#if score isnt over threshold, jump
		addi $score, $r0, 9999	#set score to max
		j waitButton
		
timers:		
	timer1:
		bne $timer1, $r0, timer2	#if the timer isnt done, branch to timer 2
		
		#starting a new target 0
		addi $activetarget, $r0, 1	#setting target that is staying active as 1
		jal generaterand
		add $t0active, $r0, $rand		#set new target
		sub $r29, $timermax, $timeoffset	#calculating how long the target should be active for
		timera $r29
		nop
		nop

	timer2:
		bne $timer2, $r0, gameloop	#if timer isn't done, branch to the game loop
		addi $activetarget, $r0, 0	#setting target to stay active as 0
		jal generaterand
		add $t1active, $r0, $rand		#set new target
		sub $r29, $timermax, $timeoffset	#calculating how long the target should be active for
		timerb $r29
		nop
		nop
	
j gameloop

#generates a random number [0-9]
#checks that the generated number is not the same as the current two active targets to ensure you don't get the same target two
#times in a row and also don't set active1 and active2 to the same thing
#also makes sure that two civilians are not active at once
#IMPORTANT: before calling this function, set $activetarget to be 0 or 1 dependending on which active target register is going to be remaining active (ie 	#not replaced by this new random number - this is used for the no two civilians bit
generaterand:
	randn $rand
nop
nop
nop
nop
nop #see if it's a  bypass thing
	
	#checking if the generated number is the same as the current active targets
	equalactive0:
		bne $rand, $t0active, equalactive1	#if same as active target 1, generate new random number
		j generaterand
	equalactive1:
		bne $rand, $t1active, checkingcivilians	#if same as active target 2, generate new random number
		j generaterand
	
	#checking if the active that isnt being replaced is a civilian and, if it is, making sure the generated random number isnt a civilian too
	checkingcivilians:
	addi $r29, $r0, 4	#$r29 = 4, used for blt checking if a target is a civilian
	#checking if active0 is staying on and if it's a civilian
	active0:
		bne $activetarget, $r0, active1		#if t0active is staying on, stay here and check active0 otherwise jump to check t1active
			blt $t0active, $r29, activecivilian	#if t0active is a civilian, jump to activecivilian, if its not, jump to end
				j endgeneraterand
	#assuming if makes it to active 1 that active 1 is not being shut off
	active1:
		blt $t1active, $r29, activecivilian	#if active1 is a civilian, jump to active civilian, if it's not, jump to end
			j endgeneraterand

	#if active is a civilian (jump from previous branches), then checking of randn is a civilian
	activecivilian:
		addi $r29, $r0, 4	#$r29 = 4, used for blt checking if a target is a civilian
		blt $rand, $r29, generaterand	#if randn is a civilian, generate a new random number
			j endgeneraterand

	endgeneraterand:
		jr $ra

	