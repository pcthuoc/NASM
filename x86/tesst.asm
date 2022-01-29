%include 	'func.asm'
section .bss
    array   resb    100
    count   resb    3
    x   resb    100
    y      resb    100
    min     resd  1
    max     resd  1
section .data
    space db ' ',0xa
section .text
    global _start
_start:
    
    push	100
	push	x
	call	readConsole

    push	100
	push	y
	call	readConsole

    push    x
    push    y
    call    find

    call    exitProcess

find:
    push    ebp
    mov     ebp,esp
    mov     edi,[ebp+8]
    mov     esi,[ebp+0xc]
    sub     esp,8
    mov     eax,1
    mov    [ebp-8],eax
    sub     esp,8
    mov     ecx,9
    mov     [ebp-0xc],ecx

    
    mov    eax, [ebp-8]

    mov     ebx,[ebp-0xc]


    mov     esp,ebp
    pop     ebp
    ret 8



