;readConsole:
;   push len
;   push string 
;   =>>> len tring =eax
;--------------------------
;writeConsole;
;   push len string
;   push string
;--------------------------
;atoi:
;   push string
;   =>>>> eax=int(string)
;--------------------------
;itoa:
;   push string
;   push number
;   =>>>eax=len string
;----------------------------
; strcopy   
;   push    vt
;   push    len
;   push    string_out
;   push    string_in
;------------------------------
;strlen
;   push string
;   ==>>>   eax=len
;------------------------------
;strcat
;   push len (s1)
;   push    s2
;   push    s1
;   ==>>> s1
;------------------------------
;re_str	
;	push	string
; +>>>>>>>>>>>>

readConsole:
	push	ebp
	mov	ebp, esp
	push	edx
	push	ecx
	push	ebx
	
	mov	edx, [ebp + 0xc]
	mov	ecx, [ebp + 8]
	mov	ebx, 0
	mov	eax, 3
	int 	0x80

	pop	ebx
	pop	ecx
	pop	edx
	mov	esp, ebp	
	pop	ebp
	ret	8

writeConsole:
	push	ebp
	mov	ebp, esp
	push	edx
	push	ecx
	push	ebx

	mov	edx, [ebp + 0xc]
	mov	ecx, [ebp + 8]
	mov	ebx, 1
	mov	eax, 4
	int 	0x80

	pop	ebx
	pop	ecx
	pop	edx
	mov	esp, ebp
	pop	ebp
	ret	8

exitProcess:
	mov	ebx, 0
	mov	eax, 1
	int 	0x80

toUpper:
        push    ebp
        mov     ebp, esp
        push    esi

        mov     esi, [ebp + 8]
        xor     eax, eax
        
        .iter:
        mov     al, [esi]
	inc	esi
        cmp     al, 0xa       	; if null
        jz      .done
	cmp	al, 'a'
	jl	.iter
	cmp	al, 'z'
	jg	.iter
	xor	al, 0x20
	dec	esi
        mov     [esi], al
        inc     esi
        jmp     .iter
        
        .done:
        mov     eax, [ebp + 8]
        pop     esi
        mov     esp, ebp
        pop     ebp
        ret	4

atoi:
	push	ebp
	mov	ebp, esp
	push	esi
	push	edx
	push	ebx

	mov	esi, [ebp + 8]
	xor	eax, eax
	mov	ebx, 10
	
	.iter:
        mul	ebx
        mov	dl, [esi]
        inc	esi
        cmp	dl, 0xa
        jz	.done
        and	dl, 0xf
        add	eax, edx
        jmp	.iter

	.done:
	xor	edx, edx	
	div	ebx
	pop	ebx
	pop	edx
	pop	esi
	mov	esp, ebp
	pop	ebp	
	ret	4

itoa:
	push	ebp	
	mov	ebp, esp
	push	edi
	push	edx
	push	ebx

	mov	edi, [ebp + 0xc]
	add	edi, 9
	mov	byte [edi], 0xa
	dec	edi
	mov	eax, [ebp + 8]
	mov	ebx, 10
	
	.iter:
	xor	edx, edx
	div	ebx
	or	dl, 30h
	mov	[edi], dl
	dec	edi
	test	eax, eax
	jz	.done
	jmp	.iter

	.done:
	add	edi, 9
	sub	edi, [ebp + 0xc]
	mov	eax, edi
	pop	ebx
	pop	edx
	pop	edi
	mov	esp, ebp
	pop	ebp
	ret	8

strcopy:
    push    ebp
    mov     ebp,esp
    push    edi
    push    esi

    mov     edi,[ebp+8]     ; in
    mov     esi,[ebp+0xC]   ; out
    mov     ecx,[ebp+0x10]  ; len
    mov     edx,[ebp+0x14]  ;vt
    xor     eax,eax
    .iter:
        cmp     ecx,0
        jz      .done
        mov     al,[edi+edx]   
        mov     [esi],al
        inc     esi
        inc     edx
        dec     ecx
        jmp     .iter
    .done:
        ;mov     [esi],0xa
        pop     esi
        pop     edi
        mov     esp,ebp
        pop     ebp
        ret     16


strlen:
    push    ebp
    mov     ebp, esp
    mov     edi, [ebp + 8]
    mov     ecx, 0ffffffffh
    xor     al, al
    repne   scasb 
    sub     edi, [ebp + 8]
    dec     edi
    mov     eax, edi
    dec     eax
    mov     esp, ebp
    pop     ebp
    ret     4

strcat:
    push    ebp
    mov     ebp,esp
    push    edi
    push    esi
    

    mov     edi,[ebp+8]     ;s1
    mov     esi,[ebp+0xc]   ;s2
    mov     eax,[ebp+0x10]  ;len(s1)
    xor     edx,edx
    .iter:
        mov     dl,[esi]
        cmp     dl,0xa
        jz      .done
        mov     [edi+eax],dl
        inc     esi
        inc     eax
        jmp     .iter

    .done:
        pop     esi
        pop     edi
        mov     esp,ebp
        pop     ebp
        ret     12

re_str:
    push    ebp
    mov     ebp, esp
    push    esi
    push    edi
    mov     esi,[ebp+8]
    xor     ecx,ecx
    .iter:
        xor     edx,edx
        mov     dl,[esi+ecx]
        cmp     dl,0xa
        jz      .pop1    
        inc     ecx
        push    edx
        jmp     .iter
    .pop1:
        xor     edx,edx
        pop     edx
        mov     [esi],dl
        inc     esi
        dec     ecx
        cmp     ecx,0
        jz      .done
        jmp     .pop1
    .done:
        mov     esp,ebp
        pop     ebp
        ret     4    
