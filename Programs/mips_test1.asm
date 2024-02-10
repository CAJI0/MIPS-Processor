
# Karbivskyi Olexandr
# 
# Tested instructions: addi, sub, add, sw, lw
# Expected result: value 3500 in data memory with address 5


	addi $t0, $zero, 2000	# $t0 = 2000
	sw $t0, 0($zero)	# data_mem[0] = 2000
	addi $t0, $zero, 1000 	# $t0 = 1000
	sw $t0, 1($zero)	# data_mem[1] = 1000
	addi $t0, $zero, 500 	# $t0 = 500
	
	lw $t1, 0($zero)	# $t1 = data_mem[0] = 2000
	add $t0, $t0, $t1	# $t0 = 500 + 2000 = 2500
	lw $t1, 1($zero)	# $t1 = data_mem[1] = 1000
	add $t0, $t0, $t1	# $t0 = 2500 + 1000 = 3500
	sw $t0, 5($zero) 	# data_mem[5] = 3500
	addi $t0, $zero, 1	# $t0 = 1
	sw $t0, 0($zero)	# finish for test bench
