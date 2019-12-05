addi $one, $r0, 1
addi $r29, $r0, 0
add $t0active, $r0, $r29		#set initial target to 0

loop:
nop
nop
nop
nop
bne $t0hit, $one, loop
addi $r29, $r29, 1
add $t0active, $r0, $r29		#set new target
j loop
nop
nop
nop
nop


