
# Karbivskyi Olexandr
# Test exeption: overflow with adding and subsructing 
# Instructions tested: lui, ori, addi, add, addu, sub, subu, sw
# Expected results: 	value 100 in data memory with address 15
#			value -2147483648 in data memory with address 16
#			value 200 in data memory with address 17
#			value 2147483647 in data memory with address 18


	lui $t1, 0x7fff		# $t1 = 0x7fff0000
	ori $t1, $t1, 0xffff	# $t1 = 0x7fffffff (the most positive signed 32-bit number)
	addi $t2, $zero, 1	# $t2 = 1
	
	
	addi   $t5, $zero, 100	# $t5 = 100
	add $t5, $t1, $t2 	# 0x7fffffff + 0x00000001 = 0x80000000 (overflow occurs and $t5 must don`t change content)
	sw $t5, 15($zero)	# save value 100 to data memory with address 15
	addu $t5, $t1, $t2	# $t4 = 0x7fffffff + 0x00000001 = 0x80000000 (-2147483648 )
				# overflow occurs but $t5 change content
	sw $t5, 16($zero)	# save value  -2147483648 to data memory with address 16
	
	addi $t6, $zero, 200	# $t6 = 200
	sub $t6, $t5, $t2	# 0x80000000 - 0x00000001 = 0x7fffffff (-214783648 - 1 = -2147483649)
				# overflow occurs and $t6 must don`t change content
	sw $t6, 17($zero)	# save value 200 to data memory with address 17
	subu $t6, $t5, $t2	# $t6 = 0x80000000 - 0x00000001 = 0x7fffffff (2147483647)
				# overflow occuts but $t6 change content
	sw $t6, 18($zero)	# save value 2147483647 to data memory with address 18
	
	sw $t2, 19($zero)	# finish for testbench