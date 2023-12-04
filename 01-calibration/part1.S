	.global main

	.text
main:
	mov $0, %r8  # sum of calibration digits
	sub $1, %rsp

	/* set up the read() syscall */
	mov $0, %rdi    # rdi <- uint fd (stdin: 0)
	mov %rsp, %rsi  # rsi <- char* buf

line_loop:
	mov $1, %rdx    # rdx <- size_t count

	mov $0, %r9  # first digit
	mov $0xFFFFFFFFFFFFFFFF, %r10 # second digit

char_loop:
	/* call read() to get character from stdin */
	mov $0, %rax
	syscall

	/* if no characters read, go to end of program */
	test %rax, %rax
	jz end

	/* if the character is a newline, add digits and start a new line */
	cmpb $0x0A, (%rsp)
	jz newline

	subb $0x30, (%rsp)
	cmpb $10, (%rsp)
	jge char_loop # not a digit, read another char

	cmpq $0xFFFFFFFFFFFFFFFF, %r10
	movzbq (%rsp), %r10
	jne skip_set_first_digit
	movzbq (%rsp), %r9

skip_set_first_digit:
	jmp char_loop

newline:
	cmpq $0xFFFFFFFFFFFFFFFF, %r10
	jnz add_digits
	/* second digit is not set, copy the first digit into its register */
	mov %r9, %r10

add_digits:
	mov $10, %rax
	mulq %r9
	add %r10, %rax
	add %rax, %r8 # %r8 += ((%r9 * 10) + %r10)
	jmp line_loop

end:
	sub $7, %rsp
	movq %r8, (%rsp)

	/* set up a write() syscall to write the sum out */
	mov $1, %rdi
	mov %rsp, %rsi
	mov $8, %rdx
	mov $1, %rax
	syscall

	/* exit gracefully */
	mov $60, %rax
	mov $0, %rdi
	syscall
