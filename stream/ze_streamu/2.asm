%include "rw32-2020.inc"

section .data
    ; zde budou vase data

section .text
; __cdecl float task2(double x, double y)
task2:
    push ebp
    mov ebp, esp
     
    finit                   ;   st0   |   st1   |   st2   |   st3   |
    fld qword [ebp+16]      ;    y    |
    
    push __float32__(5.625)
    fld dword [esp]         ;  5.625  |    y    |
    add esp, 4
    
    fdivp st1, st0          ; y/5.625 |
    fld qword [ebp+8]       ;    x    | y/5.625 |
    faddp                   ;x+y/5.625|
    
    push 45
    fild dword [esp]        ;   45    |x+y/5.625|
    add esp, 4
    
    fdivp st1, st0          ;(x+y/~)/45|
    
    fldpi                   ;   pi    |(x+y/~)/45|
    fld qword [ebp+8]       ;    x    |    pi   | nesmysl |
    fmulp                   ;  pi*x   | nesmysl |
    fadd st0, st0           ; 2pi*x   | nesmysl |
    
    push 4
    fild dword [esp]        ;    4    | 2pi*x   | nesmysl |
    add esp, 4
    faddp                   ; 4+2pi*x | nesmysl |
    
    fsin                    ;sin(4+2pix)|nesmysl|
    fsubp                   ;    A    |
    
    fld qword [ebp+16]      ;    y    |    A    |
    fabs                    ;  abs(y) |    A    |
    fsqrt                   ;sqrtabsy |    A    |

    fld qword [ebp+8]       ;    x    |sqrtabs y|    A    |
    fsubrp                  ;    B    |    A
    fdivp                   ;   A/B   |
    
    leave
    ret

_main:
    push ebp
    mov ebp, esp
    sub esp, 16
    
    finit
    
    push 20   ; x
    push 20 ; y
    fild dword [esp+4] ; st0: 20.0
    fild dword [esp]   ; st0: -400.0; st1: 20.0
    fstp qword [ebp-16] ; [ebp-16]: double -400.0
    fstp qword [ebp-8]
    add esp, 8
    
    push dword [ebp-12]
    push dword [ebp-16]
    push dword [ebp-4]
    push dword [ebp-8]
    call task2
    add esp, 16
    
    call WriteDouble
 
    xor eax, eax
    
    leave
    ret