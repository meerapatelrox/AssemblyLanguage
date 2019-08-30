# MMIO emulator
# Meera Patel

.text
main:
	la $s1, 0xffff0000		# load address of RCR (receiver control register; read only)
	la $s2, 0xffff0004		# load address of RDR (receiver data register; read only)
	la $s3, 0xffff0008		# load address of TCR (transmit control register; read only)
	la $s4, 0xffff000C		# load address of TDR (transmit data register; writable)
	
read_RCR:
	lb $t1, 0($s1)			# read RCR into register t1
	beq $t1, 1, read_RDR		# if RCR = 1, jump to read_RDR
	j read_RCR			# loop

read_RDR:
	lb $t2, 0($s2)			# read RDR (ASCII value) into register t2
	beq $t2, 3, end			# if t2 = 3 (ASCII value for ctrl+C), jump to end
	lb $t3, 0($s3)			# read TCR into register t3
	bne $t3, 0, write		# if t3 does not equal zero, jump to write
	j read_RDR			# loop
	
write:
	sb $t2, 0($s4)			# write ASCII value into TDR
	j read_RCR			# loop
	
end:
