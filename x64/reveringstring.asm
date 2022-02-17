%include 	'function.asm'
section .bss
    buffer  resb    100
section .data
section .text
global _start
_start:
    mov     rbp,rsp
    
    mov     rdi,0
    mov     rsi,buffer
    mov     rdx,100
    mov     rax,0
    syscall

    mov     rsi,buffer
    call    reverse

    mov     rdi,1
    mov     rsi,buffer
    ; len string = rdi
    mov     rax,1
    syscall

    mov     rdi,0
    mov     rax,60
    syscall 
reverse:                    ; rdi = string len, 
    push    rbp
    mov     rbp,rsp

    mov     rdi,rsi         ; mov  adrr string
    mov     r8,rsi          ; save rsi
    xor     rcx,rcx         ; count
    xor     rax,rax
    cld
    .pushLoop:
        lodsb                   ; mov al = [esi++]
        cmp     al, 0xa
        jz      .popLoop
        push    rax
        inc     rcx               
        jmp     .pushLoop
    .popLoop:
        pop     rax
        stosb                      ; al = [edi++]
        dec     rcx
        test    rcx, rcx            ;  check count=0
        je      .done
        jmp     .popLoop
    
    .done:
        sub     rdi, r8            ; string len
        mov     rsp,rbp
        pop     rbp
        ret  

