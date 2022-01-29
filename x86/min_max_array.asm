%include 	'func.asm'
section .bss
    array   resb    100
    input   resb    100
    check   resb    100
    min     resb    100
    max     resb    100
section .data
    space db ' ',0xa
section .text
    global _start
_start:
    push    100
    push    input
    call    readConsole

    push    array
    push    input
    call    delete_space               

    push    array
    call    find
    
    push    eax     ;value array min  

    push    max
    push    ebx     ;max
    call    itoa    
    push    eax     ; len ( max)
    push    max
    call    writeConsole
    ;  print min
    pop     eax
    push    min
    push    eax
    call    itoa
    push    eax
    push    min
    call    writeConsole

    call    exitProcess
delete_space:
    push    ebp
    mov     ebp,esp
    mov     edi,[ebp+8]         ;input
    mov     esi,[ebp+0xc]       ;array
    
    xor     ecx,ecx

    .iter:
        mov     dl,[edi]
        inc     edi
        cmp     dl,0xa              ;if dl= 0xa done
        jz     .done
        cmp     dl,0x20             ; check space
        jnz     .next_insert  
        cmp     ecx,0               ; check array[0]== space ==> not insert
        jz      .iter
        mov     al,[edi-2]          ; check array[i-1]==space if array[i]== space
        cmp     al,0x20
        jz      .iter
    .next_insert:
        mov     [esi],dl
        inc     ecx
        inc     esi
        jmp     .iter

    .done:
    mov     dl,0xa
    mov     [esi],dl
    mov     esp,ebp
    pop     ebp
    ret     8

find:
    push    ebp
    mov     ebp,esp
    mov     esi,[ebp+8]         ; addr array
    

    xor     eax,eax;  
    sub     esp,8
    mov     [ebp-8],eax         ; min
    sub     esp,8
    mov     [ebp-0xc],eax       ; max

    mov     ebx,10

    ; find array[0]  mov array[0]=min  mov array[0]=max     
    .iter1:;  func atoi
        mov     dl,[esi]
        cmp     dl,0xa
        jz      .max_min
        inc     esi
        cmp     dl,0x20
        jz      .max_min
        push    edx
        mul     ebx
        pop     edx
        sub	    dl, 30h
        add     eax,edx
        jmp     .iter1
    
    .max_min:   
        mov     [ebp-8],eax         ; min=arr[0]
        mov     [ebp-0xc],eax       ; max=arr[0]
        xor     eax,eax
        cmp     dl,0xa
        jz      .done
    .iter:      ; func atoi
        mov     dl,[esi]
        inc     esi
        cmp     dl,0x20
        jz      .compare
        cmp     dl,0xa
        jz      .compare
        push    edx
        mul     ebx
        pop     edx
        sub     dl,30h
        add     eax,edx
        jmp     .iter
    
    .compare:
        cmp     [ebp-8],eax     ; if min<eax =>> next
        jl      .next1
        mov     [ebp-8],eax
    .next1:
        cmp     [ebp-0xc],eax   ; if max>eax ==>> next
        jg      .next2
        mov     [ebp-0xc],eax
    .next2:
        xor     eax,eax
        mov     bl,10
        cmp     dl,0xa
        jz      .done
        jmp     .iter
        
    .done:
        xor     eax,eax
        xor     ebx,ebx
        mov     eax,[ebp-8]         ; min
        mov     ebx,[ebp-0xc]       ; max
        mov     esp,ebp
        pop     ebp
        ret     4






