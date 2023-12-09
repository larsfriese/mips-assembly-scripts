# Read a string and check if its a palindrome.
# Example: "Input your string:	Hannah"
#	   "Hannah is a palindrome! Middle Index: 2"

# Idea: Set a a counter at start of string, and one at end.
# Iterate through string from both sides. If charachters
# dont match, stop.

.data
text_input:	.space 132
str_input:	.asciiz "Input your string: \t"
is_text:	.ascii 	" is a palindrome!\n"
		.asciiz "Middle index: "
isnt_text:	.asciiz "is not a palindorme!"

.text
	# "Input your string: \t"
	la $a0, str_input
	li $v0, 4
	syscall
	
	# get string
	la $a0, text_input
	li $a1, 128 # set max string length
	li $v0, 8
	syscall
	
	# get string length first
	# string stored at start of data segment
	la $20, text_input
	# $21 reserved for length
next:
	lb $22, 0($20)
	beq $22, $zero, start
	addi $20, $20, 1 # memeory adress
	addi $21, $21, 1 # counter
	j next
	
start:
	# setup the two counters
	# were going to be using $10 for forward counter
	# and $11 for backward counting
	
	la $10, text_input # counter from front
	subi $20, $20, 2
	la $11, ($20) # counter from behind
	
loop:
	# load both chars from each end of string
	lb $12, 0($10)
	lb $13, 0($11)
	
	bne $12, $13, no # if charachters not equal => no plandirome
	
	beq $10, $11, yes # if same adress reached => palindrome
	
	addi $14, $10, 1
	beq $14, $11, yes # if palindrome has odd length, same middle charachter is not reached
			  # at same time, so check if +1 is equal to other char
	
	# increment the front couter,
	# decrement the back counter
	addi $10, $10, 1
	subi $11, $11, 1
	
	j loop
	
yes:
	# print inputed string
	la $a0, text_input
	li $v0, 4
	syscall
	
	# " is a palindrome!\n"
	# "Middle index: "
	la $a0, is_text
	li $v0, 4
	syscall
	
	# print middle index
	subi $10, $10, 0x10010000 # start of string adress - adress of front counter
	move $a0, $10
	li $v0, 1
	syscall
	
	j exit

no:
	"is not a palindorme!"
	la $a0, isnt_text
	li $v0, 4
	syscall
	
	j exit
	
exit:
	# clean exit
	li $v0, 10
	syscall
