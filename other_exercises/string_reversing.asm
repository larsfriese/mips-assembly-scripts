# Reads a string and revereses it in memory, then prints it out.
# Example: "Input your string:	Nice weather today!"
# 	   "Reversed String: !yadot rehtaew eciN"

# Idea: Have to sections in data segment, one for inputed string,
# one for reversed. Iterate backwards throught the first string and save
# into second data segment. Then print second data segement.

.data

segment1:	.space 132
segment2: 	.space 132
str_input:	.asciiz "Input your string: \t"
rev_str:	.asciiz "Reversed string: \t"

.text
	# "Input your string: \t"
	la $a0, str_input
	li $v0, 4
	syscall
	
	# get string
	la $a0, segment1
	li $a1, 128 # set max string length
	li $v0, 8
	syscall
	
	
	# get length of string
	la $20, segment1
	
count_loop:
	lb $22, 0($20)
	beq $22, $zero, copy_loop_start
	addi $20, $20, 1 # increment memory adress
	j count_loop
	
# $20 now contains the adress of the ending of the inputed string

copy_loop_start:
	subi $20, $20, 2 # subtract two so that enter and newline symbol are not copied
	la $23, segment2 # load start of segment 2 into $23
	
copy_loop:
	
	lb $22, 0($20) # load char from segment 1
	sb $22, 0($23) # save char to segment 2
	
	addi $23, $23, 1 # adress segment 2 += 1
	subi $20, $20, 1 # adress segment1 -= 1
	
	li $24, 0x1000FFFF
	beq $20, $24, done # if adress is 1 before start of data segment, then end copying
	
	j copy_loop
	
done:
	la $a0, rev_str
	li $v0, 4
	syscall
	
	la $a0, segment2
	li $v0, 4
	syscall

	# clean exit
	li $v0, 10
	syscall