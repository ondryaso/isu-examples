%include "rw32-2020.inc"

CEXTERN qsort

section .data
    pArr dd 12,2,0,2,88,45,12,13,15,8,97,13,99,16,17,4 ; 16 elements

section .text
fib:
    push ebp
    mov ebp, esp
    
    push ebx
    
    mov eax, [ebp+8]
    
    cmp eax, 0
    je .end
    cmp eax, 1
    je .end
    
    dec eax
    push eax
    call fib
    add esp, 4
    
    mov ebx, eax

    push dword [ebp+8]
    sub dword [esp], 2
    call fib
    add esp, 4
    
    add ebx, eax
    mov eax, ebx
    
.end:
    pop ebx
    pop ebp
    ret

c_qsort_comp: ; cdecl, int c_qsort_comp(int *p1, int *p2)
    push ebp
    mov ebp, esp
    push ebx
    
    mov eax, [ebp + 8] ; eax = p1
    mov ebx, [ebp + 12] ; ebx = p2
    mov eax, [eax] ; eax = *p1
    mov ebx, [ebx] ; ebx = *p2
    
    sub eax, ebx ; eax = eax - ebx = p1 - p2, which is the return value

    pop ebx
    pop ebp
    ret

c_qsort: ; cdecl, void c_qsort(int *arrayPtr, unsigned int n)
    push ebp
    mov ebp, esp

    ; cal qsort(void *array, size_t n, size_t sizeOfElement, ptr to comp func)
    push c_qsort_comp
    push 4
    push dword [ebp + 12]
    push dword [ebp + 8]
    call qsort
    add esp, 16

    pop ebp
    ret

bubblesort: ; cdecl, void bubble(int *arrayPtr, unsigned int n)
    push ebp
    mov ebp, esp
    push ebx
    push ecx
    push esi
    cmp dword [ebp + 12], 0
    je .end
    
    mov esi, [ebp + 8]
.sort_cycle:
    xor ebx, ebx ; ebx = 0 (sorting occured flag)
    mov ecx, [ebp + 12]
    
.sort_pass:
    dec ecx
    jz .sort_pass_ng

    mov eax, [esi + ecx*4] ; *(pArr + ecx - 1) but ecx is one higher
    cmp [esi + ecx*4 - 4], eax
    jng .sort_pass
    
    xchg [esi + ecx*4 - 4], eax
    mov [esi + ecx*4], eax
    
    mov ebx, 1 ; set sorting occured flag
    jmp .sort_pass
.sort_pass_ng:
    cmp ebx, 1
    je .sort_cycle

.end:
    pop esi
    pop ecx
    pop ebx
    
    pop ebp
    ret

_main:
    push ebp
    mov ebp, esp
    
    push 20
    call fib
    add esp, 4
    call WriteNewLine
    call WriteInt32
    
    pop ebp
    xor eax, eax
    ret