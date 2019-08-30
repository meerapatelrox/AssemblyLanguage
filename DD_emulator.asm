# dd emulator
# Meera Patel

.data
	mydata: .asciiz "Hello world!"		# mydata will be copied to a destination in memory
	
.text
main:
	la $a0, mydata				# start address of the data being copied
	la $a1, 0x100100a0			# start address of the destination
	li $a2, 8				# number of bytes to transfer
	li $a3, 1				# dry run parameter
	jal dd
	j end
dd:
	blt $a0, 0x10010000, invalid_read	# if a0 < beginning of .data memory, jump to invalid_read
	blt $a1, 0x10010000, invalid_write	# if a1 < beginning of .data memory, jump to invalid_write
	
	li $t0, 0		# t0 = 0, for keeping track of count
	li $t4, 4		# t4 = 4, for dividing
	
	# else if the data addresses are valid, then check for dry run
	beq $a3, 1, dry_run	# if a3 = 1, jump to dry_run
	
	# else if no dry run, CONTINUE ON	
	div $a2, $t4		# divide number of bytes by 4
	mfhi $t2		# store remainder in t2
	beq $t2, 0, dd_words	# if remainder equals 0, use dd for words
	j dd_bytes		# else use dd for bytes

dd_bytes:	
	beq $t0, $a2, successful_copy	# jump to successful_copy if t0 = number of bytes to transfer
	
	lb $t1, 0($a0)		# load byte from a0 into t1
	sb $t1, 0($a1)		# store byte into a1 from t1
	
	addi $a0, $a0, 1	# increment a0
	addi $a1, $a1, 1	# increment a1
	addi $t0, $t0, 1	# increment t0 (for keeping track of count)

	j dd_bytes

dd_words:	
	beq $t0, $a2, successful_copy	# jump to successful_copy if t0 = number of bytes to transfer
	
	lw $t1, 0($a0)		# load word from a0 into t1
	sw $t1, 0($a1)		# store word into a1 from t1
	
	addi $a0, $a0, 4	# increment a0
	addi $a1, $a1, 4	# increment a1
	addi $t0, $t0, 4	# increment t0 (for keeping track of count)

	j dd_words
	
dry_run:
	move $t3, $a0			# move a0 address into t3
	
	div $a2, $t4			# divide number of bytes by 4
	mfhi $t2			# store remainder in t2
	beq $t2, 0, dry_run_words	# if remainder equals 0, use word dry run
	j dry_run_bytes			# else use byte dry run
	
dry_run_bytes:
	beq $t0, $a2, sucessful_dry_run
	
	lb $t1, 0($t3)		# load byte into t1
	
	la	$a0, 91		# print [
	li	$v0, 11
	syscall

	addi	$a0, $t3,0	# display address in hex
	li	$v0, 34
	syscall
	
	la	$a0, 93		# print ]
	li	$v0, 11
	syscall
	
	addi	$a0, $t1, 0	# display value at that address in hex
	li	$v0, 34
	syscall
	
	la	$a0, 10		# print new line
	li	$v0, 11
	syscall
	
	addi $t3, $t3, 1	# increment t3 (address)
	addi $t0, $t0, 1	# increment t0 (for keeping track of count)
	
	j dry_run_bytes

dry_run_words:
	beq $t0, $a2, sucessful_dry_run
	
	lw $t1, 0($t3)		# load word into t1
	
	la	$a0, 91		# print [
	li	$v0, 11
	syscall

	addi	$a0, $t3,0	# display address in hex
	li	$v0, 34
	syscall
	
	la	$a0, 93		# print ]
	li	$v0, 11
	syscall

	addi	$a0, $t1, 0	# display value at that address in hex
	li	$v0, 34
	syscall
	
	la	$a0, 10		# print new line
	li	$v0, 11
	syscall
	
	addi $t3, $t3, 4	# increment t3 (address)
	addi $t0, $t0, 4	# increment t0 (for keeping track of count)
	
	j dry_run_words	

successful_copy:
	li $v0, 0		# return v0 = 0 when procedure is finished
	j return

sucessful_dry_run:
	li $v0, 0		# return v0 = 0 when procedure is finished
	j return

invalid_read:
	li $v0, -1		# return v0 = -1
	j return
	
invalid_write:
	li $v0, -2		# return v0 = -2
	j return

return:
	jr $ra			# return to address
	
end:
