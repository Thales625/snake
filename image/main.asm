.eqv POINTER $t0
.eqv LIMIT_ADDRESS $t1
.eqv AUX $t2
.eqv TIME_0 $t3

.macro get_ut(%x)
	li $v0, 30
	syscall
	move %x, $a0
.end_macro

.macro print_int (%x)
	move $a0, %x
	li $v0, 1
	syscall
.end_macro

.include "data.asm"

.text
la POINTER, framebuffer
addi LIMIT_ADDRESS, POINTER, 16384 # 4 * width * height

get_ut(TIME_0)
loop: 
lw AUX, 0(POINTER)
sw AUX, 0(POINTER)

addi POINTER, POINTER, 4
bgt POINTER, LIMIT_ADDRESS, end
j loop

end:
get_ut(AUX)

sub TIME_0, AUX, TIME_0

print_int(TIME_0)

li $v0, 10
syscall