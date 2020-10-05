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
; -- int *squareMatrixMul(int *A, int *B, int size);
; ------------------------------------------------------------------------------
squareMatrixMul:
            push    r12
            push    r13
            push    r14
            push    rbx
            sub     rsp, 0x8
            mov     r12, rdi
            mov     r13, rsi
            mov     r14, rdx
            mov     eax, 0x4
            mul     r14d
            mul     r14d
            mov     edi, eax
            call    malloc
            mov     rbx, rax
            mov     r8, 0x0
squareMatrixMul_iLoop:
            mov     r9, 0x0
squareMatrixMul_jLoop:
            mov     r10, 0x0
            mov     rax, r8
            mul     r9
            mov     rcx, 0x0
squareMatrixMul_kLoop:
            mov     eax, r8d
            mul     r14d
            add     eax, r10d
            mov     r11d, dword [r12 + rax*0x4]
            mov     eax, r10d
            mul     r14d
            add     eax, r9d
            mov     eax, dword [r13 + rax*0x4]
            mov     r11d
            add     ecx, eax
            inc     r10
            cmp     r10d, r14d
            jl      squareMatrixMul_kLoop
            inc     r9
            cmp     r9d, r14d
            inc     r8
            cmp     r8d, r14d
            jl      squareMatrixMul_iLoop
            mov     rax, rbx
            add     rsp, 0x8
            pop     rbx
            pop     r14
            pop     r13
            pop     r12
            ret