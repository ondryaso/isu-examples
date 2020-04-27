%include "rw32-2018.inc"

; long int strtol (const char* str, char** endptr, int base);
;CEXTERN strtol

section .data
    pNumStr db ' 155asddf3Fa&50  7',0
    pEndPtr dd 0

section .text
_main:
    push ebp
    mov ebp, esp
    
.read:
    mov eax, pNumStr
    push dword 16
    push pEndPtr
    push eax
    call strtol
    add esp, 12
    
    call WriteHex32
    call WriteNewLine
    
    mov ebx, [pEndPtr]
    cmp [ebx], 0
    jne .read

    pop ebp
    ret