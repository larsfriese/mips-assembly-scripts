.data
text1: 	.asciiz "Fibonacci Sequence until n'th Number: "
text2:	.asciiz "'th Fibonacci Number is "

.text
	# text1
	li $v0, 4
	la $a0, text1
	syscall
	
	# input a0
	li $v0, 5
	syscall
	
	# load the first values of 
	# the fibonnaci sequence
	li $t0, 1
	li $t1, 1
	
fib_iter:
	add $t2, $t0, $t1
	move $t0, $t1
	move $t1, $t2
	
	# counter $t3
	addi $t3, $t3, 1
	
	# branch to exit if number reached
	bge $t3, $v0, exit
	
	# keep going if not
	j fib_iter

exit:
	# nth number
	li $v0, 1
	move $a0, $t3
	syscall
	
	# "'nth Fibonacci Number is "
	li $v0, 4
	la $a0, text2
	syscall
	
	# fib number
	li $v0, 1
	move $a0, $t2
	syscall
	
	# clean exit
	li $v0, 10
	syscall
		