; Tom Hebel, 2020

            default rel
            global  main
            extern  malloc
            extern  free
            extern  printf
            extern  atoi

            section .data

INT_MAX     equ     0x7fffffff

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
; ------------------------------------------------------------------------------
main:
            push    r12
            push    r13
            push    r14
            push    r15
            sub     rsp, 0x8
            mov     r12, rdi
            mov     r13, rsi
            cmp     r12, 0x3
            jl      main_Leave
            lea     rdi, [(r12 - 0x1) * 0x4]
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
            call    mergesort
            mov     r15, 0x0
main_PrintLoop:
            mov     rdi, outFmt
            mov     esi, dword [r14 + r15*0x4]
            call    printf
            inc     r15
            cmp     r15, r12
            jl      main_PrintLoop
main_Leave:
            mov     rdi, r14
            call    free
            xor     eax, eax
            add     rsp, 0x8
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- void memcpy(void *dest, void *src, int size);
; ------------------------------------------------------------------------------
memcpy:
            dec     rdx
            mov     al, byte [rsi + rdx]
            mov     byte [rdi + rdx], al
            test    rdx, rdx
            jne     memcpy
            ret

; ------------------------------------------------------------------------------
; -- void mergesort(int *arr, int loIdx, int hiIdx);
;
;   Registers:
;
;   r12     int *arr
;   r13     int loIdx
;   r14     int hiIdx
;   r15     int midIdx
; ------------------------------------------------------------------------------
mergesort:
            push    r12
            push    r13
            push    r14
            push    r15
            sub     rsp, 0x8
            mov     r12, rdi
            mov     r13, rsi
            mov     r14, rdx
            cmp     r13, r14
            jge     mergesort_Leave
            mov     rax, r14
            sub     rax, r13
            shr     rax, 0x1
            mov     r15, r13
            add     r15, rax                            ; int midIdx
            mov     rdi, r12
            mov     rsi, r13
            mov     rdx, r15
            call    mergesort
            mov     rdi, r12
            lea     rsi, [r15 + 0x1]
            mov     rdx, r14
            call    mergesort
            mov     rdi, r12
            mov     rsi, r13
            mov     rdx, r15
            mov     rcx, r14
            call    merge
mergesort_Leave:
            add     rsp, 0x8
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- void merge(int *arr, int loIdx, int midIdx, int hiIdx);
;
;   Registers:
;
;   r12     int *arr
;   r13     int loIdx
;   r14     int midIdx
;   r15     int hiIdx
;   rbx     int size
;   [rsp]   int *left
;   [rsp+0x8]   int *right
; ------------------------------------------------------------------------------
merge:
            push    r12
            push    r13
            push    r14
            push    r15
            push    rbx
            sub     rsp, 0x10
            mov     r12, rdi
            mov     r13, rsi
            mov     r14, rdx
            mov     r15, rcx
            lea     rbx, [r14 + 0x1]
            sub     rbx, r13
            lea     rbx, [rbx * 0x4]
            lea     rdi, [rbx + 0x4]
            call    malloc
            mov     qword [rsp], rax
            mov     rdi, qword [rsp]
            lea     rsi, [r12 + r13*0x4]
            mov     rdx, rbx
            call    memcpy
            mov     rax, qword [rsp]
            mov     dword [rax + rbx], INT_MAX
            mov     rbx, r15
            sub     rbx, r14
            lea     rbx, [rbx * 0x4]
            lea     rdi, [rbx + 0x4]
            call    malloc
            mov     qword [rsp + 0x8], rax
            mov     rdi, qword [rsp + 0x8]
            lea     rsi, [r12 + (r14 + 0x1)*0x4]
            mov     rdx, rbx
            call    memcpy
            mov     rax, qword [rsp + 0x8]
            mov     dword [rax + rbx], INT_MAX
            mov     r8, 0x0                             ; i
            mov     r9, 0x0                             ; j
            mov     r10, r13                            ; k
merge_Loop:
            cmp     r10, r15
            jg      merge_LoopBreak
            mov     rax, qword [rsp]
            mov     eax, dword [rax + r8*0x4]
            mov     rcx, qword [rsp + 0x8]
            mov     ecx, dword [rcx + r9*0x4]
            cmp     eax, ecx
            jg      merge_Else
            mov     dword [r12 + r10*0x4], eax
            inc     r8
            jmp     merge_Continue
merge_Else:
            mov     dword [r12 + r10*0x4], ecx
            inc     r9
merge_Continue:
            inc     r10
            jmp     merge_Loop
merge_LoopBreak:
            mov     rdi, qword [rsp]
            call    free
            mov     rdi, qword [rsp + 0x8]
            call    free
            add     rsp, 0x10
            pop     rbx
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret