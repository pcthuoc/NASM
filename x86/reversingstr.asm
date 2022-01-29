%include 	'func.asm'
section .bss
    input   resb    100
section .text
    global _start
_start:
    push	100
	push	input
	call	readConsole

    push    eax

    push    input
    call    re_str

    push    input   
    call    writeConsole

    call    exitProcess



