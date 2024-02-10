# Karbivskyi Olexandr
# Tested instructions: lui, ori, xori, andi, bne, sltu, jr
# Expected result: value 4144 in data memory with address 25

	
	lui $t1, 0xFFFF		# $t1 = 0xFFFF0000
	xori $t2, $t1, 0x1234 	# $t2 = 0xFFFF1234 (unsigned 4294906420, signed -60876 )
	andi $t3, $t2, 0xF0F0	# $t3 = 0x00001030 (unsigne 4144, signed 4144)
	sltu $t4, $t3, $t2	# $t4 = 1 (4414 less then 4294906420)
	slt $t7, $t3, $t2  	# $t7 = 0 (4414 not less then 4144)
	bne $t4, $t7, finish 	# $t4 != $t7 so branch to finish
	addi $t3, $zero, 1	# if $t4 = $t7, $t3 = 4145
	
next:	addi $t6, $zero, 40	# $t6 = 36
	jr $t6
finish:
	j next
	
	sw $t3, 25($zero)	# save content of $t3 to data memory with address 25
	addi $t0, $zero, 1
	sw $t0, 26($zero)	# finish for test bench