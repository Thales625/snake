.include "utils.asm"

# Bitmap display config
#	Widht = 8
#	Height = 8
#
#	Display Width = 512
#	Display Heigth = 512
#
#	Base address = 0x10010000 (static data)

.eqv COLOR $s0
.eqv POINTER $s1
.eqv START_ADDRESS $s2
.eqv LIMIT_ADDRESS $s3

.eqv WIDTH 64
.eqv HEIGHT 64

.eqv RED 0x00ff0000 # 0x--RRGGBB
.eqv GREEN 0x0000ff00
.eqv BLUE 0x000000ff

.macro address_by_coord(%x, %y)
	li $t0, %y
	mul $t0, $t0, WIDTH
	addi $t0, $t0, %x
	sll $t0, $t0, 2
	add POINTER, $t0, START_ADDRESS
.end_macro

.macro plot
	sw COLOR, 0(POINTER)
.end_macro

.macro set_color(%color)
	li COLOR, %color
.end_macro

.data
framebuffer: .space 0x4000 # width * heigth * 4 = 64 * 64 * 4
stack: .space 0x8000 # 2 * 4 * width * height

.text
la START_ADDRESS, framebuffer

# end of screen
li LIMIT_ADDRESS, WIDTH
mul LIMIT_ADDRESS, LIMIT_ADDRESS, HEIGHT
mul LIMIT_ADDRESS, LIMIT_ADDRESS, 4
add LIMIT_ADDRESS, LIMIT_ADDRESS, START_ADDRESS

set_color(GREEN)
address_by_coord(0, 0)
plot()

set_color(RED)
address_by_coord(63, 63)
plot()

set_color(BLUE)
address_by_coord(31, 31)
plot()

end: done()