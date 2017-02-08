# Versión incompleta del tetris 
# Sincronizada con tetris.s:r2269
        
	.data	

	.align	2
pantalla:
	.word	0
	.word	0
	.space	1024

	.align	2
campo:
	.word	0
	.word	0
	.space	1024

	.align	2
pieza_actual:
	.word	0
	.word	0
	.space	1024

	.align 2
pieza_actual_x:
	.word 0

pieza_actual_y:
	.word 0

	.align	2
imagen_auxiliar:
	.word	0
	.word	0
	.space	1024

	.align	2
pieza_jota:
	.word	2
	.word	3
	.ascii		"\0*\0***\0\0"

	.align	2
pieza_ele:
	.word	2
	.word	3
	.ascii		"*\0*\0**\0\0"

	.align	2
pieza_barra:
	.word	1
	.word	4
	.ascii		"****\0\0\0\0"

	.align	2
pieza_zeta:
	.word	3
	.word	2
	.ascii		"**\0\0**\0\0"

	.align	2
pieza_ese:
	.word	3
	.word	2
	.ascii		"\0****\0\0\0"

	.align	2
pieza_cuadro:
	.word	2
	.word	2
	.ascii		"****\0\0\0\0"

	.align	2
pieza_te:
	.word	3
	.word	2
	.ascii		"\0*\0***\0\0"

	.align	2
piezas:
	.word	pieza_jota
	.word	pieza_ele
	.word	pieza_zeta
	.word	pieza_ese
	.word	pieza_barra
	.word	pieza_cuadro
	.word	pieza_te

acabar_partida:
	.byte	0

	.align	2
procesar_entrada.opciones:
	.byte	'x'
	.space	3
	.word	tecla_salir
	.byte	'j'
	.space	3
	.word	tecla_izquierda
	.byte	'l'
	.space	3
	.word	tecla_derecha
	.byte	'k'
	.space	3
	.word	tecla_abajo
	.byte	'i'
	.space	3
	.word	tecla_rotar

str000:
	.asciiz		"Tetris\n\n 1 - Jugar\n 2 - Salir\n\nElige una opción:\n"
str001:
	.asciiz		"\n¡Adiós!\n"
str002:
	.asciiz		"\nOpción incorrecta. Pulse cualquier tecla para seguir.\n"
barra:
	.asciiz		"-"
puntuacion:
	.asciiz		"Puntuacion "
puntos_puntuacion:
	.word 		0

	.text	
####################################################################################
imagen_pixel_addr:			# ($a0, $a1, $a2) = (imagen, x, y)
					# pixel_addr = &data + y*ancho + x
    	lw	$t1, 0($a0)		# $a0 = dirección de la imagen 
					# $t1 �? ancho
    	mul	$t1, $t1, $a2		# $a2 * ancho
    	addu	$t1, $t1, $a1		# $a2 * ancho + $a1
    	addiu	$a0, $a0, 8		# $a0 �? dirección del array data
    	addu	$v0, $a0, $t1		# $v0 = $a0 + $a2 * ancho + $a1
    	jr	$ra
####################################################################################
imagen_get_pixel:			# ($a0, $a1, $a2) = (img, x, y)
	addiu	$sp, $sp, -4 
	sw	$ra, 0($sp)		# guardamos $ra porque haremos un jal
	jal	imagen_pixel_addr	# (img, x, y) ya en ($a0, $a1, $a2)
	lbu	$v0, 0($v0)		# lee el pixel a devolver
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra
####################################################################################
imagen_set_pixel:			#($a0, $a1, $a2, $a3) = (img, x, y, color)
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)	#APILO
	
	jal 	imagen_pixel_addr
	sb	$a3, 0($v0)
	
	lw	$ra, 0($sp) 	#DESAPILO
	addiu	$sp, $sp, 4
	jr 	$ra
####################################################################################
imagen_clean: 			#($a0, $a1) = (img, fondo)
	addiu	$sp, $sp, -20
	sw	$ra, 0($sp)	#APILO
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	
	move	$s0, $a0	#IMG
	move	$s1, $a1	#FONDO
	############# FOR Y ##############
	li	$s2, 0 		# Y = 0
for_y:
	lw	$t0, 4($s0)	#ALTO
	bge	$s2, $t0, fin_for_y	# Y < img->alto
	############# FOR X ##############
	li	$s3, 0 		# X = 0
for_x:
	lw	$t1, 0($s0)	#ANCHO
	bge	$s3, $t1, fin_for_x	# X < img->ancho
	#########################
	move	$a0, $s0	#GUARDO LA IMG
	move	$a1, $s3	#GUARDO LA X
	move	$a2, $s2	#GUARDO LA Y
	move	$a3, $s1	#GUARDO el FONDO
	jal	imagen_set_pixel
	#########################
	addi	$s3, $s3, 1	#++x
	j	for_x
fin_for_x:
	addi	$s2, $s2, 1	#++y
	j	for_y
fin_for_y:
	lw	$ra, 0($sp) 	#DESAPILO
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	addiu	$sp, $sp, 20
	jr 	$ra
####################################################################################        
imagen_init:			#($a0, $a1, $a2, $a3) = (img, ancho, alto, fondo)	#FIXME
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)	#APILO

	sw	$a1, 0($a0)	#img->ancho
	sw	$a2, 4($a0)	#img->alto
	move	$a1, $a3	# SOLO PONGO EL SEGUNDO PAR�METRO PORQUE EL PRIMERO YA LO LLAMO CUANDO HAGO EL SW
	jal	imagen_clean	#imagen_clean(img, fondo)
	
	lw	$ra, 0($sp)	#DESAPILO
	addiu	$sp, $sp, 4
	jr	$ra
####################################################################################
imagen_copy: 	#MIRAR IMAGEN PRINT	#($a0, $a1) = (*dst, *src)	# CORREGIDO
	addiu	$sp, $sp, -20
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	
	move	$s0, $a0	#	*dst
	move	$s1, $a1	#	*src
	
	lw	$t0, 0($s1)	# SRC->ANCHO
	sw	$t0, 0($s0)	# dst->ancho = src->ancho;
	lw	$t1, 4($s1)	# SRC->ALTO
	sw	$t1, 4($s0)	# dst->alto = src->alto;
	####### FOR Y
	li	$s2, 0	# y = 0
for_y2:	
	lw	$t2, 4($s1)
	bge 	$s2, $t2, fin_for_y2	# Y < SRC->ALTO
	
	####### FOR X
	li	$s3, 0	# x = 0
for_x2:
	lw	$t3, 0($s1)
	bge	$s3, $t3, fin_for_x2	# X < SRC->ANCHO
	###############################	FOR {	FOR {
	move	$a0, $s1		# src
	move	$a1, $s3		# x	
	move	$a2, $s2		# y
	jal	imagen_get_pixel
	
	move	$a0, $s0	# dst
	move	$a1, $s3	# x
	move	$a2, $s2	# y
	move	$a3, $v0	#Pixel p
	jal	imagen_set_pixel
	###############################	}	}
	addi	$s3, $s3, 1	#++x
	j	for_x2
fin_for_x2:
	addi	$s2, $s2, 1	#++y
	j	for_y2
fin_for_y2:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	addiu	$sp, $sp, 20
	jr	$ra
####################################################################################	
imagen_print:				# $a0 = img
	addiu	$sp, $sp, -16
	sw	$ra, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	
	move	$s0, $a0
        #  for (int y = 0; y < img->alto; ++y)
	lw	$t1, 4($s0)		# img->alto
	beqz	$t1, B6_5
	li	$s1, 0			# y = 0
	#    for (int x = 0; x < img->ancho; ++x)
B6_2:	lw	$t1, 0($s0)		# img->ancho
	beqz	$t1, B6_4
	li	$s2, 0			# x = 0
B6_3:	move	$a0, $s0		# Pixel p = imagen_get_pixel(img, x, y)
	move	$a1, $s2
	move	$a2, $s1
	jal	imagen_get_pixel
	move	$a0, $v0		# print_character(p)
	jal	print_character
	addiu	$s2, $s2, 1		# ++x
	lw	$t1, 0($s0)		# img->ancho
	bltu	$s2, $t1, B6_3		# sigue si x < img->ancho
	#    } // for x
B6_4:	li	$a0, 10			# print_character('\n')
	jal	print_character
	addiu	$s1, $s1, 1		# ++y
	lw	$t1, 4($s0)		# img->alto
	bltu	$s1, $t1, B6_2		# sigue si y < img->alto
	#  } // for y
B6_5:	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$ra, 12($sp)
	addiu	$sp, $sp, 16
	jr	$ra
####################################################################################
imagen_dibuja_imagen:		#($a0, $a1, $a2, $a3) = (dst, src, dst_x, dst_y)
	addiu	$sp, $sp, -28
	sw	$ra, 0($sp)	#APILO
	sw	$s0, 4($sp)	
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	sw	$s5, 24($sp)
	
	move	$s0, $a0	#	*dst
	move	$s1, $a1	#	*src
	move	$s4, $a2	# dst_x
	move	$s5, $a3	# dst_y
	
	#	FOR Y
	li	$s2, 0	# Y = 0
for_y3:
	lw	$t0, 4($s1)
	bge	$s2, $t0, fin_for_y3

	#	FOR X
	li	$s3, 0	# X = 0
for_x3:
	lw	$t1, 0($s1)
	bge	$s3, $t1, fin_for_x3
	
	###################################
	move	$a0, $s1	# src
	move	$a1, $s3	# x
	move	$a2, $s2	# y
	jal	imagen_get_pixel
	######### 	IF	##############
if:
	beq	$v0, $zero, fin_if #	IF(P != PIXEL_VACIO)
	#	{
	move	$a0, $s0	# dst
	add 	$a1, $s4, $s3	# dst_x + x
	add	    $a2, $s5, $s2	# dst_y + y
	move	$a3, $v0 	# p
	jal	imagen_set_pixel
	#	}
	###################################

fin_if:
	addi	$s3, $s3, 1	# ++X
	j	for_x3
fin_for_x3:
	addi	$s2, $s2, 1	# ++Y
	j	for_y3
fin_for_y3:
	lw	$ra, 0($sp)	#DESAPILO
	lw	$s0, 4($sp)	
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	lw	$s5, 24($sp)
	addiu	$sp, $sp, 28
	jr	$ra
####################################################################################
imagen_dibuja_imagen_rotada:  	#($a0, $a1, $a2, $a3) = (dst, src, dst_x, dst_y)
	addiu	$sp, $sp, -28
	sw	$ra, 0($sp)	#APILO
	sw	$s0, 4($sp)	
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	sw	$s5, 24($sp)
	
	move	$s0, $a0	# *dst
	move	$s1, $a1	# *src
	move	$s2, $a2	# dst_x
	move	$s3, $a3	# dst_y
	
	#	FOR Y
	li	$s4, 0	# Y = 0
for_y4:
	lw	$t0, 4($s1)	# src->alto
	bge	$s4, $t0, fin_for_y4

	#	FOR X
	li	$s5, 0	# X = 0
for_x4:
	lw	$t1, 0($s1)	# src->ancho
	bge	$s5, $t1, fin_for_x4
	
	
	###################################
	move	$a0, $s1	# src
	move	$a1, $s5	# x
	move	$a2, $s4	# y
	jal	imagen_get_pixel
	######### 	IF	##############
if4:
	beq	$v0, $zero, fin_if4 #	IF(P != PIXEL_VACIO)
	#	{
	move	$a0, $s0	# dst
	lw	    $t0, 4($s1)	# dst_x + src->alto
	add     $a1, $t0, $s2
	addi	$a1, $a1, -1    # dst_x + src->alto - 1
	sub	    $a1, $a1, $s4	# dst_x + src->alto - 1 - y
	add	    $a2, $s3, $s5	# dst_y  + x
	move	$a3, $v0 	# p
	jal	imagen_set_pixel
	#	}
	###################################

fin_if4:
	addi	$s5, $s5, 1	# ++X
	j	for_x4
fin_for_x4:
	addi	$s4, $s4, 1	# ++Y
	j	for_y4
fin_for_y4:
	lw	$ra, 0($sp)	#DESAPILO
	lw	$s0, 4($sp)	
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	lw	$s5, 24($sp)
	addiu	$sp, $sp, 28
	jr	$ra
####################################################################################
pieza_aleatoria:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	li	$a0, 0
	li	$a1, 7
	jal	random_int_range	# $v0 �? random_int_range(0, 7)
	sll	$t1, $v0, 2
	la	$v0, piezas
	addu	$t1, $v0, $t1		# $t1 = piezas + $v0*4
	lw	$v0, 0($t1)		# $v0 �? piezas[$v0]
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra
####################################################################################
actualizar_pantalla:
	addiu	$sp, $sp, -16
	sw	$ra, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	
	la	$s0, pantalla
	la	$s2, campo
	move	$a0, $s0
	li	$a1, ' '
	jal	imagen_clean		# imagen_clean(pantalla, ' ')
        # for (int y = 0; y < campo->alto; ++y) {
	lw	$t1, 4($s2)		# campo->alto
	beqz	$t1, B10_3		# sale del bucle si campo->alto == 0
	li	$s1, 0			# y = 0
B10_2:	addiu	$s1, $s1, 1		# ++y
	move	$a0, $s0
	li	$a1, 0 
	move	$a2, $s1
	li	$a3, '|'
	jal	imagen_set_pixel	# imagen_set_pixel(pantalla, 0, y, '|')
	lw	$t1, 0($s2)		# campo->ancho
	move	$a0, $s0
	addiu	$a1, $t1, 1		# campo->ancho + 1
	move	$a2, $s1
	li	$a3, '|'
	jal	imagen_set_pixel	# imagen_set_pixel(pantalla, campo->ancho + 1, y, '|')
	lw	$t1, 4($s2)		# campo->alto
	bltu	$s1, $t1, B10_2		# sigue si y < campo->alto
        # } // for y
	# for (int x = 0; x < campo->ancho + 2; ++x) { 
B10_3:	li	$s1, 0			# x = 0
B10_5:	lw	$t1, 4($s2)		# campo->alto
	move	$a0, $s0
	move	$a1, $s1
	addiu	$a2, $t1, 1		# campo->alto + 1
	li	$a3, '-'
	jal	imagen_set_pixel	# imagen_set_pixel(pantalla, x, campo->alto + 1, '-')
	addiu	$s1, $s1, 1		# ++x
	lw	$t1, 0($s2)		# campo->ancho
	addiu	$t1, $t1, 2		# campo->ancho + 2
	bltu	$s1, $t1, B10_5		# sigue si x < campo->ancho + 2
        # } // for x
B10_6:	la	$s0, pantalla
	move	$a0, $s0
	move	$a1, $s2
	li	$a2, 1
	li	$a3, 1
	jal	imagen_dibuja_imagen	# imagen_dibuja_imagen(pantalla, campo, 1, 1)
	lw	$t1, pieza_actual_y
	lw	$v0, pieza_actual_x
	move	$a0, $s0
	la	$a1, pieza_actual
	addiu	$a2, $v0, 1		# pieza_actual_x + 1
	addiu	$a3, $t1, 1		# pieza_actual_y + 1
	jal	imagen_dibuja_imagen	# imagen_dibuja_imagen(pantalla, pieza_actual, pieza_actual_x + 1, pieza_actual_y + 1)
	jal	clear_screen		# clear_screen()
	move	$a0, $s0
	jal	imagen_print		# imagen_print(pantalla)
	
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$ra, 12($sp)
	addiu	$sp, $sp, 16
	jr	$ra
####################################################################################
nueva_pieza_actual:		
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)	# APILO
	
	jal 	pieza_aleatoria
	########################
	la	$a0, pieza_actual
	move	$a1, $v0
	jal	imagen_copy
	########################
	li	$t0, 8	
	sw	$t0, pieza_actual_x	# pieza_actual_x = 8	
	li 	$t1, 0	
	sw	$t1, pieza_actual_y	# pieza_actual_y = 0	
	
	lw	$ra, 0($sp)	# DESAPILO
	addiu	$sp, $sp, 4
	jr	$ra
####################################################################################
probar_pieza:				# ($a0, $a1, $a2) = (pieza, x, y)
	addiu	$sp, $sp, -32
	sw	$ra, 28($sp)
	sw	$s7, 24($sp)
	sw	$s6, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	move	$s0, $a2		# y
	move	$s1, $a1		# x
	move	$s2, $a0		# pieza
	li	$v0, 0
	bltz	$s1, B12_13		# if (x < 0) return false
	lw	$t1, 0($s2)		# pieza->ancho
	addu	$t1, $s1, $t1		# x + pieza->ancho
	la	$s4, campo
	lw	$v1, 0($s4)		# campo->ancho
	bltu	$v1, $t1, B12_13	# if (x + pieza->ancho > campo->ancho) return false
	bltz	$s0, B12_13		# if (y < 0) return false
	lw	$t1, 4($s2)		# pieza->alto
	addu	$t1, $s0, $t1		# y + pieza->alto
	lw	$v1, 4($s4)		# campo->alto
	bltu	$v1, $t1, B12_13	# if (campo->alto < y + pieza->alto) return false
	# for (int i = 0; i < pieza->ancho; ++i) {
	lw	$t1, 0($s2)		# pieza->ancho
	beqz	$t1, B12_12
	li	$s3, 0			# i = 0
	#   for (int j = 0; j < pieza->alto; ++j) {
	lw	$s7, 4($s2)		# pieza->alto
B12_6:	beqz	$s7, B12_11
	li	$s6, 0			# j = 0
B12_8:	move	$a0, $s2
	move	$a1, $s3
	move	$a2, $s6
	jal	imagen_get_pixel	# imagen_get_pixel(pieza, i, j)
	beqz	$v0, B12_10		# if (imagen_get_pixel(pieza, i, j) == PIXEL_VACIO) sigue
	move	$a0, $s4
	addu	$a1, $s1, $s3		# x + i
	addu	$a2, $s0, $s6		# y + j
	jal	imagen_get_pixel
	move	$t1, $v0		# imagen_get_pixel(campo, x + i, y + j)
	li	$v0, 0
	bnez	$t1, B12_13		# if (imagen_get_pixel(campo, x + i, y + j) != PIXEL_VACIO) return false
B12_10:	addiu	$s6, $s6, 1		# ++j
	bltu	$s6, $s7, B12_8		# sigue si j < pieza->alto
        #   } // for j
B12_11:	lw	$t1, 0($s2)		# pieza->ancho
	addiu	$s3, $s3, 1		# ++i
	bltu	$s3, $t1, B12_6 	# sigue si i < pieza->ancho
        # } // for i
B12_12:	li	$v0, 1			# return true
B12_13:	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s6, 20($sp)
	lw	$s7, 24($sp)
	lw	$ra, 28($sp)
	addiu	$sp, $sp, 32
	jr	$ra
####################################################################################
intentar_movimiento:		# ($a0, $a1) = (X, Y)
	#	$v0 = 1 -> TRUE
	#	$v0 = 0 -> FALSE
	addiu	$sp, $sp, -16
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	
	move 	$s0, $a0	# X
	move	$s1, $a1        # Y
	
	la 	$a0, pieza_actual	# PREGUNTAR SI HAY QUE HACER MOVE ANTES DEL JAL PARA ASIGNAR PARAMETROS
	move    $a1, $s0
	move    $a2, $s1
	jal	probar_pieza
	############# 	 IF   ####################	{
if5:		
	beqz	$v0, fin_if5	# return true # ��PUEDE SER BNEZ??
	sw	$s0, pieza_actual_x
	sw	$s1, pieza_actual_y

fin_if5:	
	#############  FIN IF  ##################	}
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	addiu	$sp, $sp, 16
	jr	$ra
####################################################################################
bajar_pieza_actual:		#PREGUNTAR
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)	# APILAR
	
	lw	$a0, pieza_actual_x
	lw	$a1, pieza_actual_y
	addi	$a1, $a1, 1
	jal 	intentar_movimiento
	######## IF  #############
if6:
	bnez	$v0, fin_if6		# ��PUEDE SER BEQZ??
	la	$a0, campo
	la	$a1, pieza_actual
	lw	$a2, pieza_actual_x
	lw	$a3, pieza_actual_y
	jal	imagen_dibuja_imagen	#imagen_dibuja_imagen(a,b,c,d)
	jal	nueva_pieza_actual	#nueva_pieza_actual
	
fin_if6:
	######## FIN IF ###########
	lw	$ra, 0($sp)	# DESAPILAR
	addiu	$sp, $sp, 4
	jr	$ra
####################################################################################
intentar_rotar_pieza_actual:		 ## OJOOO PREGUNTAR ESTA
	addiu	$sp, $sp, -8
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	
	### PREGUNTAR SI ESTA BIEN
	la	$s0, imagen_auxiliar	# PIEZA ROTADA - PIEZA ACTUAL ��SE PUEDE HACER AS�?
	# la	$v0, imagen_auxiliar	# 1ª LINEA
	
	#la	$a0, imagen_auxiliar	# 2ª LINEA # pieza_rotada
	move 	$a0, $s0	# pieza_rotada
	la	$a1, 0($s0)	# pieza_actual->ancho
	la	$a2, 4($s0)	# pieza_actual->alto
	move	$a3, $zero	# PIXEL_VACIO
	jal	imagen_init
	
	la	$a0, imagen_auxiliar	# 3ª LINEA
	la	$a1, pieza_actual
	li	$a2, 0
	li	$a3, 0		
	jal	imagen_dibuja_imagen_rotada
	
if_7:
	beqz	$v0, fin_if7		# 4ª LINEA
	la	$a0, imagen_auxiliar
	lw	$a1, pieza_actual_x
	lw	$a2, pieza_actual_y
	jal 	probar_pieza
	
	la	$a0, pieza_actual	# 5ª LINEA
	la	$a1, imagen_auxiliar
	jal	imagen_copy
	
fin_if7:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	addiu	$sp, $sp, 8
	jr	$ra
####################################################################################
################## NUEVAS FUNCIONES ##############################
####################################################################################
marcador_puntuacion:
	addiu	$sp, $sp, -8
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)

	la	$s0, nueva_pieza_actual
while:
	beq	$s0, $zero, fin_while
	move	$t0, $v0
	addi	$t0, $t0, 1
fin_while:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	addiu	$sp, $sp, 8
	jr 	$ra
####################################################################################
integer_to_string:
	move    $t0, $a2		# char *p = buff

	# for (int i = n; i > 0; i = i / base){
	beqz	$a0, caso_cero

        abs	$t1, $a0

B0_003: blez	$t1, B0_007		# si i <= 0 salta el bucle
	div	$t1, $a1		# i / base
	mflo	$t1			# i = i / base
	mfhi	$t2			# d = i % base

	move	$t6, $t2
	addiu	$t2, $t2, '0'		# d + '0'
	bge	$t6, 10, else
	j	fin_for

else:
	addiu	$t2, $t2, 7

fin_for:

	sb	$t2, 0($t0)		# *p = $t2
	addiu	$t0, $t0, 1		# ++p
	j	B0_003		
        # }

 B0_007:

 	bgez 	$a0, FIN_BUF003	# si n es menor que 0 escribe  "-"
        lb	$t5, barra
        sb	$t5, 0($t0)
	addiu	$t0, $t0, 1  # ++p


FIN_BUF003:
	sb	$zero, 0($t0)		# *p = '\0'
	
	addi	$t0, $t0, -1  
for4:	bge	$a2, $t0, B0_001
	lb	$t5, 0($t0)  
	lb	$t4, 0($a2)
	sb	$t5, 0($a2)
	sb	$t4, 0($t0)	
	addiu	$a2, $a2, 1
	subiu	$t0, $t0, 1
	j 	for4

B0_001:
	jr	$ra
	break
####################################################################################
caso_cero:
	li	$t3, 48
	sb	$t3, 0($t0)
	addi	$t0, $t0, 1
	sb	$zero, 0($t0)
	jr	$ra
####################################################################################
imagen_dibuja_cadena:
	break
####################################################################################
tecla_salir:
	li	$v0, 1
	sb	$v0, acabar_partida	# acabar_partida = true
	jr	$ra
####################################################################################
tecla_izquierda:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	lw	$a1, pieza_actual_y
	lw	$t1, pieza_actual_x
	addiu	$a0, $t1, -1
	jal	intentar_movimiento	# intentar_movimiento(pieza_actual_x - 1, pieza_actual_y)
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra
####################################################################################
tecla_derecha:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	lw	$a1, pieza_actual_y
	lw	$t1, pieza_actual_x
	addiu	$a0, $t1, 1
	jal	intentar_movimiento	# intentar_movimiento(pieza_actual_x + 1, pieza_actual_y)
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra
####################################################################################
tecla_abajo:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	jal	bajar_pieza_actual	# bajar_pieza_actual()
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra
####################################################################################
tecla_rotar:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	jal	intentar_rotar_pieza_actual	# intentar_rotar_pieza_actual()
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra
####################################################################################
procesar_entrada:
	addiu	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw	$s4, 12($sp)
	sw	$s3, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	jal	keyio_poll_key
	move	$s0, $v0		# int c = keyio_poll_key()
        # for (int i = 0; i < sizeof(opciones) / sizeof(opciones[0]); ++i) { 
	li	$s1, 0			# i = 0, $s1 = i * sizeof(opciones[0]) // = i * 8 ###s1 (interador) lo inicializamos a 0
	la	$s3, procesar_entrada.opciones	
	li	$s4, 40			# sizeof(opciones) // == 5 * sizeof(opciones[0]) == 5 * 8
B21_1:	addu	$t1, $s3, $s1		# procesar_entrada.opciones + i*8 ###tenemos que iterar de 8 en 8
	lb	$t2, 0($t1)		# opciones[i].tecla
	bne	$t2, $s0, B21_3		# if (opciones[i].tecla != c) siguiente iteración
	lw	$t2, 4($t1)		# opciones[i].accion
	jalr	$t2			# opciones[i].accion()  ###igual que jal pero con registro
	jal	actualizar_pantalla	# actualizar_pantalla()
B21_3:	addiu	$s1, $s1, 8		# ++i, $s1 += 8
	bne	$s1, $s4, B21_1		# sigue si i*8 < sizeof(opciones)
        # } // for i
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s3, 8($sp)
	lw	$s4, 12($sp)
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 20
	jr	$ra
####################################################################################
jugar_partida:
	addiu	$sp, $sp, -12	
	sw	$ra, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	la	$a0, pantalla
	li	$a1, 20
	li	$a2, 22
	li	$a3, 32   		### espacio en blanco
	jal	imagen_init		# imagen_init(pantalla, 20, 22, ' ')
	la	$a0, campo
	li	$a1, 14
	li	$a2, 20
	li	$a3, 0			### caracter 0 (\0)
	jal	imagen_init		# imagen_init(campo, 14, 20, PIXEL_VACIO)
	jal	nueva_pieza_actual	# nueva_pieza_actual()
	sb	$zero, acabar_partida	# acabar_partida = false
	jal	get_time		# get_time()
	move	$s0, $v0		# Hora antes = get_time()
	jal	actualizar_pantalla	# actualizar_pantalla()
	j	B22_2
        # while (!acabar_partida) { 
B22_2:	lbu	$t1, acabar_partida
	bnez	$t1, B22_5		# if (acabar_partida != 0) sale del bucle
	jal	procesar_entrada	# procesar_entrada()
	jal	get_time		# get_time()
	move	$s1, $v0		# Hora ahora = get_time()
	subu	$t1, $s1, $s0		# int transcurrido = ahora - antes
	bltu	$t1, 1001, B22_2	# if (transcurrido < pausa + 1) siguiente iteración
B22_1:	jal	bajar_pieza_actual	# bajar_pieza_actual()
	jal	actualizar_pantalla	# actualizar_pantalla()
	move	$s0, $s1		# antes = ahora
        j	B22_2			# siguiente iteración
       	# } 
B22_5:	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$ra, 8($sp)
	addiu	$sp, $sp, 12
	jr	$ra
####################################################################################
####################################################################################
####################################################################################
	.globl	main
main:					# ($a0, $a1) = (argc, argv) 
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
B23_2:	jal	clear_screen		# clear_screen()
	
	######### PRUEBAS
#	la	$a0, pieza_actual
#	li	$a1, 8
#	li	$a2, 8
#	li	$a3, '7'
#	jal	imagen_init
	#la	$a0, pieza_actual
	#jal	imagen_print
############################
#	li 	$t0, 8
#	la	$a0, pieza_actual
#	sw	$t0, 0($a0)
#	sw	$t0, 4($a0)
#	li	$a1, '7' 
#	jal	imagen_clean
#	la	$a0, pieza_actual
#	jal	imagen_print
#############################
#	la	$a0, pieza_actual
#	la	$a1, pieza_jota
#	jal	imagen_copy
#	la	$a0, pieza_actual
#	jal	imagen_print
	######### FIN PRUEBAS			
#	la	$a0, pieza_actual
#	la	$a1, pieza_jota
#	li $a2,1
#	li $a3,1
#	jal imagen_dibuja_imagen_rotada
#	la	$a0, pieza_actual
 #	jal	imagen_print
					
	la	$a0, str000
	jal	print_string		# print_string("Tetris\n\n 1 - Jugar\n 2 - Salir\n\nElige una opción:\n")
	jal	read_character		# char opc = read_character()
	beq	$v0, '2', B23_1		# if (opc == '2') salir
	bne	$v0, '1', B23_5		# if (opc != '1') mostrar error
	jal	jugar_partida		# jugar_partida()
	j	B23_2
	
	
B23_1:	la	$a0, str001
	jal	print_string		# print_string("\n¡Adiós!\n")
	li	$a0, 0
	jal	mips_exit		# mips_exit(0)
	j	B23_2
B23_5:	la	$a0, str002
	jal	print_string		# print_string("\nOpción incorrecta. Pulse cualquier tecla para seguir.\n")
	jal	read_character		# read_character()
	j	B23_2
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

#
# Funciones de la librería del sistema
#

print_character:
	li	$v0, 11
	syscall	
	jr	$ra

print_string:
	li	$v0, 4
	syscall	
	jr	$ra

get_time:
	li	$v0, 30
	syscall	
	move	$v0, $a0
	move	$v1, $a1
	jr	$ra

read_character:
	li	$v0, 12
	syscall	
	jr	$ra

clear_screen:
	li	$v0, 39
	syscall	
	jr	$ra

mips_exit:
	li	$v0, 17
	syscall	
	jr	$ra

random_int_range:
	li	$v0, 42
	syscall	
	move	$v0, $a0
	jr	$ra

keyio_poll_key:
	li	$v0, 0
	lb	$t0, 0xffff0000
	andi	$t0, $t0, 1
	beqz	$t0, keyio_poll_key_return
	lb	$v0, 0xffff0004
keyio_poll_key_return:
	jr	$ra
