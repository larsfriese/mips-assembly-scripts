# Approximate PI using the Gregory-Leibniz Series. (see pdf description)

.data
pi:		.double 3.141592653589793 
immediates:	.double 0.0, 1.0, 2.0, 4.0, -1.0

str_input:	.asciiz "What precision do you want for PI? \t"
str_output: 	.asciiz "\nCalcualted PI: \t"
str_error:	.asciiz "\nDeviation from actual PI: \t"
str_iterations:	.asciiz "\nIterations it took: \t"

.text

	# input precisision
	# "What precision do you want for PI? \t"
	la $a0, str_input
	li $v0, 4
	syscall
	
	# ask for double
	li $v0, 7
	syscall
	mov.d $f30, $f0 # move precision value to $f30
	
	# constants
	l.d $f0, immediates	# 0.0
	l.d $f2, immediates+8	# 1.0
	l.d $f4, immediates+16	# 2.0
	l.d $f6, immediates+24	# 4.0
	l.d $f8, immediates+32	# -1.0
	l.d $f28, pi		# value of pi
	# l.d $f30, acc		# inputed error value
	
	# loop variables
	mov.d $f10, $f8 # $f10 is the nominator, it gets multiplied with -1
			# each step, so its initialized to -1 so that it starts
			# with 1 in the loop
	mov.d $f12, $f0 # pi/4, initialized with 0
	mov.d $f14, $f0 # counter n, initialized with 0.0
	
loop:	mul.d $f10, $f10, $f8 # multiply nominator with -1
	mul.d $f16, $f14, $f4 # f16 = 2*n
	add.d $f16, $f16, $f2 # f16 += 1
	div.d $f18, $f10, $f16 # f18 = nominator (f10) / denominator (f16)
	
	add.d $f12, $f12, $f18 # pi += f18
	add.d $f14, $f14, $f2 # counter += 1
	
	mul.d $f20, $f12, $f6 # pi/4 * 4 = pi
	
	sub.d $f22, $f28, $f20 # difference = real pi - calculated pi 
	abs.d $f22, $f22 # take absolute of difference
	c.le.d $f22, $f30
	bc1t exit
	
	j loop
	
exit:	# "Calcualted PI: \t"
	la $a0, str_output
	li $v0, 4
	syscall
	
	# print calulated pi
	mov.d $f12, $f20
	li $v0, 3
	syscall
	
	# "Deviation from actual PI: \t"
	la $a0, str_error
	li $v0, 4
	syscall
	
	# print error
	mov.d $f12, $f22
	li $v0, 3
	syscall
	
	# "Iterations it took: \t"
	la $a0, str_iterations
	li $v0, 4
	syscall
	
	# print iterations
	mov.d $f12, $f14
	li $v0, 3
	syscall
	
	# clean exit
	li $v0, 10
	syscall
