            default rel
            global  main
            extern  malloc
            extern  realloc
            extern  free
            extern  printf

struc       Sample
            .arr        resq 1
            .size       resd 1
            .allocSz    resd 1
endstruc
SAMPLE_INIT_SZ      equ 0x20
INT_MIN     equ     0x80000000

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
; -- Sample *initSample();
; ------------------------------------------------------------------------------
initSample:
            push    r12
            mov     edi, Sample_size
            call    malloc
            mov     r12, rax
            mov     rax, SAMPLE_INIT_SZ
            xor     edx, edx
            mov     r10d, 0x4
            mul     r10d
            mov     edi, eax
            call    malloc
            mov     qword [r12 + Sample.arr], rax
            mov     dword [r12 + Sample.size], 0x0
            mov     dword [r12 + Sample.allocSz], SAMPLE_INIT_SZ
            mov     rax, r12
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- void pushSample(Sample *sample, int elem);
; ------------------------------------------------------------------------------
pushSample:
            push    r12
            push    r13
            sub     rsp, 0x8
            mov     r12, rdi
            mov     r13d, esi
            mov     eax, dword [r12 + Sample.size]
            mov     ecx, dword [r12 + Sample.allocSz]
            cmp     eax, ecx
            jl      pushSample_skip
            mov     rdi, r12
            lea     rsi, [rcx * 0x2]
            call    realloc
            mov     qword [r12 + Sample.arr], rax
            lea     rax, [r13 * 0x2]
            mov     dword [r12 + Sample.allocSz], eax
pushSample_skip:
            mov     eax, dword [r12 + Sample.size]
            mov     dword [r12 + Sample.arr + rax*0x4], r13d
            inc     dword [r12 + Sample.size]
            add     rsp, 0x8
            pop     r13
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- int popSample(Sample *sample);
; ------------------------------------------------------------------------------
popSample:
            mov     eax, INT_MIN
            cmp     dword [rdi + Sample.size], 0x0
            je      popSample_emptyRet
            dec     dword [rdi + Sample.size]
            mov     ecx, dword [rdi + Sample.size]
            mov     eax, dword [rdi + Sample.arr + rcx*0x4]
popSample_emptyRet:
            ret

; ------------------------------------------------------------------------------
; -- void freeSample(Sample *sample);
; ------------------------------------------------------------------------------
freeSample:
            push    r12
            mov     r12, rdi
            mov     rdi, qword [r12 + Sample.arr]
            call    free
            mov     rdi, r12
            call    free
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- Sample *randomSample(int m, int n);
; ------------------------------------------------------------------------------
randomSample:
            push    r12
            push    r13
            push    r14
            mov     r12d, edi
            mov     r13d, esi
            test    r12d, r12d
            jne     randomSample_skip
            call    initSample
            ret
randomSample_skip:
            dec     edi
            dec     esi
            call    randomSample
            mov     r14, rax
            call    rand
            xor     edx, edx
            lea     rcx, [r13 - 0x1]
            div     ecx
            mov     r8d, dword [r14 + Sample.size]
            mov     ecx, 0x0
randomSample_loop:
            mov     r9d, 0x0
            mov     eax, dword [r14 + Sample.arr + ecx*0x4]
            cmp     eax, edx
            cmove   r9d, 0x1
            je      randomSample_skip2
            inc     ecx
            cmp     ecx, r8d
            jl      randomSample_loop
            mov     rdi, r14
            mov     esi, edx
            call    pushSample
            mov     rax, r14
            pop     r14
            pop     r13
            pop     r12
            ret
randomSample_skip2:
            mov     rdi, r14
            mov     esi, r13d
            call    pushSample
            mov     rax, r14
            pop     r14
            pop     r13
            pop     r12
            ret
