%include 	'func.asm'
section .bss
    input   resb    100
    output  resb    100
    check   resb    100
    vt      resb    100
section .data
    space db ' ',0xa
section .text
    global _start
_start:
	push	100
	push	input
	call	readConsole

    push	100
	push	check
	call	readConsole

    push    check
    push    input
    call    find

    push    eax                 ; push  len (output)
    ;  print count
    push    vt
    push    ecx
    call    itoa
    push    eax
    push    vt
    call    writeConsole

    push    output
    call    writeConsole 

    call	exitProcess

find:
    push    ebp
    mov     ebp,esp
    mov     edi,[ebp+8]         ;input
    mov     esi,[ebp+0xc]         ;check
    sub     esp,8         ;
    mov     [ebp-8],edi           ; mov adress edi = [ebp]      ;
    xor     ecx,ecx             ; count substring
    push    ecx
    xor     eax,eax
    .iter:
        xor     edx,edx
        mov     dh,[esi]        ; check[i]
        mov     dl,[edi]        ; input[i]
        inc     edi
        cmp     dl,0xa          ; check end 
        jz      .done
        cmp     dl,dh           ; check input[i] ?? check[i]
        jz      .compare
        jmp     .iter

    .compare:
        xor     ebx,ebx
        mov     ebx,0
        ;dec     edi
        .iter1:
            xor     edx,edx                 ;
            mov     dh,[esi+ebx+1]          ;
            mov     dl,[edi+ebx]            ;
            cmp     dh,0xa                  ;  if ( check [i]== end )
            jz      .add_vt                 ;
            inc     ebx                     ;
            cmp     dl,dh                   ; if ( chec[ i] ??? output[i])
            jnz     .iter
            jmp     .iter1
        .add_vt:
            xor     edx,edx
            mov     edx,edi
            sub     edx,[ebp-8]
            dec     edx                 ; find vt 

            push    eax         ; push len (ouput)
            push    vt
            push    edx
            call    itoa

            pop     eax
            push    eax
            push    vt
            push    output             ; ( cat output = putput +" ")
            call    strcat

            push    eax
            push    space
            push    output         ; ( cat output = output + vt)
            call    strcat
        pop     ecx
        inc     ecx                 ;( count substring)
        push    ecx
        jmp     .iter 
    .done:
    pop     ecx
    add     esp,8
    mov     esp,ebp
    pop     ebp
    ret     8



    











 











