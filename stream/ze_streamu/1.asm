%include "rw32-2020.inc"

section .data
    circMsg db "Circumference: ",0
    baseSurfMsg db "Base Surface: ",0
    cylSurfMsg db "Cylinder Surface: ",0
    volMsg db "Cylinder Volume: ",0

section .text

; __cdecl float calcCircumference(float radius)
calcCircumference:
    push ebp
    mov ebp, esp
    
    ; 2*pi*r
    finit               ;  st0  |  st1  |
    fld dword [ebp+8]   ;   r   |

    fadd st0, st0       ;  2r
    fldpi               ;  pi   |  2r   |
    fmulp               ;  2pi*r|

    leave ; vybavené, výsledek mám v st0
    ret

; __cdecl float calcDiscSurface(float radius)
calcDiscSurface:
    push ebp
    mov ebp, esp
    
    ; pi*r*r
    finit               ;  st0  |  st1  |
    fld dword [ebp+8]   ;   r   |
    fmul st0, st0       ;  r*r  |
    fldpi               ;  pi   |  r*r  |
    fmulp               ;pi*r*r |
    
    leave ; vybavené, výsledek mám v st0
    ret
    
; __cdecl float calcCylinderSurface(float radius, float height)
calcCylinderSurface:
    push ebp
    mov ebp, esp
    
    ; 2*pi*r*(h+r)
    finit               ;  st0  |  st1  |  st2  |
    
    fld dword [ebp+8]   ;   r   |
    fld st0             ;   r   |   r   |
    fadd st0, st0       ;   2r  |   r   |
    fldpi               ;   pi  |  2r   |   r
    fmulp               ; 2pi*r |   r   |
    fld dword [ebp+12]  ;   h   | 2pi*r |   r   |
    faddp st2, st0      ; 2pi*r |  r+h  |
    fmulp               ; výsl. |
    
    leave ; vybavené
    ret

; __cdecl float calcVolume(float radius, float height)
calcVolume:
    push ebp
    mov ebp, esp
    
    ; pi*r^2
    push dword [ebp+8]  ;  st0  |  st1  |  st2  |
    call calcDiscSurface; pi*r^2|  
    add esp, 4
    
    fld dword [ebp+12]  ;   h   | pirr  |
    fmulp               ; pirrh |
    
    leave ; vybavené
    ret

_main:
    push ebp
    mov ebp, esp
    ; local vars: circ, baseSurf, cylSurf, vol, r, h
    sub esp, 24

    %define circ ebp-4
    %define baseSurf ebp-8
    %define cylSurf ebp-12
    %define vol ebp-16
    %define h ebp-20
    %define r ebp-24

    mov al, 10 ; r
    mov ah, 2  ; h
    
    movsx ebx, al 
    mov [r], ebx
    movsx ebx, ah 
    mov [h], ebx

    finit           ;  st0  |  st1  |
    fild dword [h]  ;   h   |
    fild dword [r]  ;   r   |   h
    fstp dword [r]  ;   h   |
    fstp dword [h]  ; ----- |

    push dword [r]
    call calcCircumference ; výsledek v st0
    add esp, 4
    fstp dword [circ] ; circ = výsledek, FPU clear
    
    push dword [r]
    call calcDiscSurface
    add esp, 4
    fstp dword [baseSurf] ; FPU clear

    push dword [h]
    push dword [r]
    call calcCylinderSurface
    add esp, 8
    fstp dword [cylSurf] ; FPU clear
    
    push dword [h]
    push dword [r]
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

    pop ebp
    ret