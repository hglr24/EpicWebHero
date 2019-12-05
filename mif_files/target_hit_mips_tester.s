addi $one, $r0, 1
addi $r29, $r0, 0
add $t1active, $r0, $r29		#set initial target to 0

loop:
bne $t1hit, $one, loop
addi $r29, $r29, 1
add $t1active, $r0, $r29		#set new target
j loop
halt 0

