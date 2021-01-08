.data
array: .word 10, -1, 2, 7, 3, 0
length: .word 6

.text
la $s0, array #$s0 is base array address
lw $s1, length #$s1 is length

    addi $t0, $0, 0 #$t0 is iterator
    addi $t1, $0, 0 #$t1 is if a swap happened
    subi $t7, $s1, 1 #$t7 is length - 1
loop:
    sll $t3, $t0, 2
    add $t4, $t3, $s0 #$t4 = &a[i]
    lw $t5, 0($t4) #$t5 = a[i]
    lw $t6, 4($t4) #$t6 = a[i + i]
    bge $t6, $t5, cond #Check if a[i] and a[i + 1] need to be swapped
    sw $t6, 0($t4) #a[i] = a[i + 1]
    sw $t5, 4($t4) #a[i + 1] = old a[i]
    ori $t1, $t1, 1 #$t1 is set to 1
cond:
    addi $t0, $t0, 1 #i++
    slt $t2, $t0, $t7 #Check if i < length - 1
    bne $t2, $0, loop #If i < length then go back to loop
    blt $t1, 1, exit #if a swap happened it needs to go through the whole array again
    addi $t0, $0, 0 #iterator needs to start at the beginning again
    addi $t1, $0, 0 #hasSwapped gets set back to false
    j loop
exit:
    #Halt program
    li $v0, 10
    syscall
