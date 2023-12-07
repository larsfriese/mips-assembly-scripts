# good explanation:
# https://ravinduramesh.blogspot.com/2021/06/mips-recursive-and-non-recursive.html

.data
info1:	.asciiz "Bitte gewünschte Fibonacci-Nummer eingeben:\n"
info2:	.asciiz "Rekursiver mittelte Fibonacci-Zahllist:\n"

.text
_main:
	la $a0, info1
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	add $a0, $zero, $v0 # Eingabe Fibo-Nummer nach $a0
	
	# addi $sp, $sp, -4 # stack pointer vergrößern
	# sw $ra, 0($sp) # Adresse $ra im Stack persistieren
	
	jal FibCalcRec # $v0 = Fib; rekursiver Aufruf
	move $a1, $v0 # Register $v0 sichern; move ist Pseudoanweisung
	
	la $a0, info2
	li $v0, 4
	syscall
	
	move $a0, $a1 # move := add $a0, $zero, $a1
	li $v0, 1
	syscall
	
	# lw $ra, 0($sp) # Rückgabe Stackpointer (nicht notwendig hier)
	# addi $sp, $sp, 4 # Freigabe Stack

	li $v0, 10
	syscall

# recursively called

FibCalcRec:
	# reserve stack storage
	addi $sp, $sp, -12
	sw $t1, 0($sp)   # save $t1
	sw $t2, 4($sp)   # save $t2
    	sw $ra, 8($sp)   # save return adress
    	move $t1, $a0
    		
    	# cases for n=0 and n=1
    	beq $t1, $zero, case_0
    	li $t3, 1
    	beq $t1, $t3, case_1
    	
    	# subtract one from n and calc F(n-1)
    	subi $a0, $t1, 1
    	jal FibCalcRec
    	
    	# save values from first recursive call to 
    	move $t2, $v0 # $t2 = $v0
    	
    	# subtract one from n and calc F(n-2)
	subi $a0, $t1, 2
	jal FibCalcRec
	
	# get values from recursive call
	add $v0, $v0, $t2 # $v0 += $t2
	
free:
	lw $t1, 0($sp)
	lw $t2, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12 # free up memory space
	
	# Anzahl Fibonacci-Zahl = $a0; berechnete Fibonacci-Zahl $v0
	jr $ra
	
case_1:
	li $v0, 1
    	j free

case_0:
	li $v0, 0
    	j free