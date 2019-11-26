
#script for testing hardware functionality of randn
#generates 20 random numbers in a loop and stores them to register 12
addi $r10, $r0, 20	#$r10 = 20
loop:
	addi $r11, $r11, 1	#$r11 = $r11++
	randn $r12		#$r12 = some random number
	blt $r11, $r10, loop	#if counter $r11 < value $r10, branch back to loop