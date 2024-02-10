# Karbivskyi Olexandr
# Tested instructions: ror, addi, addiu, andi
# Expected results: 

 	addi $t1, $zero, 1	# $t1 = 1
 	ori $t2, $zero, 0xffff # $t2 = 0x0000ffff
 	
 	ror $t4, $t2, 16 	# 0x0000ffff ror by 16 $ t4 = 0xffff0000
 	addi $t4, $t4, 0x7fff   # $t4 = 0xffff7fff
 	ror $t4, $t4, 16 	# $t4 = 0x7fffffff
 	addi $t4, $t4, 1 	# $t4 must don`t change content (overflow occurs)
 	sw $t4, 20($zero)	# save value 2147483647 in data memory with address 20
 	addiu $t4, $t4, 1	# $t4 change content
 	sw $t4 21($zero)	# save value -2147483648 in data memory with address 21
 	sw $t1 22 ($zero)	# finish for testbench
