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

.eqv DISPLAY_START_ADDR $s2
.eqv DISPLAY_PTR $t0
.eqv DISPLAY_X $t1
.eqv DISPLAY_Y $t2

.eqv STACK_START_ADDR $s3
.eqv STACK_HEAD_PTR $s4 # snake head

.eqv APPLE_X $s5
.eqv APPLE_Y $s6

.eqv MOVE_X $t4
.eqv MOVE_Y $t5

.eqv HEAD_NEXT_X $t6
.eqv HEAD_NEXT_Y $t7

# CONSTS
.eqv WIDTH 64
.eqv HEIGHT 64

# COLORS (0x--RRGGBB)
.eqv RED 0x00ff0000
.eqv GREEN 0x0000ff00
.eqv BLUE 0x000000ff
.eqv BACKGROUND 0x00000000

# MACROS
.include "utils.asm"

.macro set_color(%color)
	addi COLOR, $zero, %color
.end_macro

.macro shift_stack
	# $t0 -> i
	# $t1 -> aux
	move $t0, STACK_START_ADDR
	loop_shift_stack:
	lw $t1, 8($t0)
	sw $t1, 0($t0)

	lw $t1, 12($t0)
	sw $t1, 4($t0)

	addi $t0, $t0, 8

	blt $t0, STACK_HEAD_PTR, loop_shift_stack
.end_macro

.macro update_apple
	# $t0 -> i
	# $t1 -> x
	# $t2 -> y
	loop_update_apple_1:
	random_int(APPLE_X, WIDTH)
	random_int(APPLE_Y, HEIGHT)

	# check if not colliding with snake

	move $t0, STACK_START_ADDR
	loop_update_apple_2:
		lw $t1, 0($t0) # x
		lw $t2, 4($t0) # y 

		beq $t1, APPLE_X, loop_update_apple_1
		beq $t2, APPLE_Y, loop_update_apple_1

		addi $t0, $t0, 8

		ble $t0, STACK_HEAD_PTR, loop_update_apple_2
.end_macro

.macro update
	lw HEAD_NEXT_X, (STACK_HEAD_PTR) # head_next_x
	add HEAD_NEXT_X, HEAD_NEXT_X, MOVE_X

	lw HEAD_NEXT_Y, 4(STACK_HEAD_PTR) # head_next_y
	add HEAD_NEXT_Y, HEAD_NEXT_Y, MOVE_Y

	# plot snake head
	set_color(GREEN)
	move DISPLAY_X, HEAD_NEXT_X
	move DISPLAY_Y, HEAD_NEXT_Y
	jal plot

	beq APPLE_X, HEAD_NEXT_X, update_check_y # apply_x ==  head_next_x
	j update_case_not_eat
	update_check_y:
	beq APPLE_Y, HEAD_NEXT_Y, update_case_eat # apply_y ==  head_next_y
	j update_case_not_eat
	# CASE EAT
	update_case_eat:
		addi STACK_HEAD_PTR, STACK_HEAD_PTR, 8 # increase STACK_HEAD_PTR
		# update apple position
		update_apple()
		# plot apple
		set_color(RED)
		move DISPLAY_X, APPLE_X
		move DISPLAY_Y, APPLE_Y
		jal plot

		j update_end

	# CASE NOT EAT
	update_case_not_eat:
		# clear shifted point (last snake tail)
		set_color(BACKGROUND)
		lw DISPLAY_X, (STACK_START_ADDR)  # x
		lw DISPLAY_Y, 4(STACK_START_ADDR) # y
		jal plot

		shift_stack()
	
		j update_end

	update_end:
	# set next snake head position
	sw HEAD_NEXT_X, (STACK_HEAD_PTR)
	sw HEAD_NEXT_Y, 4(STACK_HEAD_PTR)
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
	addi APPLE_X, $zero, 3
	addi APPLE_Y, $zero, 6

	# plot apple
	set_color(RED)
	move DISPLAY_X, APPLE_X
	move DISPLAY_Y, APPLE_Y
	jal plot

	# move
	addi MOVE_X, $zero, 0
	addi MOVE_Y, $zero, 1
# END

loop:
	sleep(1000)
	update()
	j loop

# subroutines
j end
plot:
	mul DISPLAY_Y, DISPLAY_Y, WIDTH
	add DISPLAY_Y, DISPLAY_Y, DISPLAY_X
	sll DISPLAY_Y, DISPLAY_Y, 2
	add DISPLAY_PTR, DISPLAY_Y, DISPLAY_START_ADDR

	sw COLOR, 0(DISPLAY_PTR)
	jr $ra

end: done()
