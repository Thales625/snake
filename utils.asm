.macro read_int (%x)
	li $v0, 5
	syscall
	move %x, $v0
.end_macro

.macro print_int (%x)
	move $a0, %x
	li $v0, 1
	syscall
.end_macro

.macro read_string (%address)
	li $v0, 8
	la $a0, %address
	li $a1, 32
	syscall
.end_macro

.macro print_string (%x)
	li $v0, 4
	la $a0, %x
	syscall
.end_macro

.macro sleep(%time) # seconds
	li $v0, 32
	li $a0, %time
	syscall
.end_macro

.macro done
	li $v0, 10
	syscall
.end_macro
