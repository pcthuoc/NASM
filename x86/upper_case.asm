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

    push    eax             ; number of bytes read

    push    msg
    call    toUpper
    ;write
    mov     ecx,msg         ; addr msg
    pop     edx             ; edx = number of bytes read
    mov     ebx,1           ; sdtout
    mov     eax,4           ; call write
    int     0x80
    
    mov     ebx,0
    mov     eax,1           ; exit
    int     0x80
toUpper:
        push    ebp
        mov     ebp, esp
        push    edi
        mov     edi, [ebp + 8]
        xor     eax, eax      
        .upcase:
            mov     al, [edi]
	        inc	    edi
            cmp     al, 0xa       ; check null
            jz      .done
	        cmp	    al, 'a'
	        jl      .upcase
	        cmp	    al, 'z'
	        jg	    .upcase
            xor	    al, 0x20
            dec	    edi
            mov     [edi], al
            inc     edi
            jmp     .upcase    
        .done:
            pop     edi
            mov     esp, ebp
            pop     ebp
            ret	    4
    
    


