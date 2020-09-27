            default rel
            global  main
            extern  atoi
            extern  malloc
            extern  free
            extern  printf

struc       SubArray
            .loIdx  resd    1
            .hiIdx  resd    1
            .sum    resd    1
endstruc

            section .data

outFmt      db      "%d", 0xa, 0x0

            section .text

; ------------------------------------------------------------------------------
; -- int main(int argc, char **argv);
;
;   Registers:
;
;   r12     int argc
;   r13     char **argv
;   r14     int *arr
;   r15     int i
;   rbx     SubArray *subArr
; ------------------------------------------------------------------------------
main:
            push    r12
            push    r13
            push    r14
            push    r15
            push    rbx
            ;sub     rsp, 0x8
            mov     r12, rdi
            mov     r13, rsi
            cmp     r12, 0x3
            jl      main_Leave
            lea     rdi, [(r12 - 0x1)*0x4]
            call    malloc
            mov     r14, rax
            mov     r15, 0x0
            dec     r12
main_PrepLoop:
            mov     rdi, qword [r13 + (r15 + 0x1)*0x8]
            call    atoi
            mov     dword [r14 + r15*0x4], eax
            inc     r15
            cmp     r15, r12
            jl      main_PrepLoop
            mov     rdi, r14
            mov     rsi, 0x0
            lea     rdx, [r12 - 0x1]
            call    maxSubArray
            mov     rbx, rax
            mov     r15, 0x0
            ud2
main_PrintLoop:
            ud2
            inc     r15
            cmp     r15, r12
            jl      main_PrintLoop
main_Leave:
            ud2
            mov     rdi, rbx
            call    free
            mov     rdi, r14
            call    free
            ;add     rsp, 0x8
            pop     rbx
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- SubArray *maxSubArray(int *arr, int loIdx, int hiIdx);
; ------------------------------------------------------------------------------
maxSubArray:
            push    r12
            push    r13
            push    r14
            push    r15
            sub     rsp, 0x18
            ud2
            add     rsp, 0x18
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret