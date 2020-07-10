#ASC1 * 2016/2017 * Universidade de Évora
#Criado por:
#Luís Rosado - 34249
#Daniel Soares - 34222		
.data
	question: .asciiz "Qual o nome do ficheiro?: "
	wrongfile: .asciiz "\nNome de ficheiro incorrecto! "
	readfile: .space 32
	savefile: .space 32
	originalbuffer: .space 786432
	graybuffer: .space 262144
	h_sobel: .byte 1, 0, -1, 2, 0, -2, 1, 0, -1
	h_sobelbuffer: .space 262144
	v_sobel: .byte 1, 2, 1, 0, 0, 0, -1, -2, -1
	v_sobelbuffer: .space 262144
	contourbuffer: .space 262144

.text
#################################################
#main - Função Main, esta funçao prepara os argumentos e chama as funções que fazem as operações.
#
#Argmentos:
# Nenhum
#
#Retorna:
# Nada
#################################################
main:
	jal ask_filename
	nop 
	
	la $a0, readfile
	jal read_rgb_image
	nop
	
	la $a0, originalbuffer
	la $a1, graybuffer
	jal rgb_to_gray
	nop
	
	la $a0, graybuffer
	la $a1, h_sobel
	la $a2, h_sobelbuffer
	jal convolution
	nop
	
	la $a0, graybuffer
	la $a1, v_sobel
	la $a2, v_sobelbuffer
	jal convolution
	nop
	
	la $a0, h_sobelbuffer
	la $a1, v_sobelbuffer
	la $a2, contourbuffer
	jal contour
	nop
	
	la $a0, savefile
	la $a1, contourbuffer
	li $a2, 262144
	jal write_gray_image
	nop
	
	li $v0, 10
	syscall
	
#################################################
#ask_filename - Esta função pede o nome do ficheiro a ler.
#
#Argmentos:
# Nenhum
#
#Retorna:
# Nada
#################################################
ask_filename:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	#Pede nome do ficheiro
ask3:	la $a0, question
	li $v0, 4
	syscall	
	
	#Guarda o input
	la $a0, readfile
	li $a1, 32
	li $v0, 8
	syscall	
	
	#Retira o caracter \n "new line"
	addi $t0, $a0, 32
ask1:	lb $t1, 0($a0)
	beq $a0, $t0, ask2
	nop
	bne $t1, 10, ask1
	addi $a0, $a0, 1
	li $t1, 0
	sb $t1, -1($a0)
ask2:	
	
	#Tenta abrir o ficheiro
	la $a0, readfile
	li $a1, 0
	li $a2, 0
	li $v0, 13
	syscall	
	
	#Se falhar pede nome novamente
	bne $v0, -1, ask4
	nop
	la $a0, wrongfile
	li $v0, 4
	syscall	
	j ask3
	nop

ask4:	
	#Fecha o ficheiro
	move $a0, $v0
	li $v0, 16
	syscall
	
	la $a0, readfile
	la $a1, savefile
	jal writefilename
	nop
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	nop
	
#################################################
#writefilename- Esta função copia o nome com a extensão correcta para ser usado como nome de ficheiro de saida.
#
#Argmentos:
# a0 - Nome do ficheiro lido
# 01 - Nome do ficheiro a escrever
#
#Retorna:
# Nada	
#################################################
writefilename:
	#Copia os caracteres 
	addi $t1, $a0, 26
write1:	lb $t2, 0($a0)
	sb $t2, 0($a1)
	
	#Verifica se chegou ao caracter "." ou ao limite para escrever ".gray\0"
	beq $a0, $t1, write2
	nop
	beq $t2, 46, write2
	nop
	
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j write1
	nop
	
write2:
	#Acrescenta a extensao .gray
	li $t1, 46 #.
	sb $t1, 0($a1)
	li $t1, 71 #G
	sb $t1, 1($a1)
	li $t1, 82 #R
	sb $t1, 2($a1)
	li $t1, 65 #A
	sb $t1, 3($a1)
	li $t1, 89 #Y
	sb $t1, 4($a1)
	li $t1, 0 #\0
	sb $t1, 5($a1)

	jr $ra
	nop

#################################################
#read_rgb_image - Esta função lê um ficheiro de imagem .rgb guarda-a num buffer em memória.
#
#Argmentos:
# a0 - Nome do ficheiro
#
#Retorna:
# v0 - Buffer com imagem
#################################################
read_rgb_image:	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	#Abre o ficheiro	
	li $a1, 0
	li $a2, 0
	li $v0, 13
	syscall	
	
	#Lê o ficheiro
	move $a0, $v0
	la $a1, originalbuffer
	li $a2 786432
	li $v0, 14
	syscall
	
	#Fecha o ficheiro
	li $v0, 16
	syscall
	
	move $v0, $a1
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	nop
	
#################################################
#rgb_to_gray - Esta função lê um buffer com uma imagem .RGB (a cores) e transforma-a em .GRAY guardada noutro buffer.
#
#Argmentos:
# a0 - Buffer com imagem RGB
# a1 - Buffer de destino
#
#Retorna:
# Nada
#################################################
rgb_to_gray:
	#Final do buffer com a imagem original
	addi $t5, $a0, 786432 
	
	#Ler bytes das cores
l1:	lbu $t0, 0($a0)
	lbu $t1, 1($a0)
	lbu $t2, 2($a0)
	
	#Calculo do valor
	mul $t3, $t0, 30
	mul $t4, $t1, 59
	add $t3, $t3, $t4
	mul $t4, $t2, 11
	add $t3, $t3, $t4
	div $t3, $t3, 100
	
	#Guardar byte calculado
	sb $t3, 0($a1)
	addi $a0, $a0, 3
	addi $a1, $a1, 1
	
	#Repetir até ao final do Array
	bne $a0, $t5, l1
	nop
	jr $ra
	nop

#################################################
#convolution - Esta função calcula a convulução da imagem com um operador Sobel
#
#Argmentos:
# a0 - Buffer com imagem
# a1 - Array com o operador Sobel
# a2 -  Buffer com imagem filtrada
#
#Retorna:
# Nada
#################################################
convolution:
	#1ª linha, 1º pixel
	add $t0, $zero, $zero #Somador
	lbu $t1, 512($a0)
	lb $t2, 7($a1)
	mul $t3, $t1, $t2
	add $t0, $t0, $t3
	lbu $t1, 1($a0)
	lb $t2, 5($a1)
	mul $t3, $t1, $t2
	add $t0, $t0, $t3
	lbu $t1, 513($a0)
	lb $t2, 8($a1)
	mul $t3, $t1, $t2
	add $t0, $t0, $t3
	
	abs $t0, $t0
	div $t0, $t0, 4
	sb $t0, 0($a2)
	
	#Próximo pixel
	addi $a0, $a0, 1
	addi $a2, $a2, 1
	
	#1ª linha, pixeis intermedios
	add $t0, $zero, $zero #Contador
conv1:	add $t1, $zero, $zero #Somador
	lbu $t2, -1($a0)
	lb $t3, 3($a1)
	mul $t4, $t2, $t3
	add $t1, $t1, $t4
	lbu $t2, 511($a0)
	lb $t3, 6($a1)
	mul $t4, $t2, $t3
	add $t1, $t1, $t4
	lbu $t2, 512($a0)
	lb $t3, 7($a1)
	mul $t4, $t2, $t3
	add $t1, $t1, $t4
	lbu $t2, 513($a0)
	lb $t3, 8($a1)
	mul $t4, $t2, $t3
	add $t1, $t1, $t4
	lbu $t2, 1($a0)
	lb $t3, 5($a1)
	mul $t4, $t2, $t3
	add $t1, $t1, $t4
	
	abs $t1, $t1
	div $t1, $t1, 4
	sb $t1, 0($a2)
	
	#Próximo pixel
	addi $a0, $a0, 1
	addi $a2, $a2, 1
	addi $t0, $t0, 1
	
	bne $t0, 510, conv1
	nop
	
	#1ª linha, ultimo pixel
	add $t0, $zero, $zero #Somador
	lbu $t1, -1($a0)
	lb $t2, 3($a1)
	mul $t3, $t1, $t2
	add $t0, $t0, $t3
	lbu $t1, 511($a0)
	lb $t2, 6($a1)
	mul $t3, $t1, $t2
	add $t0, $t0, $t3
	lbu $t1, 512($a0)
	lb $t2, 7($a1)
	mul $t3, $t1, $t2
	add $t0, $t0, $t3
	
	abs $t0, $t0
	div $t0, $t0, 4
	sb $t0, 0($a2)
	
	#Próximo pixel
	addi $a0, $a0, 1
	addi $a2, $a2, 1
	
	#Linhas intermédias, 1º pixel
	add $t0, $zero, $zero #Contador linhas
		
conv3:	add $t2, $zero, $zero #Somador
	
	lbu $t3, -512($a0)
	lb $t4, 1($a1)
	mul $t5, $t3, $t4
	add $t2, $t2, $t5
	lbu $t3, -511($a0)
	lb $t4, 2($a1)
	mul $t5, $t3, $t4
	add $t2, $t2, $t5
	lbu $t3, 1($a0)
	lb $t4, 5($a1)
	mul $t5, $t3, $t4
	add $t2, $t2, $t5
	lbu $t3, 512($a0)
	lb $t4, 7($a1)
	mul $t5, $t3, $t4
	add $t2, $t2, $t5
	lbu $t3, 513($a0)
	lb $t4, 8($a1)
	mul $t5, $t3, $t4
	add $t2, $t2, $t5
	
	abs $t2, $t2
	div $t2, $t2, 4
	sb $t2, 0($a2)
	
	#Próximo pixel
	addi $a0, $a0, 1
	addi $a2, $a2, 1
	
	#Linhas intermédias, pixeis intermédios
	add $t1, $zero, $zero #Contador pixel linha	
	
conv2:	add $t2, $zero, $zero #Somador
	
	lbu $t3, -513($a0)
	lb $t4, 0($a1)
	mul $t5, $t3, $t4
	add $t2, $t2, $t5
	lbu $t3, -512($a0)
	lb $t4, 1($a1)
	mul $t5, $t3, $t4
	add $t2, $t2, $t5
	lbu $t3, -511($a0)
	lb $t4, 2($a1)
	mul $t5, $t3, $t4
	add $t2, $t2, $t5
	lbu $t3, -1($a0)
	lb $t4, 3($a1)
	mul $t5, $t3, $t4
	add $t2, $t2, $t5
	lbu $t3, 1($a0)
	lb $t4, 5($a1)
	mul $t5, $t3, $t4
	add $t2, $t2, $t5
	lbu $t3, 511($a0)
	lb $t4, 6($a1)
	mul $t5, $t3, $t4
	add $t2, $t2, $t5
	lbu $t3, 512($a0)
	lb $t4, 7($a1)
	mul $t5, $t3, $t4
	add $t2, $t2, $t5
	lbu $t3, 513($a0)
	lb $t4, 8($a1)
	mul $t5, $t3, $t4
	add $t2, $t2, $t5
	
	abs $t2, $t2
	div $t2, $t2, 4
	sb $t2, 0($a2)
	
	#Próximo pixel
	addi $a0, $a0, 1
	addi $a2, $a2, 1
	addi $t1, $t1, 1
	
	bne $t1, 510, conv2
	nop
	
	#Linhas intermédias, ultimo pixel
	
	add $t2, $zero, $zero #Somador
	
	lbu $t3, -512($a0)
	lb $t4, 1($a1)
	mul $t5, $t3, $t4
	add $t2, $t2, $t5
	lbu $t3, -513($a0)
	lb $t4, 0($a1)
	mul $t5, $t3, $t4
	add $t2, $t2, $t5
	lbu $t3, -1($a0)
	lb $t4, 3($a1)
	mul $t5, $t3, $t4
	add $t2, $t2, $t5
	lbu $t3, 511($a0)
	lb $t4, 6($a1)
	mul $t5, $t3, $t4
	add $t2, $t2, $t5
	lbu $t3, 512($a0)
	lb $t4, 7($a1)
	mul $t5, $t3, $t4
	add $t2, $t2, $t5
	
	abs $t2, $t2
	div $t2, $t2, 4
	sb $t2, 0($a2)
	
	#Próximo pixel
	addi $a0, $a0, 1
	addi $a2, $a2, 1
	addi $t0, $t0, 1
	
	bne $t0, 510, conv3
	nop
	
	#Ultima linha, 1º pixel
	add $t0, $zero, $zero #Somador
	lbu $t1, -512($a0)
	lb $t2, 1($a1)
	mul $t3, $t1, $t2
	add $t0, $t0, $t3
	lbu $t1, -511($a0)
	lb $t2, 2($a1)
	mul $t3, $t1, $t2
	add $t0, $t0, $t3
	lbu $t1, 1($a0)
	lb $t2, 5($a1)
	mul $t3, $t1, $t2
	add $t0, $t0, $t3
	
	abs $t0, $t0
	div $t0, $t0, 4
	sb $t0, 0($a2)
	
	#Próximo pixel
	addi $a0, $a0, 1
	addi $a2, $a2, 1
	
	#Ultima linha, pixeis intermedios
	add $t0, $zero, $zero #Contador
conv4:	add $t1, $zero, $zero #Somador
	lbu $t2, -1($a0)
	lb $t3, 3($a1)
	mul $t4, $t2, $t3
	add $t1, $t1, $t4
	lbu $t2, -513($a0)
	lb $t3, 0($a1)
	mul $t4, $t2, $t3
	add $t1, $t1, $t4
	lbu $t2, -512($a0)
	lb $t3, 1($a1)
	mul $t4, $t2, $t3
	add $t1, $t1, $t4
	lbu $t2, -511($a0)
	lb $t3, 2($a1)
	mul $t4, $t2, $t3
	add $t1, $t1, $t4
	lbu $t2, 1($a0)
	lb $t3, 5($a1)
	mul $t4, $t2, $t3
	add $t1, $t1, $t4
	
	abs $t1, $t1
	div $t1, $t1, 4
	sb $t1, 0($a2)
	
	#Próximo pixel
	addi $a0, $a0, 1
	addi $a2, $a2, 1
	addi $t0, $t0, 1
	
	bne $t0, 510, conv4
	nop
	
	#Ultima linha, ultimo pixel
	add $t0, $zero, $zero #Somador
	lbu $t1, -1($a0)
	lb $t2, 3($a1)
	mul $t3, $t1, $t2
	add $t0, $t0, $t3
	lbu $t1, -513($a0)
	lb $t2, 0($a1)
	mul $t3, $t1, $t2
	add $t0, $t0, $t3
	lbu $t1, -512($a0)
	lb $t2, 1($a1)
	mul $t3, $t1, $t2
	add $t0, $t0, $t3
	
	abs $t0, $t0
	div $t0, $t0, 4
	sb $t0, 0($a2)
	
	jr $ra
	nop

#################################################
#contour - Esta função faz o contour da imagem
#Argmentos:
# a0 - Buffer do operador horizontal
# a1 - Bufer do operador vertical
# a2 - Buffer da imagem final
#
#Retorna:
# Nada
#################################################				
contour:
	addi $t3, $zero, 240 #Valor que comanda o contraste da imagem
	addi $t4, $a0, 262144
	
	#Lê os pixeis de cada buffer e calcula o resultado
con1:	lbu $t0, 0($a0)
	lbu $t1, 0($a1)
	add $t2, $t0, $t1
	div $t2, $t2, 2
	sub $t2, $t3, $t2
	sb $t2, 0($a2)
	
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	addi $a2, $a2, 1
	bne $a0, $t4, con1
	nop
	
	jr $ra
	nop
	
#################################################
#write_gray_image - Esta função lê um buffer com a imagem em memória e guarda-a num ficheiro de imagem .GRAY
#
#Argmentos:
# a0 - Nome do ficheiro
# a1 - Nome do Buffer
# a2 - Tamanho do Buffer
#
#Retorna:
# Nada
#################################################
write_gray_image:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	
	#Abre o ficheiro para escrita
	li $a1, 1
	li $a2, 0x1ff
	li $v0, 13
	syscall
	
	#Escreve dados no ficheiro
	move $a0, $v0
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	li $v0, 15
	syscall
	
	#Fecha o ficheiro
	li $v0, 16
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra
	nop	
