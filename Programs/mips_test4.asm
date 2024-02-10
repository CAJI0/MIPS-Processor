
# Karbivskyi Olexandr
# Logic operations test
# Instructions tested: addi, nor, xor, or, and, sw
# Expected result: the value 0x00004050 in data memory with address 14  	

	addi $t0, $zero, 0x0055 # $t0 = 0x00000055
	addi $t1, $zero, 0x4400	# $t1 = 0x00004400
	addi $t2, $zero, 0x0F0F	# $t2 = 0x00000F0F
	
	nor $t4, $zero, $zero 	# $t4 = !(0x00000000 or 0x00000000) = 0xffffffff
	xor $t5, $t4, $t2	# $t5 = 0xffffffff xor 0x00000f0f = 0xfffff0f0 (inversion of $t2)
	
	or $t6, $t0, $t1	# $t6 = 0x00000055 or 0x00004400 = 0x00004455
	and $t7, $t5, $t6	# $t7 = 0xfffff0f0 and 0x00004455 = 0x00004050 (16464 dec)
	
	sw $t7, 14($zero)	# save content of $t7 to data memory with address 14
	addi $t0, $zero, 1	#
	sw $t0, 13($zero)	# finish for test bench
	
	
