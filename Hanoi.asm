.686
.model flat, stdcall

option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
include \masm32\include\msvcrt.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\msvcrt.lib

include \masm32\macros\macros.asm

.data
entrada DWORD ?
discos DWORD ?
armazem DWORD 127 dup(0)

.code

Start:
    xor eax, eax
    mov entrada, input("Quant de discos: ")
    mov ebx, [entrada]
    mov eax, [ebx]
    sub eax, 655408
    
    cmp eax, 6
    jg Encerrar
    
    push 2
    push 3
    push 1
    push eax
    xor ecx, ecx
    
    call Hanoi

    add esp, 16
    
    mov [armazem+ecx], -1


Pusharray: ;LOOP
    cmp ecx, -4
    je Printpilha
    push [armazem+ecx]
    sub ecx, 4
    jmp Pusharray

Printpilha: ;LOOP
    pop eax
    cmp eax, -1
    je Encerrar
    pop ebx
    printf("MOVER DE %d PARA %d\n", eax, ebx)
    jmp Printpilha
    
Encerrar:
    printf("FIM")
    invoke ExitProcess, 0

Hanoi:
    
    push ebp
    mov ebp, esp
    mov eax, [ebp+8]
    cmp eax, 0
    jle Fim

    dec eax
    push [ebp+16]
    push [ebp+20]
    push [ebp+12]
    push eax

    call Hanoi

    add esp, 16
    push [ebp+16]
    push [ebp+12]
    push [ebp+8]
    call Salvaarray

    add esp, 12
    push [ebp+12]
    push [ebp+16]
    push [ebp+20]
    mov eax, [ebp+8]
    dec eax
    push eax
    call Hanoi


Fim:

    mov esp, ebp
    pop ebp
    ret

Salvaarray:
    Push ebp
    mov ebp, esp
    mov eax, [ebp+12]
    mov ebx, [ebp+16]
    mov [armazem+ecx], eax
    add ecx, 4
    mov [armazem+ecx], ebx
    add ecx, 4
    mov esp, ebp
    pop ebp
    ret

end Start