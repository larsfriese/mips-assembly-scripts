.data
sp:	.space 132 # f�r die zeichenkette
text1:	.asciiz "Eingabe>"
text2:	.asciiz "Schluessel>"

.text
	# abort char
	addi $s1, $zero, '$'
	
	# text1
	li $v0, 4
	la $a0, text1
	syscall
	
	# set adress to start of data segment
	lui $a0 0x1001
	ori $a0, $a0, 0x0000
	addi $a1, $zero, 128
	
	# ask for string
	li $v0, 8
	syscall
	
	# text2
	li $v0, 4
	la $a0, text1
	syscall
	
	# input schluessel
	li $v0, 5
	syscall
	move $t2, $v0
	
	# set a0 to start of data segment
	lui $t4 0x1001
	ori $t4, $t4, 0x0000
	
	j next
	

# t4: memeory counter
# t2: key
# t1: current character being editeds

next:
	# load new char from memory
	lb $t1, ($t4)
	
	# end char = end char
	beq $s1, $t1, done
	
	# if new key outside of char
	# branch to where it will be subtracted until it works again
	# char has to be between 32 and 126
	bge $s1, 126, recalc

back:
	# add key amount to byte
	add $t1, $t1, $t2
	
	# print out
	# print the new char
	add $a0, $t1, 0
	li $v0, 11
	syscall
	
	addi $t4, $t4, 1
	j next
	
recalc:
	subi $t1, $t1, 93
	bge $s1, 126, recalc
	j back

done:
	# clean exit
	li $v0, 10
	syscall
