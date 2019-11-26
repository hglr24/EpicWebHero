#To handle:	
	# not letting two civilians be selected

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
	
	timerc 60			#starting game timer, currently 60 seconds long
	
	#starting target 1
	jal generaterand
	add $t1active, $r0, $rand		#set new target
	sub $r29, $timermax, $timeoffset	#calculating how long the target should be active for
	timera $r29

	#starting a new target 2
	jal generaterand
	add $t2active, $r0, $rand		#set new target
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
		bne $t1hit, $one, checkhit2	#if target 1 isnt hit, branch to check target 2
		bne $civilian1, $t1active, villain1
		bne $civilian2, $t1active, villain1
		bne $civilian3, $t1active, villain1
		bne $civilian4, $t1active, villain1
		
		#if havent branched yet, hit a civilian
		sub $score, $score, $civilianscore
		j checkhit2	#skip score for villain

		villain1:
		add $score, $score, $villainscore
		
		#starting a new target 1
		jal generaterand
		add $t1active, $r0, $rand		#set new target
		sub $r29, $timermax, $timeoffset	#calculating how long the target should be active for
		timera $r29
		

	checkhit2:
		bne $t2hit, $one, updatetimeoffset	#if target 1 isnt hit, branch to update time offset
		bne $civilian1, $t2active, villain2
		bne $civilian2, $t2active, villain2
		bne $civilian3, $t2active, villain2
		bne $civilian4, $t2active, villain2
		
		#if havent branch yet, hit a civilian
		sub $score, $score, $civilianscore
		j timers	#skip score for villain

		villain2:
		add $score, $score, $villainscore

		#starting a new target 2
		jal generaterand
		add $t2active, $r0, $rand		#set new target
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
		jal generaterand
		add $t1active, $r0, $rand		#set new target
		sub $r29, $timermax, $timeoffset	#calculating how long the target should be active for
		timera $r29

	timer2:
		bne $timer2, $r0, gameloop
		jal generaterand
		add $t2active, $r0, $rand		#set new target
		sub $r29, $timermax, $timeoffset	#calculating how long the target should be active for
		timerb $r29
		j gameloop

generaterand:
	randn $rand
	equalactive1:
		bne $rand, $t1active, equalactive2	#if same as active target 1, generate new random number
		j generaterand
	equalactive2:
		bne $rand, $t2active, equalactive2	#if same as active target 2, generate new random number
		j generaterand
	jr $ra