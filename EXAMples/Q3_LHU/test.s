.data
array:	.word	0x12345678	0xbaadf00d

# every register starts holding the address of "array"
#
# this is a cheat so that we don't need to implement addi and lui in
# our machine.

.text
main:
	# remember that we're little endian
	lhu	$2, 0($20)
	lhu	$3, 2($20)
	lhu	$4, 4($20)
	lhu	$5, 6($20)
