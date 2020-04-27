%include "rw32-2020.inc"

section .data
    inputR dd 10.0
    inputH dd 2.0

    circMsg db "Circumference: ",0
    baseSurfMsg db "Base Surface: ",0
    cylSurfMsg db "Cylinder Surface: ",0
    volMsg db "Cylinder Volume: ",0
    
section .text

; __cdecl float calcCircumference(float radius)
calcCircumference:
    push ebp
    mov ebp, esp
    
    finit               ;  st0  |  st1  |  st2  |
    fld dword [ebp+8]   ;   r   |

  ; push dword 2
  ; fmul dword [esp]
 
    fadd st0, st0       ;  2r
    fldpi               ;  pi   |  2r   |
    fmulp               ; 2pi*r |
    
    leave ; vybavené, výsledek v st0
    ret

; __cdecl float calcDiscSurface(float radius)
calcDiscSurface:
    push ebp
    mov ebp, esp
    
    finit               ;  st0  |  st1  |  st2  |
    fld dword [ebp+8]   ;   r   |
    fmul st0, st0       ;  r^2
    fldpi               ;  pi   |  r^2  |
    fmulp               ; pi*r^2|

    leave ; vybavené, výsledek v st0
    ret
    
; __cdecl float calcCylinderSurface(float radius, float height)
calcCylinderSurface:
    push ebp
    mov ebp, esp

    ; chci 2pi*r*(h+r)
    finit               ;  st0  |  st1  |  st2  |
    fld dword [ebp+8]   ;   r   |
    fld st0             ;   r   |   r   |
    fadd st0, st0       ;  2r   |   r   |
    fldpi               ;  pi   |  2r   |   r
    fmulp               ; 2pi*r |   r   |
    fld dword [ebp+12]  ;   h   | 2pi*r |   r
    faddp st2, st0      ; 2pi*r |  h+r  |
    fmulp               ; vysl. |

    leave ; vybavené, výsledek v st0
    ret

; __cdecl float calcVolume(float radius, float height)
calcVolume:
    push ebp
    mov ebp, esp
    
    push dword [ebp+8]  ;  st0  |  st1  |  st2  |
    call calcDiscSurface; pi*r^2|
    add esp, 4
    fld dword [ebp+12]  ;   h   | pi*r^2|
    fmulp               ;pi*hr^2|
    
    leave ; vybavené, výsledek v st0
    ret

_main:
    push ebp
    mov ebp, esp
    ; local vars: circ, baseSurf, cylSurf, vol
    sub esp, 16
    
    %define circ ebp-4
    %define baseSurf ebp-8
    %define cylSurf ebp-12
    %define vol ebp-16
    
    finit

    push dword [inputR]
    call calcCircumference
    add esp, 4
    fstp dword [circ] ; FPU clear

    push dword [inputR]
    call calcDiscSurface
    add esp, 4
    fstp dword [baseSurf] ; FPU clear

    push dword [inputH]
    push dword [inputR]
    call calcCylinderSurface
    add esp, 8
    fstp dword [cylSurf] ; FPU clear
    
    push dword [inputH]
    push dword [inputR]
    call calcVolume
    add esp, 8
    fstp dword [vol] ; FPU clear
    
    mov eax, [circ]
    mov esi, circMsg
    call WriteString
    call WriteFloat
    call WriteNewLine
    
    mov eax, [baseSurf]
    mov esi, baseSurfMsg
    call WriteString
    call WriteFloat
    call WriteNewLine
    
    mov eax, [cylSurf]
    mov esi, cylSurfMsg
    call WriteString
    call WriteFloat
    call WriteNewLine
   
    
    mov eax, [vol]
    mov esi, volMsg
    call WriteString
    call WriteFloat
    call WriteNewLine

    leave
    ret