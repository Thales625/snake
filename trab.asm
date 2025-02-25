.data
.text

lui $t0,0x1001
move $t1, $t0
li $t2, 0x00ff00
li $t3, 0

size:
sw $t2, 0($t0)
addi $t0, $t0, 4
addi $t3, $t3, 1
beq $t3, 64, loop
j size

loop:
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $zero, 0($t1)
addi $t1, $t1, 4
j loop

