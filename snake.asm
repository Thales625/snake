# Bitmap display config
#	Widht = 8
#	Height = 8
#
#	Display Width = 512
#	Display Heigth = 512
#
#	Base address = 0x10010000 (static data)

# REGISTERS
.eqv NONE $s0
.eqv COLOR $s1

.eqv DISPLAY_PTR $s2
.eqv DISPLAY_START_ADDR $s3

.eqv STACK_START_ADDR $s4
.eqv STACK_HEAD_PTR $s5 # snake head

.eqv HEAD_NEXT_X $t8
.eqv HEAD_NEXT_Y $t9

.eqv AUX_X $t2
.eqv AUX_Y $t3

.eqv APPLE_X $t2
.eqv APPLE_Y $t3

.eqv MOVE_X $t4
.eqv MOVE_Y $t5

# CONSTS
.eqv WIDTH 64
.eqv HEIGHT 64

.eqv RED 0x00ff0000 # 0x--RRGGBB
.eqv GREEN 0x0000ff00
.eqv BLUE 0x000000ff
.eqv BACKGROUND 0x00000000

# MACROS
.include "utils.asm"

# TODO: transform in subroutine
.macro display_addr(%x, %y) # set DISPLAY_PTR
	# li $t8, %y
	move $t8, %y
	mul $t8, $t8, WIDTH
	add $t8, $t8, %x
	sll $t8, $t8, 2
	add DISPLAY_PTR, $t8, DISPLAY_START_ADDR
.end_macro

.macro plot
	sw COLOR, 0(DISPLAY_PTR)
.end_macro

.macro set_color(%color)
	addi COLOR, $zero, %color
	# li COLOR, %color
.end_macro

.macro shift_stack
	# $t6 -> i
	# $t7 -> aux
	move $t6, STACK_START_ADDR
	loop_shift_stack:
	lw $t7, 8($t6)
	sw $t7, 0($t6)

	lw $t7, 12($t6)
	sw $t7, 4($t6)

	addi $t6, $t6, 8

	blt $t6, STACK_HEAD_PTR, loop_shift_stack
.end_macro

.macro update
	lw HEAD_NEXT_X, (STACK_HEAD_PTR)
	add HEAD_NEXT_X, HEAD_NEXT_X, MOVE_X

	lw HEAD_NEXT_Y, 4(STACK_HEAD_PTR)
	add HEAD_NEXT_Y, HEAD_NEXT_Y, MOVE_Y

	# ignore apple collision for now
	
	lw $t6, (STACK_START_ADDR)  # x
	lw $t7, 4(STACK_START_ADDR) # y
	set_color(BACKGROUND)
	# set_color(RED)
	display_addr($t6, $t7)
	plot()

	shift_stack()

	sw HEAD_NEXT_X, (STACK_HEAD_PTR)
	sw HEAD_NEXT_Y, 4(STACK_HEAD_PTR)
.end_macro

.macro setup_memory
	# mem[stack[2*head_ptr+1]][stack[2*head_ptr]] = CHAR_HEAD;
	# lw AUX_X, (STACK_HEAD_PTR)
	# lw AUX_Y, 4(STACK_HEAD_PTR)

	set_color(GREEN)
	display_addr(AUX_X, AUX_Y)
	plot()

	# $t6 -> i
	move $t6, STACK_START_ADDR
	loop_setup_memory:
	lw AUX_X, 0($t6) # x
	lw AUX_Y, 4($t6) # y

	# if AUX_X != -1
	bne AUX_X, NONE, true_setup_memory
	bne AUX_Y, NONE, true_setup_memory
	j false_setup_memory

	true_setup_memory:
	# set_color(GREEN)
	display_addr(AUX_X, AUX_Y)
	plot()
	false_setup_memory:
	addi $t6, $t6, 8

	blt $t6, STACK_HEAD_PTR, loop_setup_memory
.end_macro

.data
framebuffer: .space 0x4000 # width * heigth * 4 = 64 * 64 * 4
stack: .space 0x8000 # 2 * 4 * width * height

.text
la DISPLAY_START_ADDR, framebuffer
la STACK_START_ADDR, stack
addi NONE, $zero, -1

# CLEAR STACK
	# $t0 -> counter
	li $t0, WIDTH
	mul $t0, $t0, HEIGHT
	sll $t0, $t0, 1

	move STACK_HEAD_PTR, STACK_START_ADDR
	loop_clear_stack:
	sw NONE, (STACK_HEAD_PTR)
	addi STACK_HEAD_PTR, STACK_HEAD_PTR, 4
	addi $t0, $t0, -1
	bgt $t0, NONE, loop_clear_stack
# END

# SETUP
	# populate stack
	# $t0 -> aux
	move STACK_HEAD_PTR, STACK_START_ADDR
	addi $t0, $zero, 1 # x
	sw $t0, (STACK_HEAD_PTR)
	addi $t0, $zero, 1 # y
	sw $t0, 4(STACK_HEAD_PTR)

	addi STACK_HEAD_PTR, STACK_HEAD_PTR, 8
	addi $t0, $zero, 2 # x
	sw $t0, (STACK_HEAD_PTR)
	addi $t0, $zero, 1 # y
	sw $t0, 4(STACK_HEAD_PTR)

	addi STACK_HEAD_PTR, STACK_HEAD_PTR, 8
	addi $t0, $zero, 3 # x
	sw $t0, (STACK_HEAD_PTR)
	addi $t0, $zero, 1 # y
	sw $t0, 4(STACK_HEAD_PTR)
	
	# apple
	addi $zero, APPLE_X, 3
	addi $zero, APPLE_Y, 6

	# move
	addi $zero, MOVE_X, 1
	addi $zero, MOVE_Y, 0
# END

loop:
sleep(1000)
update()
setup_memory()
j loop

end: done()
