section .bss
    buffer  resb    100
section .data
    msg   db  'nhap', 0
section .text
global _start
_start:
    mov     rbp,rsp

    mov     rdi,1
    mov     rsi,msg
    mov     rdx,25
    mov     rax,1
    syscall

    mov     rdi,0
    mov     rsi,buffer
    mov     rdx,10
    mov     rax,0
    syscall 
    
    mov     rdi,1
    mov     rsi,buffer
    mov     rdx,30
    mov     rax,1
    syscall

    mov     rdi,0
    mov     rax,60
    syscall 
