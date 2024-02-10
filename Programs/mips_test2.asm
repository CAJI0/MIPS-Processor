# Karbivskyi Olexandr
# Tested instructions: addi, slt, beq, add, j, sw
# Realization next program
#	result = 0;
#  	for (i = 0; i < 11; i = i++)
# 	result = result + i;
# 
# Expected result: value 55 in data memory with address 6 (1+2+3+4+5+6+7+8+9+10 = 55)

	addi $t7, $zero, 11
	addi $t1, $zero, 1
	addi $t2, $zero, 0 	# $t2 = i 
	addi $t3, $zero, 0 	# $t3 = result

loop:	slt $t4, $t2, $t7	# $t4 = i < 11
	beq $t4, $zero, finish	# if i = 11 go to finish program
	add $t3, $t3, $t2	# result = result + i
	add $t2, $t2, $t1	# i++
	j loop


finish:	sw $t3, 6($zero)	# data_mem[6] = 55
	addi $t0, $zero, 1 	# initialize $t0 = 1
	sw $t0, 1($zero)	# finish for test bench
	
	
