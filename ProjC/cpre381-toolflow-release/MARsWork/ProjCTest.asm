#Testing adds
addi $t0 $0 1
addi $t1 $0 1
add $t2 $t1 $t2
addu $t3 $t1 $t2

#Testing basic gates
nor $t2 $t0 $t1
xor $t2 $t0 $t1
or $t2 $t0 $t1
and $t2 $t0 $t1

xori $t2 $t0 1
ori $t2 $t0 1
andi $t2 $0 1

#Testing lui
lui $s3 100

#Testing Shifts
addi $s3 $zero 0xFFFF
slt $s4 $zero $s3
slti $s4 $zero 0xFFF
sltu $s4 $zero $s3
sltiu $s4 $zero 0xFFF

#testing lw sw
addi $s3 $zero -100
sw $t3 0x10010000($zero)
lw $t3 0x10010000($zero)

#Testing sub

sub $t2 $t0 $t1
subu $t2 $t0 $1

#Testing Branch Instructions

#Testing Branch instructions
Branch: 
	addi $s3 $zero 10
	addi $s2 $zero 10
	addi $s1 $zero 20
	beq $s1 $s2 Branch	# Test if beq works properly if not goes into infinite loop
	sll $0,$0,0 #no-op because its a branch and we have to see if it is taken
	beq $s2 $s3 BranchExit
	sll $0,$0,0 #no-op because its a branch and we have to see if it is taken
#Testing Branch Not Equal
BranchExit:
	bne $s3 $s2 BranchExit
	sll $0,$0,0 #no-op because its a branch and we have to see if it is taken
	bne $s2 $s1 BranchNotEqualExit
	sll $0,$0,0 #no-op because its a branch and we have to see if it is taken
#Testing Jump 
BranchNotEqualExit:
	j JumpExit
	sll $0,$0,0 #no-op because its a branch and we have to see if it is taken
	j Exit
	sll $0,$0,0 #no-op because its a branch and we have to see if it is taken
#Testing Jump and Link
JumpExit:
	jal JumpAndLink
	sll $0,$0,0 #no-op because its a branch and we have to see if it is taken
	j JumpRegister
	sll $0,$0,0 #no-op because its a branch and we have to see if it is taken
#Testing Jump Register should jump back to the link
JumpAndLink:
	jr $ra
	sll $0,$0,0 #no-op because its a branch and we have to see if it is taken
JumpRegister:
	j Exit
	sll $0,$0,0 #no-op because its a branch and we have to see if it is taken
Exit:

addi  $2,  $0,  10              # Place "10" in $v0 to signal an "exit" or "halt"
syscall                         # Actually cause the halt

	