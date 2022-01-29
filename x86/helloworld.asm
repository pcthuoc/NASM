section .data
	msg	db	'Hello, World!', 0Ah

section .text
    global _start
_start:
	mov	ebx, 1	
	mov	ecx, msg    ;ecx = addr msg
	mov	edx, 14	    ; edx = number of chars written
	mov	eax, 4	    ; invoke SYS_WRITE
	int 	0x80	; request software interrupt

	mov	ebx, 0
	mov	eax, 1	    ; EXIT
	int	0x80