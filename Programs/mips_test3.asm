
# Karbivskyi Olexandr
# Shifting operations test
# Instructions tested: addi, sll, srl, sra, sllv, srlv, srav, sw
# Expected result: value 2112 in data memory with address 12
	
	addi $t0, $zero, 2048
	addi $t1, $zero, -2048
	addi $t2, $zero, 1
	
	sll $t3, $t2, 10 	# $t3 = 1 * 2^10 = 1*1024 = 1024
	srl $t4, $t0, 5	 	# $t4 = 2048 / 32 = 64
	sra $t5, $t1, 5  	# $t5 = (-2048) / 32 = -64
	
	sllv $t3, $t3, $t2 	# $t3 = 1024 * 2^1 = 1024 * 2 = 2048
	srlv $t4, $t4, $t2 	# $t4 = 64 / 2 = 32
	srav $t5, $t5, $t2 	# $t5 = -64 / 2 = -32
	
	add $t6, $t3, $t4 	# $t6 = 2048+32=2080
	sub $t7, $t6, $t5 	# $t7 = 2080 - (-32) = 2112 
	
	sw $t7, 12($zero) 	# data_mem[12] = 2112
	sw $t2, 11($zero) 	# test completed - for test bench
