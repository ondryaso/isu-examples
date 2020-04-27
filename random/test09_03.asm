%include "rw32-2018.inc"

section .data
    ; zde budou vase data
    pTestArr dw 15,900,900,8,96,108,108,96,0

section .text
_main:
    push ebp
    mov ebp, esp
    
    push ebp
    mov ebp, esp
    
    mov edi, pTestArr
    
    mov ecx, -1
    mov ax, 0

    cld
    repne scasw
    
    neg ecx
    dec ecx
    dec ecx
    
    ; we now have the length of the array in ecx
    ; reserve space on the stack
    
    sub esp, ecx
    sub esp, ecx
    
    mov 
    
    pop ebp
    
    
    pop ebp
    ret