.text
	li $4, 27
	li $5, 12
	add $2, $2, $5
	beqz $4, end

start:
	beqz $5, before_end
	bgt $4, $5, calc
	sub $5, $5, $4
	j start

calc:
	sub $4, $4, $5
	j start
	

before_end:
	move $2, $4
	j end
			
end:
	# print ggT
	move $a0, $2
	li $v0, 1
	syscall
	