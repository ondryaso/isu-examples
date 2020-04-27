%include "rw32-2018.inc"

section .data
    ; zde budou vase data

section .text
_main:
    push ebp
    mov ebp, esp
    
    xor bl, bl
.cycle:
    call ReadChar
    cmp eax, -1
    je .end
    
    cmp al, 's'
    je .cycle
    
    test bl, bl
    jnz .skip_writechar
    call WriteChar
.skip_writechar:
    cmp al, 'X'
    je .end
    
    cmp al, 'w'
    jne .cycle
    
    not bl
    jmp .cycle
    
.end:
    mov esp, ebp
    pop ebp
    ret