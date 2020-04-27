%include "rw32-2020.inc"
CEXTERN qsort

section .data
    pFloatArr dd 13.8,14.0,11.5,11.55,1.3,85.2,92.0,10.2

section .text

; __cdecl int float_comp(float *p1, float *p2)
float_comp:
    push ebp
    mov ebp, esp
    push ebx
    
    mov eax, [ebp+8]  ; adresa p1, hodnota pointeru *p1, adresa, na které leží ten float
    mov ebx, [ebp+12] ; adresa p2, hodnota pointeru *p2
                      ;  st0  |  st1  |
    fld dword [eax]   ;  *p1  |
    fld dword [ebx]   ;  *p2  |  *p1  |
    
    fcompp            ; ----- | ----- |
    fstsw ax
    
    and ah, 0b01000101 ; 0x43
    rol ah, 2
    sub ah, 1
    movsx eax, ah
    
    pop ebx
    leave
    ret

_main:
    push ebp
    mov ebp, esp
    
    finit
    ; call qsort(void *array, size_t n, size_t sizeOfElement, *ptr to comp func)
    push float_comp
    push dword 4
    push dword 8
    push dword pFloatArr
    call qsort
    add esp, 16

    leave
    ret