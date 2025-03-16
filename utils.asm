.macro read_int(%save_reg)
	li $v0, 5
	syscall

	add %save_reg, $zero, $v0
.end_macro

.macro print_int(%reg)
	move $a0, %reg
	li $v0, 1
	syscall
.end_macro

.macro read_string(%address)
	li $v0, 8
	la $a0, %address
	li $a1, 32
	syscall
.end_macro

.macro print_string(%address)
	li $v0, 4
	la $a0, %address
	syscall
.end_macro


.macro random_int(%save_reg, %max)
	li $a1, %max
    li $v0, 42
    syscall

	add %save_reg, $zero, $a0
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
