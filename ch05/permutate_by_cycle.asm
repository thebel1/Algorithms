            default rel
            global  main
            extern  atoi
            extern  malloc
            extern  free
            extern  printf

            section .data

; ...

            section .text

; ------------------------------------------------------------------------------
; -- int main(int argc, char **argv);
; ------------------------------------------------------------------------------
main:
            ud2
            ret

; ------------------------------------------------------------------------------
; -- int *permutateByCyclic(int *A, int size);
; ------------------------------------------------------------------------------
permutateByCyclic:
            push    r12
            push    r13
            push    r14
            mov     r12, rdi
            mov     r13, rsi
            lea     rdi, [r13*0x4]
            call    malloc
            mov     r14, rax
            call    rand
            lea     r10, [r13 - 0x1]
            xor     edx, edx
            div     r10d
            mov     r8, 0x0
permutateByCyclic_Loop:
            mov     ecx, r8d
            add     ecx, eax
            cmp     ecx, r13d
            mov     r10d, ecx
            sub     r10d, r13d
            add     r10d, 0x1
            cmovge  ecx, r10d
            mov     r10d, dword [r12 + r8*0x4]
            mov     dword [r14 + rcx*0x4], r10d
            inc     r8
            cmp     r8, r13
            jl      permutateByCyclic_Loop
            mov     rax, rbx
            pop     r14
            pop     r13
            pop     r12
            ret