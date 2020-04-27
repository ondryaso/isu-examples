%include "rw32-2020.inc"
CEXTERN qsort

section .data
    pFloatArr dd 13.8,14.0,11.5,11.55,1.3,85.2,92.0,10.2

section .text

float_comparator: ; __cdecl int float_comparator(float *p1, float *p2)
    push ebp
    mov ebp, esp
    push ebx

    mov eax, [ebp + 8] ; eax = p1
    mov ebx, [ebp + 12] ; ebx = p2
    ; presume clear FPU: ;  st0  |  st1  |
    fld dword [eax]      ; (p1)  |
    fld dword [ebx]      ; (p2)  | (p1)  |
    
   ; fcompp               ; ----- | ----- |
   ; fstsw ax
    
   ; and ah, 0b01000011 ; 0x43
   ; rol ah, 2
   ; sub ah, 1
   ; movsx eax, ah

    ; nastaví EFLAGS podle p2 > p1
    xor eax, eax
    fcomip               ; (p1)  | ----- |
    ja .p2higher
    jb .p2lower
.p2higher:
    mov eax, -1
    jmp .end
.p2lower:
    mov eax, 1
.end:
    fstp st0
    pop ebx  
    leave
    ret

qsort_floats: ; __cdecl void qsort_floats(float *arrayPtr, unsigned int n)
    push ebp
    mov ebp, esp

    finit
    ; call qsort(void *array, size_t n, size_t sizeOfElement, *ptr to comp func)
    push float_comparator
    push 4
    push dword [ebp + 12]
    push dword [ebp + 8]
    call qsort
    add esp, 16

    leave
    ret

_main:
    push ebp
    mov ebp, esp
    
    push 8
    push pFloatArr
    call qsort_floats
    add esp, 8

    pop ebp
    ret