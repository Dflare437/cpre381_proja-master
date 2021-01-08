#Testing adds
addi $t0 $0 1
addi $t1 $0 1
sll $0,$0,0 #no-op because need to wait for values in $t0 and $t1
sll $0,$0,0 #no-op because need to wait for values in $t0 and $t1
add $t4 $t1 $t2
addu $t5 $t1 $t2
addiu $t1 $0 1
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
addi $s3 $zero 0x1111
sll $0,$0,0 #no-op because need to wait for values in $s3
slt $s0 $zero $s3
slti $s5 $zero 0x111
sltu $s2 $zero $s3
sltiu $s4 $zero 0x111
#testing lw sw
lui $s0 0x1001
sll $zero,$zero,0
sll $zero,$zero,0
addu $s0 $s0 $zero
sw $t3 0($s0)
lui $s1 0x1001
sll $zero,$zero,0
sll $zero,$zero,0
addu $s1 $s1 $zero
lw $t3 0($s1)
#Testing sub
addi $s3 $zero 10
addi $s2 $zero 10
sub $t4 $t0 $t1
subu $t5 $t0 $t1

beq $s3 $s2 Next
sll $0,$0,0 
#Testing Branch Not Equal
Next:
	bne $s3 $zero TestJump
	sll $0,$0,0 
#Testing Jump 
TestJump:
	j JumpExit
	sll $0,$0,0 
#Testing Jump and Link
JumpExit:
	jal JumpAndLink 
	sll $0,$0,0 
	j JumpRegister
	sll $0,$0,0 
#Testing Jump Register should jump back to the link
JumpAndLink:
	sll $0,$0,0 #Waiting for update on register to jump to
	sll $0,$0,0 
	sll $0,$0,0 
	sll $0,$0,0  
	jr $ra
	sll $0,$0,0 
JumpRegister:
	j Exit
	sll $0,$0,0 
Exit:
	
sll $0,$0,0 
sll $0,$0,0 
    addi $v0, $zero 10
    syscall

	
