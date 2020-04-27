%include "rw32-2018.inc"

section .data
    input dq 3.0

section .text
plocha:
    push ebp
    mov ebp, esp
    
    finit               ;  st0    st1   st2
    fld qword [ebp+8]   ;   a
    fmul st0, st0       ;  a^2
    
    fldpi               ;  pi     a^2
    
    push dword __float32__(5.0)
    fmul dword [esp]    ;  5pi    a^2  
    ;add esp, 4
    
    push dword __float32__(44.0)
    fadd dword [esp]    ; 44+5pi  a^2
    ;add esp, 4
    
    push dword __float32__(72.0)
    fdiv dword [esp]    ;(44+5pi)/72 a^2
    ;add esp, 4

    fmulp st1, st0      ; result
    
    mov esp, ebp
    pop ebp
    ret

_main:
    push ebp
    mov ebp, esp
    
    finit
    fld qword [input]
    sub esp, 8
    fst qword [esp]
    call plocha
    add esp, 8

    call WriteDouble
    pop ebp
    ret