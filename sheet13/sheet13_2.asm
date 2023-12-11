.data
sp:	.space 132 # for string
text1:	.asciiz "Input your string: \t"
text2:	.asciiz "Input key: \t"
text3:	.asciiz "Encrypted string: \n"

.text
	# "Input your string: \t"
	li $v0, 4
	la $a0, text1
	syscall
	
	# read string
	li $v0, 8
	la $a0, sp
	addi $a1, $zero, 128
	syscall
	
	# "Input key: \t"
	li $v0, 4
	la $a0, text2
	syscall
	
	# read key and move to $t2
	li $v0, 5
	syscall
	move $10, $v0
	
	la $a0, sp

loop:
	# prinatble ascii symbols:
	# starting with SP at 32
	# and ending with ~ at 126
	
	# load letter and add key
	lb $15, 0($a0)
	
	# check if end of string reached
	beq $15, $zero, done
	
	# increment char by key
	add $15, $15, $10
	
	# increment char by 32, as thats the starting range value
	subi $15, $15, 32
	
	# now divide by 126 and get remainder
	div $15, $15, 126 # remainder in HI
	mfhi $15
	
	# now subtract 32 again, to get actual ascii value back
	addi $15, $15, 32
	
	# save back to storage
	sb $15 0($a0)
	
	# increment by 1 byte
	addi $a0, $a0, 1
	
	j loop

done:
	# "Encrypted string: \t"
	li $v0, 4
	la $a0, text3
	syscall
	
	# new string
	li $v0, 4
	la $a0, sp
	syscall
	
	# clean exit
	li $v0, 10
	syscall