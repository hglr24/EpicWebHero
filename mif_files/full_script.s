#To handle:	
	# not letting two civilians be selected

#assumptions
	# the first 

#initialize ie load constants
addi $civilian1, $r0, 0		#$r10 = 0, target number of civilian 1
addi $civilian2, $r0, 1		#$r11 = 1, target number of civilian 2
addi $civilian3, $r0, 2		#$r12 = 2, target number of civilian 3
addi $civilian4, $r0, 3		#$r21 = 3, target number of civilian 4
addi $civilianscore, $r0, 100	#$r13 = 100, score to be subtracted if civilian hit
addi $villainscore, $r0, 200	#$r14 = 200, score to be added if villain hit
addi $one, $r0, 1		#$r15 = 1, often need to compare a reg to number 1
addi $scoreincrement, $r0, 500	#$r18 = 500, every time the score threshold is met, it is incremented by 500
addi $timermax, $r0, 10		#$r20 = 10, number of seconds targets are on with a score of 0

#waiting for button to be pressed for initial start
waitButton:
	bne $bp, $one, waitButton	#if button register ~= 1, branch back to waitButton

#reset/start everything
start:
	addi $scorethreshold, $r0, 500	#$scorethreshold = 500, every 500 pts the time the targets stay live decreases
	add $score, $r0, $r0		#$score = 0
	add $timeoffset, $r0, $r0	#$timeroffset = 0, this is subtracted from the base time for how long targets stay active
	
	addi $r29, $r0, 60		#$r29 = 60, number of seconds the game will last
	timerc $r29			#starting game timer, currently 60 seconds long
	
	#starting target 1
	jal generaterand
	add $t0active, $r0, $rand		#set new target
	sub $r29, $timermax, $timeoffset	#calculating how long the target should be active for
	timera $r29

	#starting a new target 2
	jal generaterand
	add $t1active, $r0, $rand		#set new target
	sub $r29, $timermax, $timeoffset	#calculating how long the target should be active for
	sub $r29, $r29, 2			#initial timer for target 2 is two seconds shorter so that the targets are offset
	timerb $r29

gameloop: 

#check if time is up
bne $gametimer, $one, waitButton

#check if button is pressed
bne $bp, $r0, start

#check score
updatescore:
	checkhit1:
		bne $t1hit, $one, checkhit2	#if target 0 isnt hit, branch to check target 1
		bne $civilian1, $t0active, villain1
		bne $civilian2, $t0active, villain1
		bne $civilian3, $t0active, villain1
		bne $civilian4, $t0active, villain1
		
		#if havent branched yet, hit a civilian
		sub $score, $score, $civilianscore
		j checkhit2	#skip score for villain

		villain1:
		add $score, $score, $villainscore
		
		#starting a new target 1
		addi $activetarget, $r0, 1	#setting target that will be staying active as target 1
		jal generaterand
		add $t0active, $r0, $rand		#set new target
		sub $r29, $timermax, $timeoffset	#calculating how long the target should be active for
		timera $r29
		

	checkhit2:
		bne $t2hit, $one, updatetimeoffset	#if target 0 isnt hit, branch to update time offset
		bne $civilian1, $t1active, villain2
		bne $civilian2, $t1active, villain2
		bne $civilian3, $t1active, villain2
		bne $civilian4, $t1active, villain2
		
		#if havent branch yet, hit a civilian
		sub $score, $score, $civilianscore
		j timers	#skip score for villain

		villain2:
		add $score, $score, $villainscore

		#starting a new target 2
		addi $activetarget, $r0, 0	#setting target that will be staying active as 0
		jal generaterand
		add $t1active, $r0, $rand		#set new target
		sub $r29, $timermax, $timeoffset	#calculating how long the target should be active for
		timerb $r29
	
	updatetimeoffset:
		blt $score, $scorethreshold, timers		#branch if the score isnt greater than the threshold
		add $scorethreshold, $scorethreshold, $scoreincrement	#scorethreshold = scorethreshold + increment
		add $timeoffset, $timeoffset, $one		#timeoffset++

		
timers:		#note: if change this name, it is jumped to and needs to be corrected
	timer1:
		bne $timer1, $r0, timer2	#if the timer isnt done, branch to timer b
		
		#starting a new target 1
		addi $activetarget, $r0, 1	#setting target that is staying active as 1
		jal generaterand
		add $t0active, $r0, $rand		#set new target
		sub $r29, $timermax, $timeoffset	#calculating how long the target should be active for
		timera $r29

	timer2:
		bne $timer2, $r0, gameloop
		addi $activetarget, $r0, 0	#setting target to stay active as 0
		jal generaterand
		add $t1active, $r0, $rand		#set new target
		sub $r29, $timermax, $timeoffset	#calculating how long the target should be active for
		timerb $r29
		j gameloop

#generates a random number [0-9]
#checks that the generated number is not the same as the current two active targets to ensure you don't get the same target two
#times in a row and also don't set active1 and active2 to the same thing
#also makes sure that two civilians are not active at once
#IMPORTANT: before calling this function, set $activetarget to be 0 or 1 dependending on which active target register is going to be remaining active (ie 	#not replaced by this new random number - this is used for the no two civilians bit
generaterand:
	randn $rand
	
	#checking if the generated number is the same as the current active targets
	equalactive0:
		bne $rand, $t0active, equalactive1	#if same as active target 1, generate new random number
		j generaterand
	equalactive1:
		bne $rand, $t1active, checkingcivilians	#if same as active target 2, generate new random number
		j generaterand
	
	#checking if the active that isnt being replaced is a civilian and, if it is, making sure the generated random number isnt a civilian too
	checkingcivilians:
	addi $r29, $r0, 5	#$r29 = 5, used for blt checking if a target is a civilian
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
		addi $r29, $r0, 5	#$r29 = 5, used for blt checking if a target is a civilian
		blt $rand, $r29, generaterand	#if randn is a civilian, generate a new random number
			j endgeneraterand

	endgeneraterand:
		jr $ra

	