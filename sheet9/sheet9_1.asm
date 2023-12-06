# This script counts the number of occurences of a char
# in a given string.

.data
sp:	.space 132 # for the string
text1:	.asciiz "\nType a string: "
text2: 	.asciiz "\nType a char: "
text3:  .asciiz " occurence(s) \n"
nl:	.asciiz "\n"

.text
# main loop
start:
	# define abort char
	addi $s1, $zero, '$'
	
	# print text1 "\nType a string:"
	li $v0, 4
	la $a0, text1
	syscall
	
	# set $a0 to starting adress of data segment
	lui $a0 0x1001
	ori $a0, $a0, 0x0000
	
	# set $a1 to max string length
	addi $a1, $zero, 128
	
	# ask for string
	li $v0, 8
	syscall
	
	# print text2 "\nType a char:"
	li $v0, 4
	la $a0, text2
	syscall
	
	# ask for char and save in $v0
	li $v0, 12 
	syscall
	
	# if chat ($v0) == abort char ($s1) exit
	beq $v0, $s1, exit
	
	# reset $a0 to start of data segment to start
	# comparing string
	lui $a0 0x1001
	ori $a0, $a0, 0x0000
	
# now load char for char and compare to $v0
next:
	# load new char from memory
	# into $t1
	lb $t1, ($a0)
	
	# check if zero ($zero) == current char ($s1)
	# if yes => exit
	beq $zero, $t1, done
	
	# check if inputed char ($v0) == current char ($t1)
	beq $v0, $t1, found
	j back
	
back:	
	# increment memory adress by 1 byte = 8 bit (1 char)
	addi $a0, $a0, 1
	j next
	
found:
	# save count + 1 in $19
	addi, $19, $19, 1
	j back
	
done:	
	# print newline
	li $v0, 4
	la $a0, nl
	syscall
	
	# print the number of occurences
	add $a0, $zero, $19
	li $v0, 1
	syscall
	
	# print text3 "occurences."
	li $v0, 4
	la $a0, text3
	syscall
	
	# reset occurences
	li $19, 0
	
	# ask for the next word
	j start

exit:
	# clean exit
	li $v0, 10
	syscall
