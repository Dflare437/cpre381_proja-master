.data
array: .word 10, -1, 2, 7, 3, 0
length: .word 6

.text

    #The code prior to the loop is to set up different registers with proper
    #Values prior to the the loop. This code is structured to get rid of as
    #many no-ops as possible

    addi $t8, $0, 1 #Load 1 into $t8 as a constant for 1

    lui $t9, 0x00001001 #Load the upper part of the address of length into $t9
    lui $s0, 0x00001001 #Load the address of the array into $s0
    
    addi $t0, $0, 0 #$t0 is initalized as an iterator
    
    lw $s1, 0x00000018($t9) #Load the length value into $s1
    
    addi $t1, $0, 0 #$t1 is a boolean for if a swap happened
	
	sll $0,$0,0 #no-op to wait for $s1 value
	
    #Leave array if the length is 0 or 1
    #ble $s1, 1, exit
    
    sub $t7, $s1, $t8 #$t7 is the length - 1
    
loop:
    sll $t3, $t0, 2
    
    sll $0,$0,0 #no-op to wait for $t3 value
    sll $0,$0,0 #no-op to wait for $t3 value
    
    add $t4, $t3, $s0 #$t4 = &a[i]
    
    sll $0,$0,0 #no-op to wait for $t4 value
    sll $0,$0,0 #no-op to wait for $t4 value
    
    lw $t5, 0($t4) #$t5 = a[i]
    lw $t6, 4($t4) #$t6 = a[i + i]
    
    sll $0,$0,0 #no-op to wait for $t5 and $t6 value
    sll $0,$0,0 #no-op to wait for $t5 and $t6 value
    
    #Check if a[i] and a[i + 1] need to be swapped
    slt $at, $t6, $t5
    
    sll $0,$0,0 #no-op to wait for $at value
    sll $0,$0,0 #no-op to wait for $at value
    
    beq $at, $0, cond
    
    sll $0,$0,0 #no-op because its a branch and we have to see if it is taken
    
    sw $t6, 0($t4) #a[i] = a[i + 1]
    sw $t5, 4($t4) #a[i + 1] = old a[i]
    ori $t1, $t1, 1 #$t1 is set to 1
    
cond:
    addi $t0, $t0, 1 #i++
    
    
    sll $0,$0,0 #no-op to wait for $t0 value
    
    slti $at, $t1, 1 #Check if a swap happened for the second branch condition
    
    slt $t2, $t0, $t7 #Check if i < length - 1
    
    sll $0,$0,0 #no-op to wait for $t2 value
    sll $0,$0,0 #no-op to wait for $t2 value
    
    bne $t2, $0, loop #If i < length then go back to loop
    
    sll $0,$0,0 #no-op because its a branch and we have to see if it is taken
    
    beq $at, $t8, exit #if a swap happened it needs to go through the whole array again
    
    sll $0,$0,0 #no-op because its a branch and we have to see if it is taken
    
    addi $t0, $0, 0 #iterator needs to start at the beginning again
    addi $t1, $0, 0 #hasSwapped gets set back to false
    j loop
    
    sll $0,$0,0 #no-op because its a jump
exit:
    #Halt program
    li $v0, 10
    syscall