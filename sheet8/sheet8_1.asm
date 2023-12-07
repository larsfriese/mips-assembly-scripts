.data
	# AUFGABE 1
x:	.byte 0xa0
y:	.half 0xb1b0
z:	.word 0xc3c2c1c0
t:	.ascii "The End."
	
.text
	# SCHRITT 1
	
	lui $1, 4097 # 4097 => 0x1001 0000 = anfangsadresse des data segments
	
	# lb $8, x
	lb $8, 0($1)
	
	# la $17, x
	# lbu $8, 0($17)
	
	# lh $9, y
	lh $9, 0x2($1) # hier offset
	
	# lw $10, t
	lw $10, 0x4($1) # offset 4, da wort erst bei 4 anf�ngt
	
	# lw $11, 0x8($1) string erstmal nicht
	
	# SCHRITT 2
	
	nor $8, $8, $8
	nor $9, $9, $9
	nor $10, $10, $10
	
	sb $8, 0($1)
	sh $9, 0x2($1)
	sw $10, 0x4($1)
	
