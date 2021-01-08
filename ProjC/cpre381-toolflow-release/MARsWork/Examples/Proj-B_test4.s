.data
array: .word 10, -1, -2, 17, 3, 10
length: .word 6

.text

    la $a0, array #$a0 is base array address
    lw $a1, length #$a1 is length
    addi $sp, $0, 0x7fffeffc

    jal MergeSort
    
    #Halt program
    li $v0, 10
    syscall
   
MergeSort:
#Recursive part of merge sort. Divides Array.

    addi $sp, $sp, -16 #Push 16 bytes on stack
    sw $ra, 0($sp) #Store return address on stack
    sw $a0, 4($sp) #Store array base address on stack
    sw $a1, 8($sp) #Store array length on stack

    ble	$a1, 1, BaseCase #If array is 0 or 1 element the base case is reached
    
    srl	$a1, $a1, 1 #Divide array length by 2
    sw $a1, 12($sp) #Store mid point on stack
    
    jal	MergeSort #Recursively call first half
    
    lw	$a0, 12($sp) #Restore midpoint
    lw $a1, 8($sp) #Restore length of array
    
    sub $a1, $a1, $a0 #Get length of second half
    
    sll $a0, $a0, 2 #Multiply $a0 by 4
    lw  $t0, 4($sp) #$t0 is array base address
    add $a0, $a0, $t0 #$a0 is mid point address
    
    jal MergeSort #Recursively call second half
    
    lw $a0, 4($sp) #Load base address into $a0
    
    lw $a1, 12($sp) #Load mid point into $a1
    sll $a1, $a1, 2 #Multiply $a1 by 4
    add $a1, $a1, $a0 #Get midpoint address
    
    lw $a2, 8($sp) #Load array length into $a2
    sll $a2, $a2, 2 #Multiply $a2 by 4
    add $a2, $a2, $a0 #Ending array address
    
    jal Merge
    
BaseCase:
    lw $ra, 0($sp) #Restore $ra
    addi $sp, $sp, 16 #Pop stack
    jr $ra #Return
    
Merge:
#Merges 2 arrays together. $a0 is first array starting address. $a1 is second array starting address. $a2 is end address for second array.

    addi $sp, $sp, -16 #Push 16 bytes on stack
    sw $ra, 0($sp) #Store return address on stack
    sw $a0, 4($sp) #Store start address on stack
    sw $a1, 8($sp) #Store midpoint address on stack
    sw $a2, 12($sp) #Store end address on stack
	
    add $s0, $0, $a0 #Copy first array starting address
    add $s1, $0, $a1 #Copy second array starting address
mergeloop:
    lw $t0, 0($s0) #Load the first array position value
    lw $t1, 0($s1) #Load the second array position value
	
    bgt $t1, $t0, dontMoveElement #If $t1<$t0 don't need to move elements
    add $a0, $0, $s1 #$a0 = argument for the element to move
    add $a1, $0, $s0 #$a1 = argument for the address to move it to
    jal MoveElement #Move element to the new position 
	
    addi $s1, $s1, 4 #Increment the second array
dontMoveElement:
    addi $s0, $s0, 4 #Increment the first array
	
    lw $a2, 12($sp) #Reload the end address
    bge $s0, $a2, end	#Make sure both arrays are empty
    bge $s1, $a2, end
    j mergeloop #If both arrays are not empty loop again
	
end:
    lw $ra, 0($sp) #Reload the return address
    addi $sp, $sp, 16 #Pop the stack
    jr $ra #Return 


MoveElement:
    #Move array element to lower address. $a0 is address of element. $a1 is address to shift to
    
    ble	$a0, $a1, return #If we are at the location then return
    lw $t0, 0($a0) #Get current value
    addi $a0, $a0, -4 #Get previous address
    lw $t1, 0($a0) #Get previous value
    sw $t0, 0($a0) #Move current value to previous value 
    sw $t1, 4($a0) #Move previous value to current value
    j MoveElement #Loop
return:
    jr	$ra # Return
