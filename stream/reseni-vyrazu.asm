%include "rw32-2018.inc"

section .data
    ; zde budou vase data

section .text
; __cdecl double calcExpr(double x, double y)
calcExpr:
    push ebp
    mov ebp, esp
    
    finit               ;   st0   |   st1   |   st2   |   st3   |
    fld qword [ebp+16]  ;    y    |
    
    push __float32__(5.625)
    fld dword [esp]     ;  5.625  |    y    |
    add esp, 4
    
    fdivp st1, st0      ; y/5.625 |
    fld qword [ebp+8]   ;    x    | y/5.625 |
    faddp               ;x+y/5.625|
    
    push 45
    fild dword [esp]    ;   45    |x+y...   |
    add esp, 4
    
    fdivp st1, st0      ;(x+y/~)/45|
    
    fldpi               ;   pi   |(x+y/~)/45|
    fld qword [ebp+8]   ;    x    |    pi   | nesmysl |
    fmulp               ;  pi*x   | nesmysl |
    fadd st0, st0       ; 2pi*x   | nesmysl |
    
    push 4
    fild dword [esp]    ;    4    | 2pi*x   | nesmysl |
    faddp               ; 4+2pi*x | nesmysl |
    fsin                ;sin(4+2pix)|nesmysl|
    ; potřebuju st1 - st0 => st0
    fsubp               ;    A    |

    fld qword [ebp+16]  ;    y    |    A    |
    fabs
    fsqrt
    
    fld qword [ebp+8]   ;    x    |sqrtabs y|    A    |
    ; potřebuju st0 - st1 => st0
    fsubrp              ;    B    |    A    |

    ; otestuju, jestli se st(0) == 0.0, nahraju do FLAGS a podmíněně skočím pomocí jne
    ftst
    fstsw ax
    sahf
    jne .final_div

    ; ve jmenovateli je nula, zjistím znaménko čitatele
    ; popnu B
    fstp st0, st0       ;    A    |
    fldz ; nahraju nulu ;    0    |    A    |
    fcompp ; porovnání s nulou a pop obou => prázdné FPU
    fstsw ax
    sahf
    ; if (čitatel >= 0)
    jb .negative_inf

    ; čitatel >= 0: načtu do FPU pozitivní inf a končím
    push 0x7F800000
    fld dword [esp]
    ; tady bych si měl ještě uklidit stack, ale fuck it, beztak už končím a uklidí leave
    jmp .end

.negative_inf:
    ; čitatel < 0: načtu do FPU negativní inf a končím
    push 0xFF800000
    fld dword [esp]
    jmp .end

.final_div:
    fdivp               ;   A/B
.end:
    leave ; výsledek zůstal v st0, vybavené
    ret

_main:
    push ebp
    mov ebp, esp
    sub esp, 16
    
    finit
    push __float32__(20.0)
    push -400
    
    fld dword [esp+4]
    fild dword [esp] ; st0: 19; st1: 18.3
    
    fstp qword [ebp-8] ; [ebp-8] = 19.0 double
    fstp qword [ebp-16] ; [ebp-16] = 18.3 double; fpu clear
    
    push dword [ebp-4]
    push dword [ebp-8]
    push dword [ebp-12]
    push dword [ebp-16]
    call calcExpr
    add esp, 16 ; uklidit 2*64b!
 
    call WriteDouble
    
    leave
    ret
