%include "rw32-2018.inc"

section .data
    ; zde budou vase data

section .text
_main:
    push ebp
    mov ebp, esp
    
    mov eax, 0x44332211
    ror eax, 8
    xchg ah, al
    ror eax, 8

    pop ebp
    ret