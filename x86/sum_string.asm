%include 	'func.asm'
section .bss
    x   resb    100
    y   resb    100


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
    call    re_str
    push    y
    call    re_str

    push    x
    push    y
    call    sum

    push    eax
    push    y
    call    writeConsole

    call    exitProcess 

sum:
    push    ebp
    mov     ebp,esp
    push    esi
    push    edi
    mov     esi,[ebp+8]     ; y
    mov     edi,[ebp+0xc]   ;x
    mov     ebx,esi 
    mov     eax,edi 

    xor     ecx,ecx     ; nho
    push    69h
    .iter:
        xor     edx,edx
        mov     dl,[edi]                ;dl=x[i]
        mov     dh,[esi]                ;dh=y[i]       
        inc     edi
        inc     esi
        cmp     dl,0xa
        jnz     .next1
        mov     dl,30h                  ; check dl == 0xa (end)
        dec     edi
    .next1:
        cmp     dh,0xa                  ; check dh == 0xa (end)
        jnz     .next2
        dec     esi
        mov     dh,30h
    .next2:
        sub     dl,0x30         ; convert asci  to int
        sub     dh,0x30
        add     dl,dh
        xor     dh,dh 

        add     edx,ecx         ; add nho
        xor     ecx,ecx
        
        cmp     dl,0
        jz      .end_push   
        cmp     dl,10
        jl      .notsub       ; if dl >=10    dl=dl-10
        mov     ecx,1
        sub     edx,10
    .notsub:
        add     dl,0x30
        push    edx 
        jmp     .iter
    .end_push:
        mov     esi,ebx;    y
        mov     edi,eax;    x
    
    .pop1:
        xor     edx,edx
        pop     edx
        cmp     edx,69h
        jz      .done
        mov     [esi],dl
        inc     esi
        jmp     .pop1

    .done:
        mov     eax,esi
        sub     eax,ebx      
        pop     edi
        pop     esi
        mov     esp,ebp
        pop     ebp
        ret     8









