# testing keyboard
.include "utils.asm"

.eqv key $t0
.eqv address $t1

.text

loop:
	# GAME LOGIC
	sleep(100)

	# wait
    lw key, 0xffff0000
    andi key, key, 0x0001
    beq key, $zero, loop # not ready

	lw key, 0xffff0004 # load key
	
	beq	key, 100, moveRight # d
	beq	key, 97, moveLeft	# a
	beq	key, 119, moveUp	# w
	beq	key, 115, moveDown	# s

	j loop

j end

moveRight:
	li $t2, 1
	print_int($t2)
	j loop
moveLeft:
	li $t2, 2
	print_int($t2)
	j loop
moveUp:
	li $t2, 3
	print_int($t2)
	j loop
moveDown:
	li $t2, 4
	print_int($t2)
	j loop

end: done()