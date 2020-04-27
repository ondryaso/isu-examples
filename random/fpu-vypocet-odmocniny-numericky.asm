%include "rw32-2020.inc"

section .data
    ; zde budou vase data

section .text

sqrt_hloupa:
    push ebp
    mov ebp, esp

    sub esp, 8
    push 2

    push ecx

    finit
    
    fld1
    fstp qword [ebp-8] ; y_0 = 1.0, fpu clear
    
    mov ecx, 10
.calc_iter:
    fld qword [ebp-8]  ; y_i |
    fld qword [ebp+8]  ;  x  | y_i |
    fld st1            ; y_i |  x  | y_i |
    fdivp              ;x/y_i| y_i
    faddp              ;(...)|
    fild dword [ebp-12];  2  |(...)|
    fdivp              ;.../2|
    fstp qword [ebp-8]
    
    loop .calc_iter
    
    fld qword [ebp-8]
    
    pop ecx
    leave
    ret

; __cdecl double sqrt(double x)
sqrt:
    push ebp
    mov ebp, esp
    
    push 2
    push ecx

    finit
    
    fld1               ;  1

    mov ecx, 10
.calc_iter:
    fld qword [ebp+8]  ;  x  | y_i |
    fld st1            ; y_i |  x  | y_i |
    fdivp              ;x/y_i| y_i
    faddp              ;(...)|
    fild dword [ebp-4];  2  |(...)|
    fdivp              ;.../2|
    
    loop .calc_iter
    
    pop ecx
    leave
    ret
    

_main:
    push ebp
    mov ebp, esp
    finit
    
    sub esp, 4
    push __float32__(128.0)
    
    fld dword [esp]
    fstp qword [esp]
    
    call sqrt
    add esp, 8

    pop ebp
    ret