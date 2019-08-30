# Guessing game in MIPS assembly
# Meera Patel

.data
	intro: .asciiz "\nThink of a number between 1 and 100 and I will try to guess it!"
	guess: .asciiz "\n\nMy guess: "
	prompt: .asciiz "\nEnter 'h' if your number is higher than my guess, 'l' if it is lower, or 'x' if I got it correct: "
	success_string: .asciiz "\n\nYay, I guessed it! Number of tries: "
	error_string: .asciiz "\n\nSorry, that input isn't valid! Please start the program over and try again."
	
.text
	li $t0, 0			# initialize count to 0
	li $t1, 1			# initialize lower bound to 1
	li $t2, 100			# initialize upper bound to 100
					# t4 will be the randomly generated number
					# t5 will be the user's character input
					# t6 is the range (i.e., upper bound minus lower bound)
	
	la $a0, intro			# load address of intro string
	li $v0, 4			# print string syscall
	syscall
					
get_input:				# generates guess and prompts user
	
	addi $t0, $t0, 1		# increment count by 1
	
	# RANDOMLY GENERATES NUMBER
	sub $t6, $t2, $t1		# calculate range
	addi $t6, $t6, 1
	
	la $a1, ($t6)			# set range
	li $v0, 42			# generate random number
	syscall
	
	move $t4, $a0			# store random number in t4
	add $t4, $t4, $t1		# adjust random number for lower bound
	
	la $a0, guess			# load address of guess string
	li $v0, 4			# print string syscall
	syscall
	
	la $a0, ($t4)			# load address of random number guess
	li $v0, 1			# print integer syscall
	syscall
		
	# GETS USER INPUT
	la $a0, prompt			# load address of prompt
	li $v0, 4			# print string syscall
	syscall

	li $v0, 12			# read char syscall
	syscall
	move $t5, $v0			# store the user's input in t5
	
	beq $t5, 'x', finish		# if the guess is correct, jump to finish
	beq $t5, 'h', higher		# if the user's number is higher, jump to higher
	beq $t5, 'l', lower		# if the user's number is lower, jump to lower
	j error				# if user's input is not h, l, or x, jump to an error message
	
lower:
	subi $t2, $t4, 1		# change upper bound
	j get_input

higher:
	addi $t1, $t4, 1		# change lower bound
	j get_input
					
finish:
	la $a0, success_string		# load address of success_string
	li $v0, 4			# print string syscall
	syscall
	
	move $a0, $t0			# copy count (t0) to a0 register as a parameter, for printing
	li $v0, 1			# print integer syscall
	syscall
	
	j end
	
error:
	la $a0, error_string		# load address of error_string
	li $v0, 4			# print string syscall
	syscall
	
end:
	# program finishes running (drops off bottom)
