addi $s2 $s2 0

#overflow test for addi
lui $t0 0xFFFF
ori $t0 $zero 0xFFFF
addi $t0 $t0 1
#overflow test for add
lui $s4 0xFFFF
ori $s4 $zero 0xFFFF
lui $s3 0xFFFF
ori $s3 $zero 0xFFFF
add $s4 $s3 $s4
#testing if addiu doesn't overflow and add overflows
lui $s3 0xFFFF
ori $s3 $zero 0xFFFF
addiu $s4 $s3 0xFFFF
addi $s3 $s3 1
#Testing addu
addi $s3 $zero 0x0FFF
addi $s4 $zero 0x0FFF
addu $s4 $s3 $s4
#Testing Basic gates
addi $s1 $zero 1
nor $s3 $zero $zero
nor $s3 $zero $s1
nor $s3 $s1 $zero
nor $s3 $s1 $s1 

xor $s3 $zero $zero
xor $s3 $zero $s1
xor $s3 $s1 $zero
xor $s3 $s1 $s1 

or $s3 $zero $zero
or $s3 $zero $s1
or $s3 $s1 $zero
or $s3 $s1 $s1 

and $s3 $zero $zero
and $s3 $zero $s1
and $s3 $s1 $zero
and $s3 $s1 $s1 

#Testing gates with immiediete
andi $s3 $zero 0
andi $s3 $zero 1 
andi $s3 $s1 0
andi $s3 $s1 1 

xori $s3 $zero 0
xori $s3 $zero 1 
xori $s3 $s1 0
xori $s3 $s1 1 

ori $s3 $zero 0
ori $s3 $zero 1 
ori $s3 $s1 0
ori $s3 $s1 1 

lui $s3 100

#Testing slt instructions
addi $s3 $zero 0xFFFF

slt $s4 $zero $s3
slti $s4 $zero 0xFFF
sltu $s4 $zero $s3
sltiu $s4 $zero 0xFFF

#Testing shifts

addi $s4 $zero 0xF000
sll $s3 $s4 1
srl $s3 $s4 1
sra $s3 $s4 1
addi $s2 $zero 1
sllv $s3 $s4 $s2
srlv $s3 $s4 $s2
srav $s3 $s4 $s2

#testing lw sw

addi $t3 $zero -100
sw $t3 0x10010000($zero)
lw $t3 0x10010000($zero)


#Testin sub

addi $s3 $zero 0xF000
sub $s2 $zero $s3
subu $s2 $zero $s3

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
