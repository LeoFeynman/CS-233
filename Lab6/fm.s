# add your own tests for the full machine here!
# feel free to take inspiration from all.s and/or lwbr2.s

.data
# your test data goes here
array:	.word	1	255	1024
.text
main:   addi	$10, $0, 10		# $10 = 10
	la	$2, array   		# $2  = 0x10010000
	lw	$3, 0($2)		# $3  = 1
	lw	$4, 4($2)		# $4  = 255
	beq	$4, $10, equal		# branch not taken

	addi	$11, $0, 1		# $11 = 1
	beq     $3, $11, equal          # branch taken 
	j	end	    		# jump to end

equal:	addi	$12, $0, 2		# $12 = 2
	addi    $11, $11, 1
	bne	$11, $12, end		# branch not taken 
	add	$14, $3, $4		# $14 = 256

end:	addi	$13, $0, 3		# $13 = 3

