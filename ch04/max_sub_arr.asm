            default rel
            global  main
            extern  atoi
            extern  malloc
            extern  free
            extern  printf

INT_MIN     equ     0x80000000

struc       SubArray
            .loIdx  resd    1
            .hiIdx  resd    1
            .sum    resd    1
endstruc

            section .data

subArrFmt   db      "[%d, %d, %d]", 0xa, 0x0
numFmt      db      "%d", 0xa, 0x0

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
            mov     rdi, subArrFmt
            mov     esi, dword [rbx + SubArray.loIdx]
            mov     edx, dword [rbx + SubArray.hiIdx]
            mov     ecx, dword [rbx + SubArray.sum]
            call    printf
            mov     r15d, dword [rbx + SubArray.loIdx]
            mov     r12d, dword [rbx + SubArray.hiIdx]
main_PrintLoop:
            mov     rdi, numFmt
            mov     esi, dword [r14 + r15*0x4]
            call    printf
            inc     r15
            cmp     r15, r12
            jle     main_PrintLoop
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
            mov     r12, rdi
            mov     r13, rsi
            mov     r14, rdx
            cmp     rsi, rdx
            je      maxSubArray_singleReturn
            mov     r15, r13
            add     r15, r14
            shr     r15, 0x1
            mov     rdi, r12
            mov     rsi, r13
            mov     rdx, r15
            call    maxSubArray
            mov     qword [rsp + 0x10], rax
            mov     rdi, r12
            lea     rsi, [r15 + 0x1]
            mov     rdx, r14
            call    maxSubArray
            mov     qword [rsp + 0x8], rax
            mov     rdi, r12
            mov     rsi, r13
            mov     rdx, r15
            mov     rcx, r14
            call    maxCrossingSubArray
            mov     qword [rsp], rax
            mov     rax, qword [rsp + 0x10]
            mov     eax, dword [rax + SubArray.sum]
            mov     rcx, qword [rsp + 0x8]
            mov     ecx, dword [rcx + SubArray.sum]
            mov     rdx, qword [rsp]
            mov     edx, dword [rdx + SubArray.sum]
            mov     r10, 0x1
            mov     r11, 0x0
            cmp     eax, ecx
            cmovl   r10, r11
            cmp     eax, edx
            cmovl   r10, r11
            test    r10, r10
            cmovne  rax, qword [rsp + 0x10]
            jne     maxSubArray_Leave
            mov     r10, 0x1
            cmp     ecx, eax
            cmovl   r10, r11
            cmp     ecx, edx
            cmovl   r10, r11
            test    r10, r10
            cmovne  rax, qword [rsp + 0x8]
            jne     maxSubArray_Leave
            mov     rax, qword [rsp]
maxSubArray_Leave:
            add     rsp, 0x18
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret
maxSubArray_singleReturn:
            mov     rdi, SubArray_size
            call    malloc
            mov     ecx, dword [r12 + r13*0x4]
            mov     dword [rax + SubArray.loIdx], r13d
            mov     dword [rax + SubArray.hiIdx], r14d
            mov     dword [rax + SubArray.sum], ecx
            add     rsp, 0x18
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- SubArray *maxCrossingSubArray(int *arr, int loIdx, int midIdx, int hiIdx);
; ------------------------------------------------------------------------------
maxCrossingSubArray:
            push    r12
            push    r13
            push    r14
            mov     eax, INT_MIN
            movsxd  r8, eax
            movsxd  r9, eax
            mov     r10, 0x0
            mov     r11, rdx
maxCrossingSubArray_leftLoop:
            add     r10d, dword [rdi + r11*0x4]
            cmp     r10d, r8d
            cmovg   r8, r10
            cmovg   r12, r11
            dec     r11
            cmp     r11, rsi
            jge     maxCrossingSubArray_leftLoop
            mov     r10, 0x0
            lea     r11, [rdx + 0x1]
maxCrossingSubArray_rightLoop:
            add     r10d, dword [rdi + r11*0x4]
            cmp     r10d, r9d
            cmovg   r9, r10
            cmovg   r13, r11
            inc     r11
            cmp     r11, rcx
            jle     maxCrossingSubArray_rightLoop
            lea     r14, [r8 + r9]
            mov     rdi, SubArray_size
            call    malloc
            mov     dword [rax + SubArray.loIdx], r12d
            mov     dword [rax + SubArray.hiIdx], r13d
            mov     dword [rax + SubArray.sum], r14d
            pop     r14
            pop     r12
            pop     r13
            ret