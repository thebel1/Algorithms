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
;   int main(int argc, char **argv)
;   {
main:
            push    r12
            push    r13
            push    r14
            push    r15
            sub     rsp, 0x8
            mov     r12, rdi

;           ++argv;
            lea     r13, [rsi + 0x8]

;       if (argc < 2) {
;           goto main_Leave;
;       }
            cmp     r12, 0x2
            jl      main_Leave
            
;       int n = argc - 1;
            dec     r12

;       int *arr = malloc(n*sizeof(int));
            lea     rdi, [r12 * 0x4]
            call    malloc
            mov     r14, rax

;       int i = 0;
            mov     r15, 0x0

;       do {
main_SortLoop:

;           arr[i] = atoi(argv[i]);
            mov     rdi, qword [r13 + r15*0x8]
            call    atoi
            mov     dword [r14 + r15*0x4], eax

;           ++i;
            inc     r15

;       } while (i < n);
            cmp     r15, r12
            jl      main_SortLoop

;       isort(arr, i);
            mov     rdi, r14
            mov     rsi, r15
            call    isort

;       i = 0;
            mov     r15, 0x0

;       do {
main_PrintLoop:

;           printf("%d\n", arr[i]);
            mov     rdi, outFmt
            mov     esi, dword [r14 + r15*0x4]
            call    printf

;           ++i;
            inc     r15

;       } while (i < n);
            cmp     r15, r12
            jl      main_PrintLoop

;   main_Leave:
main_Leave:

;       free(arr);
            mov     rdi, r14
            call    free

;       return 0;
;   }
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
;   int atoi(char *str)
;   {
atoi:

;       int i = 0;
            mov     rsi, 0x0

;       int sign = 1;
            mov     rcx, 0x1

;       int sum = 0;
            mov     r8, 0x0

;       char cur = *str;
            movzx   r9, byte [rdi]

;       if (cur == '-') {
            cmp     r9, 0x2d

;           sign = -1;
            mov     r10, -0x1
            cmove   rcx, r10

;           ++i;
            lea     r10, [rsi + 0x1]
            cmove   rsi, r10
;       }

;       cur = str[i];
            movzx   r9, byte [rdi + rsi]

;       do {
atoi_Loop:

;           /* (sum * 10) moves the existing digits one place to the left (in
;            * decimal notation).
;            * (cur - 0x30) converts digits from ASCII to int.
;            */
;           sum = (sum * 10) + (cur - 0x30);
            mov     rax, r8
            mov     r10, 0xa
            mul     r10
            lea     r8, [rax + r9 - 0x30]

;           ++i;
            inc     rsi

;           cur = str[i];
            movzx   r9, byte [rdi + rsi]

;        } while (cur != NULL);
            cmp     r9, 0x0
            jne     atoi_Loop

;       return (sign * sum);
            mov     rax, r8
            mul     ecx
            ret

; ------------------------------------------------------------------------------
; -- void isort(int *arr, int size);
; ------------------------------------------------------------------------------
;   void isort(int *arr, int size)
;   {
isort:

;       int j = 1;
            mov     rdx, 0x1

;       do {
isort_OuterLoop:

;           int key = arr[j];
            mov     r8d, dword [rdi + rdx*0x4]

;           int i = j - 1;
            lea     rcx, [rdx - 0x1]

;           do {
isort_InnerLoop:

;               int cur = arr[i];
            mov     r9d, dword [rdi + rcx*0x4]

;               if (i < 1 && cur <= key) {
            mov     r10, 0x1
            cmp     rcx, 0x0
            mov     rax, 0x0
            cmovl   r10, rax
            cmp     r9d, r8d
            cmovle  r10, rax
            test    r10d, r10d

;                   break;
;               }
            je      isort_InnerBreak

;               arr[i + 1] = arr[i];
            mov     dword [rdi + (rcx + 0x1)*0x4], r9d

;               --i;
            dec     rcx

;           } while (1);
            jmp     isort_InnerLoop

isort_InnerBreak:

;       arr[i + 1] = key;
            mov     dword [rdi + (rcx + 0x1)*0x4], r8d

;       ++j;
            inc     rdx

;       } while (j < size);
            cmp     rdx, rsi
            jl      isort_OuterLoop

;   }
            ret
