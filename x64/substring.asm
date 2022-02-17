section .bss
    string      resb    100
    substring   resb    10
    buffer      resb    10
    array       resb    1000
section .data
    space       db " "
section .text
    global _start
_start:
    mov rbp,rsp
    ;read string 
    mov     rdi,0
    mov     rsi,string
    mov     rdx,100
    mov     rax,0
    syscall
    ;read substring
    mov     rdi,0
    mov     rsi,substring
    mov     rdx,10
    mov     rax,0
    syscall
    ; find vt
    mov     rdi,substring
    mov     rsi,string
    mov     rdx,array
    call    find
    ; print array
    mov     rdi,array
    call    printarray

    mov     rdi,0
    mov     rax,60
    syscall 
printarray:
    push    rbp
    mov     rbp,rsp
    mov     rbx,rdi             ; adrr array

    xor     rcx,rcx
    mov     rcx,[rdi]           ; mov size array =rcx

    .lap0:
        push    rcx
        push    rbx

        xor     edi,edi
        mov     edi,[rbx]
        call    itoa

        mov     rdi,1
        ;adrr = rsi
        mov     rdx,rax
        mov     rax,1
        syscall

        mov     rdi,1
        mov     rsi,space
        mov     rdx,2
        mov     rax,1
        syscall
        pop     rbx
        pop     rcx
        add     rbx,4
        test    rcx,rcx
        jz      .done
        dec     rcx
        jmp     .lap0
    .done:  
        mov     rsp,rbp
        pop     rbp
        ret
find:
    push    rbp
    mov     rbp,rsp
    sub     rsp,28h
    mov     [rbp-8],rsi   ; str
    mov     [rbp-10h],rdi   ; substr
    mov     [rbp-18h],rdx  ; array

    mov     rdi,[rbp-8]   ;  str[i]
    mov     rsi,[rbp-10h]   ;  substr[i]
    mov     rax,[rbp-18h]  ;  array[j]
    xor     r8,r8
    .lap0:
        mov     dl,[rdi]
        mov     dh,[rsi]
        inc     rdi
        cmp     dl,0xa      ; check end 
        jz      .done   
        cmp     dl,dh       ; check str[i] ?? substr[0]
        jz      .compare
        jmp     .lap0

    .compare:
        xor     rbx,rbx
        .lap1:
            mov     dl,[rdi+rbx]
            mov     dh,[rsi+rbx+1]
            cmp     dh,0xa
            jz      .add_array
            cmp     dl,dh
            jnz     .lap0
            inc     rbx
            jmp     .lap1
        .add_array:
            mov     rcx,rdi
            sub     rcx,[rbp-0x8]
            dec     rcx
            mov     dword[rax+4],ecx
            add     rax,4
            inc     r8
            jmp     .lap0
    .done:
        mov     rax,[rbp-18h]  
        mov     [rax],r8
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
