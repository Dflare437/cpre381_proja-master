#Testing Branch instructions
Branch: 
	addi $s3 $zero 10
	addi $s2 $zero 10
	addi $s1 $zero 20
	beq $s1 $s2 Branch	# Test if beq works properly if not goes into infinite loop
	beq $s2 $s3 BranchExit
#Testing Branch Not Equal
BranchExit:
	bne $s3 $s2 BranchExit
	bne $s2 $s1 BranchNotEqualExit
#Testing Jump 
BranchNotEqualExit:
	j JumpExit
	j Exit
#Testing Jump and Link
JumpExit:
	jal JumpAndLink
	j JumpRegister
#Testing Jump Register should jump back to the link
JumpAndLink:
	jr $ra
JumpRegister:
	j Exit
Exit:

addi  $2,  $0,  10              # Place "10" in $v0 to signal an "exit" or "halt"
syscall                         # Actually cause the halt