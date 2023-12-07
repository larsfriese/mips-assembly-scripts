# This script converts an inputed string either to all lower
# chars or all upper chars.

.data
data:	.space 132
text1:	.asciiz "Type a String: \t"
text2:	.asciiz "\nTo Upper: \t"

.text
	la $11, data
	
	# print text1
	li $v0, 4
	la $a0, text1
	syscall
	
	# ask for string
	li $v0, 8
	la $a0, ($11)
	addi $a1, $zero, 128
	syscall
	

# ASCII
# 97 a - 122 z
# 65 A - 90 Z
toupper:
	# ($20) load char from adress in $11
	lb $20, ($11)
	
	# check if zero ($zero) == current char ($s1)
	beq $zero, $20, done
	
	# ($21) 96
	li $21, 96
	
	# if char <= 96
	ble $20, $21, out

	# ($21) 123
	li $21, 123
	
	# if char >= 123
	bge $20, $21, out
	
	# convert to lower	
	subi $20, $20, 32
	
	# save back to RAM
	sb $20, ($11)
	
out:	
	# increment to next char
	addi $11, $11, 1
	j toupper

tolower:
	# ($20) load char from adress in $11
	lb $20, ($11)
	
	# check if zero ($zero) == current char ($s1)
	beq $zero, $20, done
	
	# ($21) 64
	li $21, 64
	
	# if char <= 64
	ble $20, $21, out

	# ($21) 91
	li $21, 91
	
	# if char >= 91
	bge $20, $21, out
	
	# convert to lower	
	addi $20, $20, 32
	
	# save back to RAM
	sb $20, ($11)
	
out:	
	# increment to next char
	addi $11, $11, 1
	j tolower

done:
	# print text1
	li $v0, 4
	la $a0, text2
	syscall
	
	# print converted String:
	li $v0, 4
	la $a0, data
	syscall
	
	# clean exit
	li $v0, 10
	syscall
	