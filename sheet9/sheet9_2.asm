.text
	# 0x2008ffff => 0010 0000 0000 1000 1111 1111 1111 1111
	# OP-Code: 0010 00 - I instruction: addi
	# rs: 00 000 - $0
	# rt: 0 1000 - $8
	# immediate: 1111 1111 1111 1111

	addi $t0, $zero, 0xFFFF # 65535
	
	
	# 0x00a84004 => 0000 0000 1001 1000 0100 0000 0000 0100
	# OP-Code: 0000 00 - R Instruction
	# rs: 00 100 - $4
	# rt: 1 1000 - $24
	# rd: 0100 0 - $16
	# shamt: 000 00 - kein shift
	# func: 00 0100 - "SLLV" # shift left logical variable
	
	sllv $t0, $t0, $a1 
	
	# 0x00881024 => 0000 0000 1000 1000 0001 0000 0010 0100
	# OP-Code: 0000 00 - R Instruction
	# rs: 00 100 - $4
	# rt: 0 1000 - $8
	# rd: 0001 0 - $2
	# shamt: 000 00 - kein shift
	# func: 10 0100 - "AND" # bitwise and
	
	and $v0 $a0 $t0
	
	# 0x03e00008 => 0000 0011 1110 0000 0000 0000 0000 1000
	# OP-Code: 0000 00 - R Instruction
	# rs: 11 111 - $31
	# rt: 0 0000 - $0
	# rd: 0000 0 - $0
	# shamt: 000 00 - kein shift
	# func: 00 1000 - "JR" # Jump
	
	jr $ra
	
