%include 	'func.asm'
section .bss
    num1    resb    32
    num2    resb    32
    sum     resb    32

section .text
    global _start
_start:
	push	32
	push	num1
	call	readConsole
	push	32
	push    num2
	call	readConsole

	push	num1
	call	atoi
	mov	    edx, eax
	push	num2
	call	atoi
	add	    eax, edx
	push	sum
	push	eax
	call	itoa
	
	push	eax
	push	sum
	call	writeConsole
	
	call	exitProcess