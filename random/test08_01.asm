%include "rw32-2018.inc"

section .data
    ; zde budou vase data

section .text
_main:
    push ebp
    mov ebp, esp
    
    xor eax, eax
    call ReadUInt8
    test al, al
    jz .end

    mov ecx, eax
    
    mov ah, al
    and ah, 0b00000011
    
    test ah, ah
    jnz .cycle
    mov ah, 4
    
.cycle:
    mov al, '#'
    call WriteChar
    
    dec ah
    jnz .cycle_end
    
    cmp ecx, 1
    je .end
    
    mov ah, 4
    mov al, ' '
    call WriteChar
    
.cycle_end:
    dec ecx
    jmp .cycle

.end:
    pop ebp
    ret