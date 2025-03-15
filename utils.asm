.macro sleep(%time) # seconds
	li $v0, 32
	li $a0, %time
	syscall
.end_macro

.macro done
	li $v0, 10
	syscall
.end_macro
