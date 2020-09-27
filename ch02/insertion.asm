            default rel
            global  main
            extern  malloc
            extern  free
            extern  printf

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
; ------------------------------------------------------------------------------
main:
            push    r12
            push    r13
            push    r14
            push    r15
            sub     rsp, 0x8
            mov     r12, rdi
            lea     r13, [rsi + 0x8]
            cmp     r12, 0x2
            jl      main_Leave
            dec     r12
            lea     rdi, [r12 * 0x4]
            call    malloc
            mov     r14, rax
            mov     r15, 0x0
main_SortLoop:
            mov     rdi, qword [r13 + r15*0x8]
            call    atoi
            mov     dword [r14 + r15*0x4], eax
            inc     r15
            cmp     r15, r12
            jl      main_SortLoop
            mov     rdi, r14
            mov     rsi, r15
            call    isort
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
; -- int atoi(char *str);
;
;   Registers:
;
;   rsi     int i
;   ecx     int sign
;   r8      int sum
;   r9      int currChar
;   rax     tmp
;   r10     tmp
; ------------------------------------------------------------------------------
atoi:
            mov     rsi, 0x0
            mov     rcx, 0x1
            mov     r8, 0x0                             ; Sum
            movzx   r9, byte [rdi]
            cmp     r9, 0x2d                            ; ASCII '-'
            mov     r10, -0x1
            cmove   rcx, r10
            lea     r10, [rsi + 0x1]
            cmove   rsi, r10
            movzx   r9, byte [rdi + rsi]
atoi_Loop:
            mov     rax, r8
            mov     r10, 0xa
            mul     r10
            lea     r8, [rax + r9 - 0x30]               ; prev + curr
            inc     rsi
            movzx   r9, byte [rdi + rsi]
            cmp     r9, 0x0
            jne     atoi_Loop
            mov     rax, r8
            mul     ecx
            ret

; ------------------------------------------------------------------------------
; -- void isort(int *arr, int size);
; ------------------------------------------------------------------------------
isort:
            mov     rdx, 0x1                            ; j
isort_OuterLoop:
            mov     r8d, dword [rdi + rdx*0x4]          ; int key = arr[j]
            lea     rcx, [rdx - 0x1]                    ; i
isort_InnerLoop:
            mov     r9d, dword [rdi + rcx*0x4]          ; arr[i]
            mov     r10, 0x1
            cmp     rcx, 0x0
            mov     rax, 0x0
            cmovl   r10, rax                            ; i >= 0
            cmp     r9d, r8d
            cmovle  r10, rax                            ; a[i] > key
            test    r10d, r10d
            je      isort_InnerBreak
            mov     dword [rdi + (rcx + 0x1)*0x4], r9d  ; arr[i + 1] = arr[i]
            dec     rcx                                 ; --i
            jmp     isort_InnerLoop
isort_InnerBreak:
            mov     dword [rdi + (rcx + 0x1)*0x4], r8d  ; arr[i + 1] = key
            inc     rdx
            cmp     rdx, rsi
            jl      isort_OuterLoop
            ret