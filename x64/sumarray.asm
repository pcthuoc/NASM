%include 	'function.asm'
section .bss
    size  resb    100
    arr   resb    1000
section .data
    msg    db  'size:',0
    space    db  '  ',0

section .text
    global _start
_start:
    mov     rbp,rsp
    sub     rsp,28h

    mov     rdi, 1
    mov     rsi, msg
    mov     rdx, 6
    mov     rax, 1
    syscall
    .read_size:
        mov     rdi,0
        mov     rsi,size
        mov     rdx,10
        mov     rax,0
        syscall

        mov     rdi,size
        call    atoi
        cmp     rbx,-1              ; check empty string
        je      .read_size
        mov     r8,rax
        mov     rbx,0
        mov     [rbp-08h],rbx       ; sum even
        mov     [rbp-10h],rbx       ; sum odd
    ; read array
    .read_array:
        mov     rdi,0
        mov     rsi,arr
        mov     rdx,1000
        mov     rax,0
        syscall    
        mov     rdi,arr             ; move adrr
    .continue:
        call    atoi
        cmp     rbx,-1              ; check empty string
        je      .read_array
        dec     r8                  ; dec size--
        cmp     r8,0                    ; check size =0 done
        jz      .done
        mov     rbx,rax
        and     rax,1
        cmp     al,1
        jz      .sum_odd
        mov     rax,[rbp-10h]
        add     rax,rbx
        mov     [rbp-10h],rax
        cmp     byte[rdi],0xa   ; check if [arr]= "\n" and size !=0  => read new input 
        jz      .read_array 
        jmp     .continue
    .sum_odd:
        mov     rax,[rbp-10h]
        add     rax,rbx
        mov     [rbp-10h],rax
        cmp     byte[rdi],0xa   ; check if [arr]= "\n" and size !=0  => read new input 
        jz      .read_array 
        jmp     .continue
    .done:
    mov     rdi,[rbp-10h]
    call    itoa
    mov     rdi,1
    ;adrr = rsi
    mov     rdx,rax
    mov     rax,1
    syscall  
    ;print space
    mov     rdi, 1
    mov     rsi, space
    mov     rdx, 6
    mov     rax, 1
    syscall
    mov     rdi,[rbp-08h]
    call    itoa
    mov     rdi,1
    ;adrr = rsi
    mov     rdx,rax
    mov     rax,1
    syscall   
    add     rsp,28h 
    mov     rdi,0
    mov     rax,60
    syscall
atoi:; rdi =adrr
    push    rbp
    mov     rbp,rsp
    push    rdx
    mov     rbx,10
    xor     rax,rax
    xor     rcx,rcx
    .lap0:               ; skip  value space and string empty
        xor     rdx,rdx
        mov     dl,[rdi]
        cmp     dl,0ah  ; check     endl
        jz      .end1
        cmp     dl,20h  ; if array[i] !=" "
        jnz      .lap1
        inc     rdi
        jmp     .lap0
    .end1:
        xor     rbx,rbx
        mov     rbx,-1
        jmp     .done           ; return with  empty string
    .lap1:
        xor     rdx,rdx
        mov     dl,[rdi]
        cmp     dl,0xa
        jz      .done
        inc     rdi 
        cmp     dl,20h
        jnz     .next
        mov     dl,[rdi]
        cmp     dl,20h
        jz      .lap1
        jmp     .done
    .next:
        push    rdx
        imul    rbx
        pop     rdx
        sub     dl,30h
        add     rax,rdx
        jmp     .lap1
    .done:
        pop     rdx
        mov     rsp,rbp
        pop     rbp
        ret     

itoa: ; number rdi = n, ret len = rax, adrr in rsi
; 
	push	rbp
	mov	    rbp, rsp
	push	rcx
	push	rdx
    push    rbx
	mov	    ebx, edi

	; dynamic memory allocation
	; the brk() system call returns current break address if failed
	; if success, brk() returns new break address.  
	; sys_brk(0)
	mov	    rax, 12
	test	rdi, rdi	
	syscall		
	; sys_brk(current_break + 10)
	mov	    rdi, rax
	add	    rdi, 10
	mov	    rax, 12
	syscall
	dec	    rax
	mov	    rsi, rax					; rsi = *(str + 9)
	mov	    eax, ebx					; eax = n
	mov	    rdi, rsi					
	mov	    ebx, 10

	.lap0:
        xor	    edx, edx
        div	    ebx						; n % 10
        or	    dl, 30h					; dl += 48
        mov	    [rdi], dl					
        dec	    rdi
        test	eax, eax
        jz	    .lap1
        jmp	    .lap0

	.lap1:
        sub	    rsi, rdi
        mov	    rax, rsi					; rax = len
        mov	    rsi, rdi
        inc	    rsi
        pop	    rbx
        pop     rdx
        pop     rcx
        leave
	ret