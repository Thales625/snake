.eqv VERDE 0x00ff00

.text
li $t0, 12 #tamanho (em palavras/enderecos) da cabeca da cobra
lui $t1, 0x1001 #tu sabe
move $t3, $t1 #inicializa segundo ponteiro
li $s3, VERDE #salva no registrador estatico o valor de codigo do verde
li $t5, 0xffff0000 #endereco de controle do simulador do keyboard (1 = tecla detectada / 0 = tecla nao detectada) 
li $t6, 0xffff0004 #endereco referente ao conteudo armazenado naquela celula (no caso, a letra a ser lida)


set_personagem:
    sub $t0, $t0, 1 #tu sabe, loop normal de 12 vezes blah blah blah chupa meu tico
    sw $s3, 0($t1) #cor verde no endereco de memoria atual
    addi $t1, $t1, 4 
    bgt $t0, $zero, set_personagem #bgt = bigger than, nesse caso (t0 > 0; t0 --) 
    move $t3, $t1 #salva o endereco do final da cor verde , a "ponta"
    sub $t3, $t3, 48 #transforma ela no endereco da "bunda" da cor verde, 12 * 4 
    j comandos

apaga_personagem:
    sub $t0, $t0, 1
    sw $zero, 0($t3)
    addi $t3, $t3, 4
    bgt $t0, $zero, apaga_personagem
    jr $ra

comandos:
    li $v0, 32 #
    li $a0, 10 # comando de sleep de 10 ms, valor em $a0, e o tempo do sleep em ms
    syscall    #

    li $t0, 12 # reinicia valor do tamanho da cobra

leitura_teclado:   
    lw $t7, 0($t5) #le o dado de controle do keyboard       
    beqz $t7, comandos # 0 = nada, le dnv, != 0 segue)
    lw $t2, 0($t6) # le o conteudo escrito convertido em valor ascii

    beq $t2, 115, baixo 
    beq $t2, 100, direita
    beq $t2, 97, esquerda
    beq $t2, 119, cima 
    j comandos           

#sendo bem sincero, to meio da aula de estatistica escrevendo isso
#so le oque cada comando faz com os valores dos ponteiros e interpreta na tua cabeca
#so lembra que o display tem 512 de width e cada pixel tem 8 bits e a referencia da cobra e sua "ponta"
#logo, (locomocao do ponteiro +- 48) deve ser levado em conta

cima:
    jal apaga_personagem
    li $t0, 12
    sub $t1, $t1, 4144
    j set_personagem    

baixo:
    jal apaga_personagem
    li $t0, 12
    addi $t1, $t1, 4048
    j set_personagem

direita:
    jal apaga_personagem
    li $t0, 12
    addi $t1, $t1, 48
    j set_personagem
    
esquerda:
    jal apaga_personagem
    li $t0, 12
    sub $t1, $t1, 96
    j set_personagem
