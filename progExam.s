
	.data	
	.align	2
jump_table000:
	.word	B7_4
	.word	B7_5
	.word	B7_6
	.word	B7_7
	.word	B7_8
	.word	B7_10
	.word	B7_14
	.align	2
fracciones:
	.word	1
	.word	2
	.word	3
	.word	2
	.word	-200
	.word	101
	.word	2000
	.word	1111
	.word	100
	.word	101
	.word	-70
	.word	71
	.word	2
	.word	1111
	.word	21
	.word	33
	.word	8
	.word	9
	.word	13
	.word	11
str000:
	.asciiz		"Introduce el numerador: "
str001:
	.asciiz		"Introduce el denominador: "
str002:
	.asciiz		"\nExamen de ETC de ensamblador\n"
str003:
	.asciiz		"\n\n 1. Lectura de enteros por teclado\n 2. Cálculo del Máximo Común divisor (MCD)\n 3. Lectura de fracciones por teclado\n 4. Simplificación de fracciones\n 5. Suma de dos fracciones\n 6. Suma de un array de fracciones\n 7. Salir\n\nElige una opción: "
str004:
	.asciiz		"\n\n"
str005:
	.asciiz		"Introduce un entero: "
str006:
	.asciiz		"\nEl entero leído ha sido: "
str007:
	.asciiz		"\n"
str008:
	.asciiz		"Introduce un número (a): "
str009:
	.asciiz		"Introduce otro número (b): "
str010:
	.asciiz		"\nEl MCD de a y b es: "
str011:
	.asciiz		"\nLa fraccion leída ha sido: "
str012:
	.asciiz		"\nLa fraccion simplificada es: "
str013:
	.asciiz		"\nLeyendo la primera fracción:\n"
str014:
	.asciiz		"La primera fraccion leída ha sido: "
str015:
	.asciiz		"\nLeyendo la segunda fracción:\n"
str016:
	.asciiz		"La segunda fraccion leída ha sido: "
str017:
	.asciiz		"\nLa suma es: "
str018:
	.asciiz		"\nLa suma simplificada es: "
str019:
	.asciiz		" + "
str020:
	.asciiz		" = "
str021:
	.asciiz		"¡Adiós!\n"
str022:
	.asciiz		"Opción incorrecta. Pulse cualquier tecla para seguir.\n"

	.text	

preguntar_entero:
        # ???
        break
        
preguntar_fraccion:
        # ???
        break

print_fraccion:
	addiu	$sp, $sp, -8
	sw	$ra, 4($sp)
	sw	$s0, 0($sp)
	move	$s0, $a0
	lw	$a0, 0($s0)
	jal	print_integer
	li	$a0, '/'
	jal	print_character
	lw	$a0, 4($s0)
	jal	print_integer
	lw	$s0, 0($sp)
	lw	$ra, 4($sp)
	addiu	$sp, $sp, 8
	jr	$ra

mcd:
        # ???
        break

simplificar_fraccion:
        # ???
        break

sumar_fracciones:
        # ???
        break

sumar_fracciones_array:
        # ???
        break

	.globl	main
main:
	addiu	$sp, $sp, -184
	sw	$ra, 180($sp)
	sw	$fp, 176($sp)
	sw	$s7, 172($sp)
	sw	$s6, 168($sp)
	sw	$s5, 164($sp)
	sw	$s4, 160($sp)
	sw	$s3, 156($sp)
	sw	$s2, 152($sp)
	sw	$s1, 148($sp)
	sw	$s0, 144($sp)
	jal	clear_screen
	la	$a0, str002
	jal	print_string
	la	$t1, str003
	sw	$t1, 92($sp)
	la	$t1, str004
	sw	$t1, 88($sp)
	la	$t1, str022
	sw	$t1, 84($sp)
	la	$t1, str005
	sw	$t1, 80($sp)
	la	$t1, str006
	sw	$t1, 76($sp)
	la	$t1, str007
	sw	$t1, 72($sp)
	la	$t1, str008
	sw	$t1, 68($sp)
	la	$t1, str009
	sw	$t1, 64($sp)
	la	$t1, str010
	sw	$t1, 60($sp)
	addiu	$t1, $sp, 136
	sw	$t1, 56($sp)
	la	$t1, str011
	sw	$t1, 52($sp)
	addiu	$s2, $sp, 128
	la	$t1, str012
	sw	$t1, 48($sp)
	la	$t1, str013
	sw	$t1, 44($sp)
	addiu	$s5, $sp, 120
	la	$t1, str014
	sw	$t1, 40($sp)
	la	$t1, str015
	sw	$t1, 36($sp)
	addiu	$fp, $sp, 112
	la	$t1, str016
	sw	$t1, 32($sp)
	addiu	$s3, $sp, 104
	la	$t1, str017
	sw	$t1, 28($sp)
	la	$t1, str018
	sw	$t1, 24($sp)
	la	$s0, fracciones
	la	$s7, str019
	li	$s4, 72
	la	$t1, str020
	sw	$t1, 20($sp)
	la	$t1, str021
	sw	$t1, 16($sp)
	j	B7_2
B7_1:	lw	$a0, 84($sp)
	jal	print_string
	jal	read_character
B7_2:	lw	$a0, 92($sp)
	jal	print_string
	jal	read_character
	move	$s1, $v0
	lw	$a0, 88($sp)
	jal	print_string
	sll	$t1, $s1, 24
	sra	$t1, $t1, 24
	addiu	$v0, $t1, -49
	li	$t1, 6
	sltu	$t1, $t1, $v0
	bnez	$t1, B7_1
	sll	$t1, $v0, 2
	lw	$t1, jump_table000($t1)
	jr	$t1
B7_4:	lw	$a0, 80($sp)
	jal	preguntar_entero
	move	$s1, $v0
	lw	$a0, 76($sp)
	jal	print_string
	move	$a0, $s1
	jal	print_integer
	lw	$a0, 72($sp)
	jal	print_string
	j	B7_2
B7_5:	lw	$a0, 68($sp)
	jal	preguntar_entero
	move	$s6, $v0
	lw	$a0, 64($sp)
	jal	preguntar_entero
	move	$s1, $v0
	lw	$a0, 60($sp)
	jal	print_string
	move	$a0, $s6
	move	$a1, $s1
	jal	mcd
	move	$a0, $v0
	jal	print_integer
	j	B7_13
B7_6:	lw	$s1, 56($sp)
	move	$a0, $s1
	jal	preguntar_fraccion
	lw	$a0, 52($sp)
	jal	print_string
	move	$a0, $s1
	j	B7_9
B7_7:	move	$a0, $s2
	jal	preguntar_fraccion
	la	$a0, str011
	jal	print_string
	move	$a0, $s2
	jal	print_fraccion
	move	$a0, $s2
	jal	simplificar_fraccion
	lw	$a0, 48($sp)
	jal	print_string
	move	$a0, $s2
	j	B7_9
B7_8:	lw	$a0, 44($sp)
	jal	print_string
	move	$a0, $s5
	jal	preguntar_fraccion
	lw	$a0, 40($sp)
	jal	print_string
	move	$a0, $s5
	jal	print_fraccion
	lw	$a0, 36($sp)
	jal	print_string
	move	$a0, $fp
	jal	preguntar_fraccion
	lw	$a0, 32($sp)
	jal	print_string
	move	$a0, $fp
	jal	print_fraccion
	move	$a0, $s3
	move	$a1, $s5
	move	$a2, $fp
	jal	sumar_fracciones
	lw	$a0, 28($sp)
	jal	print_string
	move	$a0, $s3
	jal	print_fraccion
	move	$a0, $s3
	jal	simplificar_fraccion
	lw	$a0, 24($sp)
	jal	print_string
	move	$a0, $s3
B7_9:	jal	print_fraccion
	j	B7_13
B7_10:	la	$a0, str007
	jal	print_string
	li	$s1, 0
B7_11:	addu	$a0, $s0, $s1
	jal	print_fraccion
	move	$a0, $s7
	jal	print_string
	addiu	$s1, $s1, 8
	bne	$s1, $s4, B7_11
	la	$s6, fracciones
	addiu	$a0, $s6, 72
	jal	print_fraccion
	lw	$a0, 20($sp)
	jal	print_string
	addiu	$s1, $sp, 96
	move	$a0, $s1
	move	$a1, $s6
	li	$a2, 10
	jal	sumar_fracciones_array
	move	$a0, $s1
	jal	print_fraccion
B7_13:	la	$a0, str007
	jal	print_string
	j	B7_2
B7_14:	lw	$a0, 16($sp)
	jal	print_string
	li	$a0, 0
	jal	mips_exit
	j	B7_2
	lw	$ra, 180($sp)
	lw	$fp, 176($sp)
	lw	$s7, 172($sp)
	lw	$s6, 168($sp)
	lw	$s5, 164($sp)
	lw	$s4, 160($sp)
	lw	$s3, 156($sp)
	lw	$s2, 152($sp)
	lw	$s1, 148($sp)
	lw	$s0, 144($sp)
	addiu	$sp, $sp, 184
	jr	$ra

print_integer:
	li	$v0, 1
	syscall	
	jr	$ra

print_character:
	li	$v0, 11
	syscall	
	jr	$ra

print_string:
	li	$v0, 4
	syscall	
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
