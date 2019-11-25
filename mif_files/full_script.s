#initialize ie load constants
addi $civilian1, $r0, 0		#$r10 = 0, target number of civilian 1
addi $civilian2, $r0, 1		#$r11 = 1, target number of civilian 2
addi $civilian3, $r0, 2		#$r12 = 2, target number of civilian 3
addi $civilianscore, $r0, 50	#$r13 = 50, score to be subtracted if civilian hit
addi $villainscore, $r0, 50	#$r14 = 50, score to be added if villain hit
addi $one, $r0, 1		#$r15 = 1, often need to compare a reg to number 1

#waiting for button to be pressed for initial start
waitButton:
	blt $bp, $one, waitButton	#if button register is < 1, branch back to waitButton

#reset/start everything
start:
	sub $score, $score, $score	#$score = 0
	timerc 60			#starting game timer, currently 60 seconds long

#check score
updatescore:
	checkhit1:
		bne $t1hit, $one, checkhit2	#if target 1 isnt hit, branch to check target 2
		bne $civilian1, $t1active, villain1
		bne $civilian2, $t1active, villain1
		bne $civilian3, $t1active, villain1
		
		#if havent branched yet, hit a civilian
		sub $score, $score, $civilianscore
		j checkhit2	#skip score for villain

		villain1:
		add $score, $score, $villainscore

		jal starttarget1
	checkhit2:
		bne $t2hit, $one, checkhit2	#if target 1 isnt hit, branch to check target 2
		bne $civilian1, $t2active, villain2
		bne $civilian2, $t2active, villain2
		bne $civilian3, $t2active, villain2
		
		#if havent branch yet, hit a civilian
		sub $score, $score, $civilianscore
		j timers	#skip score for villain

		villain2:
		add $score, $score, $villainscore
		jal starttarget2
timers:		#note: if change this name, it is jumped to and needs to be corrected


starttarget1:
	rand1:
		randn $rand
		
	
	jr $ra

starttarget2:
	
	jr $ra