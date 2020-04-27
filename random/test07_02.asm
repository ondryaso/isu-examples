%include "rw32-2018.inc"

section .data
    one db "jedna",0
    zero db "nula",0
    sepC db ", ",0
    sepA db " a ",0

section .text

words:
    push ebp
    mov ebp, esp
    push ecx
    
    xor ax, ax
    xor ecx, ecx
    mov al, byte [ebp+8]
    
    cmp al, 0
    jne .run
    mov esi, zero
    call WriteString
    jmp .exit
    
.run:
    bsr cx, ax
    sub cx, 15
    neg cx
    
    shl ax, cl
.cycle:
    shl ax, 1
    jnc .cycle_zero
    mov esi, one
    call WriteString
    jmp .cycle_cond    
.cycle_zero:
    mov esi, zero
    call WriteString
.cycle_cond:
    cmp cx, 14
    jb .cycle_cond_sepC
    je .cycle_cond_sepA
    ja .cycle_cond_1
.cycle_cond_sepC:
    mov esi, sepC
    call WriteString
    jmp .cycle_cond_1
.cycle_cond_sepA:
    mov esi, sepA
    call WriteString
.cycle_cond_1:
    inc cx
    cmp cx, 16
    jne .cycle
.exit:
    pop ecx
    leave
    ret

one_bits:
    push ebp
    mov ebp, esp
    push ecx
    
    xor al, al
    mov cl, byte [ebp+8]

.calc_bit:
    shr cl, 1
    jz .calc_end
    jnc .calc_bit
    inc al
    jmp .calc_bit
.calc_end:
    jnc .calc_res
    inc al
.calc_res:
    call WriteUInt8

    pop ecx
    leave
    ret

parity_:
    push ebp
    mov ebp, esp
    
    mov al, byte [ebp+8]
    test al, 1
    jnz .odd
    xor al, al
    jmp .res
.odd:
    mov al, 1
.res:
    call WriteUInt8
    
    leave
    ret

parity:
    push ebp
    mov ebp, esp
    push ecx
    
    mov al, byte [ebp+8]
    test al, 0xff
    jnp .odd
    xor al, al
    jmp .res
.odd:
    mov al, 1
.res:
    call WriteUInt8

    pop ecx
    leave
    ret

reverse_bits:
    push ebp
    mov ebp, esp
    push ecx
    
    mov al, byte [ebp+8]
    xor ah, ah
    
    mov ecx, 8
    
.set_bit:    
    shl al, 1
    jnc .set_bit_loop
    inc ah
.set_bit_loop:
    ror ah, 1
    loop .set_bit
    
    mov al, ah
    call WriteUInt8
    
    pop ecx
    leave
    ret

_main:
    push ebp
    mov ebp, esp
    
    call ReadUInt8
    mov dl, al
    xor eax, eax
    call ReadUInt8
    push eax
    
    cmp dl, 0
    jne .dln0
    call reverse_bits
    jmp .exit
.dln0:
    cmp dl, 1
    jne .dln1
    call parity
    jmp .exit
.dln1:
    cmp dl, 2
    jne .exit
    call words
.exit:
    add esp, 4

    pop ebp
    mov eax, 0
    ret