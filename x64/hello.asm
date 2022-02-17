section .bss
section .data
    sSizeReq    db  'Belo belo', 0
section .text
global _start
_start:
    mov     rbp, rsp

    mov     rdi, 1
    mov     rsi, sSizeReq
    mov     rdx, 25
    mov     rax, 1
    syscall

    mov     rdi, 0
    mov     rax, 60
    syscall
   

