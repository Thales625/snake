# testing keyboard
.include "utils.asm"

.eqv aux $t0
.eqv key $t1

.text
li key, 0xffff0004

loop:
lw aux, 0(key)
sleep(10)
j loop

end: done()
