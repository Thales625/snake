.include "utils.asm"

.eqv COLOR $s0
.eqv POINTER $s1
.eqv START_ADDRESS $s2
.eqv LIMIT_ADDRESS $s3
.eqv X $s3
.eqv Y $s4

.eqv WIDTH 64
.eqv HEIGHT 64

.macro address_by_coord(%x, %y)
	# x*4 + y*width*4
	# (x + y*width) << 2
	li $t0, %y
	mul $t0, $t0, WIDTH
	addi $t0, $t0, %x
	sll $t0, $t0, 2
	add POINTER, $t0, START_ADDRESS
.end_macro

.macro plot
	sw COLOR, 0(POINTER)
.end_macro

.data
framebuffer: .space 0x4000 # width * heigth * 4 = 64 * 64 * 4

.text
li COLOR, 0x0000ff00 # 0x--RRGGBB
la START_ADDRESS, framebuffer

# end of screen
li LIMIT_ADDRESS, WIDTH
mul LIMIT_ADDRESS, LIMIT_ADDRESS, HEIGHT
mul LIMIT_ADDRESS, LIMIT_ADDRESS, 4
add LIMIT_ADDRESS, LIMIT_ADDRESS, START_ADDRESS

address_by_coord(63, 63)
plot()

end: done()