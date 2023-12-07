# This script finds the solutions to a quadratic equation: a0 + a1*x + a2*x2 = 0,
# using the pq-formula and the heron algorithm.
# The heron algorithm calculcates the square root until a given accuracy is reached.

.data
floats:		.float 0.0, 0.5, 1.0, 0.0000001 # last value is precision
intro:		.asciiz "Solutions to a quadratic equation: a0 + a1*x + a2*x**2 = 0.\n"
a2_text:	.asciiz "Input a2: \t"  # \t makes a tab space
a1_text:	.asciiz "Input a1: \t"
a0_text:	.asciiz "Input a0: \t"
real_text:	.asciiz "Real Solutions: \n"
imag_text:	.asciiz "Imaginary Solutions: \n"
lin_eq_text:	.asciiz "Linear Equation Solution: x=\t"
newline:	.asciiz "\n"
imag_text_plus:	.asciiz " + i*"
imag_text_minus:.asciiz " - i*"

.text	
	# "Solutions to a quadratic equation: a0 + a1*x + a2*x2 = 0.\n"
	li $v0, 4
	la $a0, intro
	syscall
	
	# "Input a2: \t"
	li $v0, 4
	la $a0, a2_text
	syscall
	
	# input a2
	li $v0, 6
	syscall
	mov.s $f2, $f0
	
	# "Input a1: \t"
	li $v0, 4
	la $a0, a1_text
	syscall
	
	# input a1
	li $v0, 6
	syscall
	mov.s $f3, $f0	
	
	# "Input a0: \t"
	li $v0, 4
	la $a0, a0_text
	syscall
	
	# input a0
	li $v0, 6
	syscall
	mov.s $f4, $f0
	
	
	# if a2 == 0 => linear equation
	la $t0, floats # $t0 now has floats adress from memory
	l.s $f10, 0($t0)
	c.eq.s $f2, $f10 # compare the two single float values
	bc1t linear_equation # if equal <=> if CT = 1 (bc[CT]t)
	
	# (f3) p == a1 / a2
	div.s $f3, $f3, $f2
	
	# (f4) q == a0 / a1
	div.s $f4, $f4, $f2
	
	# (f5) p/2
	l.s $f10, 4($t0)
	mul.s $f5, $f3, $f10
	
	# (f6) (p/2)**2
	mul.s $f6, $f5, $f5
	# (f7) (p/2)**2 - q
	sub.s $f7, $f6, $f4
	
	# if (f7) negativ => imag solutions
	l.s $f10, 0($t0)
	c.lt.s $f7, $f10
	bc1t imaginary_solutions
	
real_solutions:
	jal sqrt
	
	# results from sqrt and above:
	# (f15) x_i # sqrt
	# (f7) k # input to sqrt
	# (f5) p/2
	
	# (f18) -p/2
	neg.s $f18, $f5
	
	# store two solutions in $f20 and $f21
	add.s $f20, $f18, $f15
	sub.s $f21, $f18, $f15
	
	# "Real Solutions: \t"
	li $v0, 4
	la $a0, real_text
	syscall
	
	# print 1st solution
	li $v0, 2
	mov.s $f12, $f20
	syscall
	
	# newline
	li $v0, 4
	la $a0, newline
	syscall
	
	# print 2nd solution
	li $v0, 2
	mov.s $f12, $f21
	syscall
	
	j done
	

imaginary_solutions:
	# compute the sqrt with the positive value,
	# and add the *i to the solution later
	neg.s $f7, $f7
	jal sqrt
	
	# results: (f15) x_i # sqrt
	# (f7) k # input to sqrt
	# (f5) p/2
	
	# (f18) -p/2
	neg.s $f18, $f5
	
	# store two solutions in $f20 and $f21
	add.s $f20, $f18, $f15
	sub.s $f21, $f18, $f15
	
	# "Imaginary Solutions:"
	li $v0, 4
	la $a0, imag_text
	syscall
	
	# first real part
	li $v0, 2
	mov.s $f12, $f18
	syscall
	
	# " + i*"
	li $v0, 4
	la $a0, imag_text_plus
	syscall
	
	# first imaginary part
	li $v0, 2
	mov.s $f12, $f15
	syscall
	
	# newline
	li $v0, 4
	la $a0, newline
	syscall
	
	# second real part
	li $v0, 2
	mov.s $f12, $f18
	syscall
	
	# " - i*"
	li $v0, 4
	la $a0, imag_text_minus
	syscall
	
	# second imaginary part
	li $v0, 2
	mov.s $f12, $f15
	syscall
	
	j done

sqrt: # arguments are k=$7
	# (f15) (k + 1)
	l.s $f10, 8($t0)
	add.s $f15, $f7, $f10
	
	# (f15) (k + 1) / 2
	l.s $f10, 4($t0)
	mul.s $f15, $f15, $f10
	
loop:
	# (f16) k / x_i-1
	div.s $f16, $f7, $f15
	
	# (f16) ( k / x_i-1 ) + x_i-1
	add.s $f16, $f16, $f15
	
	# (f16) (( k / x_i-1 ) + x_i-1 ) * 0.5
	l.s $f10, 4($t0)
	mul.s $f16, $f16, $f10

	# (f18) abs(x_i - x_i-1)
	sub.s $f18, $f16, $f15
	abs.s $f18, $f18
	
	# copy $f16 to $f15
	mov.s $f15, $f16
	
	# abs(x_i - x_i-1) < 0.0000001?
	l.s $f10, 12($t0)
	c.le.s $f18, $f10
	bc1f loop
	
	jr $ra	
	
	
linear_equation:
	# the solution if a2 == 0 would be:
	# x = -a0 / a1
	div.s $f10, $f4, $f3
	neg.s $f10, $f10
	
	# "Linear Equation Solution: x=\t"
	li $v0, 4
	la $a0, lin_eq_text
	syscall
	
	# print $f10
	li $v0, 2
	mov.s $f12, $f10
	syscall
	
	j done
	
done:
	# clean exit
	li $v0, 10
	syscall
	
	
	
