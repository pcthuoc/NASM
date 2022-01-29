section .bss
    msg     resb    32
section .text    
    global  _start
_start:
    ;read 
    mov     edx, 32         ;read 32 bytes
    mov     ecx, msg        ; addr msg
    mov     ebx, 0          ; stdin
    mov     eax,3           ; call read
    int     0x80

    ;write
    push    eax             ; number of bytes read
    mov     ecx,msg         ; addr msg
    pop     edx             ; edx = number of bytes read
    mov     ebx,1           ; sdtout
    mov     eax,4           ; call write
    int     0x80
    
    mov     ebx,0
    mov     eax,1           ; exit
    int     0x80

