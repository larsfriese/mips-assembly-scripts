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
	
	# get string length first
	# string stored at start of data segment
	la $20, segment1
	# $21 reserved for length
next:
	lb $22, 0($20)
	beq $22, $zero, loop
	addi $20, $20, 1 # memory adress
	addi $21, $21, 1 # counter
	j next

loop:
	subi $21, $21, 2
	la $20, segment1
	add $20, $20, $21
	
	la $23, segment2
	
loopus:
	
	lb $22, 0($20) # load char from segment 1
	sb $22, 0($23) # save char to segment 2
	
	beqz $21, done # if counter == 0
	
	addi $23, $23, 1 # adress segment 2 += 1
	subi $20, $20, 1 # adress segment1 -= 1
	subi $21, $21, 1 # counter -= 1
	
	
	j loopus
done:
	la $a0, rev_str
	li $v0, 4
	syscall
	
	la $a0, segment2
	li $v0, 4
	syscall
	
	j exit

exit:
	# clean exit
	li $v0, 10
	syscall