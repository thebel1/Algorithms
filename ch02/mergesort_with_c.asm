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
;   int main(int argc, char **argv)
;   {
main:
            push    r12
            push    r13
            push    r14
            push    r15
            sub     rsp, 0x8
            mov     r12, rdi
            mov     r13, rsi

;       if (argc < 3) {
;           goto main_Leave;
;       }
            cmp     r12, 0x3
            jl      main_Leave

;       /* (argc - 1) => the first argument is not counted because it's the name
;        * of the program.
;        */
;       int *arr = malloc((argc - 1) * sizeof(int));
            lea     rdi, [(r12 - 0x1) * 0x4]
            call    malloc
            mov     r14, rax

;       int i = 0;
;       int arrSz = argc - 1;
            mov     r15, 0x0
            dec     r12

;       do {
main_PrepLoop:

;           arr[i] = atoi(argv[i + 1]); // Convert char* to int.
            mov     rdi, qword [r13 + (r15 + 0x1)*0x8]
            call    atoi
            mov     dword [r14 + r15*0x4], eax

;       } while (++i < arrSz);
            inc     r15
            cmp     r15, r12
            jl      main_PrepLoop

;       mergesort(arr, 0, arrSz - 1);
            mov     rdi, r14
            mov     rsi, 0x0
            lea     rdx, [r12 - 0x1]
            call    mergesort

;       i = 0;
            mov     r15, 0x0

;       do {
main_PrintLoop:

;           printf("%d\n", arr[i]);
            mov     rdi, outFmt
            mov     esi, dword [r14 + r15*0x4]
            call    printf

;       } while(++i < arrSz);
            inc     r15
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
; -- void memcpy(void *dest, void *src, int size);
; ------------------------------------------------------------------------------
;   void memcpy(void *dest, void *src, int size)
;   {
;       do {
memcpy:

;           --size;
            dec     rdx

;           char tmp = src[size];
            mov     al, byte [rsi + rdx]

;           dest[size] = tmp;
            mov     byte [rdi + rdx], al

;       } while(size != 0);
            test    rdx, rdx
            jne     memcpy

;   }
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
;   void mergesort(int *arr, int loIdx, int hiIdx)
;   {
mergesort:
            push    r12
            push    r13
            push    r14
            push    r15
            sub     rsp, 0x8
            mov     r12, rdi
            mov     r13, rsi
            mov     r14, rdx

;       if (loIdx >= hiIdx) {
;           goto mergesort_Leave;
;       }
            cmp     r13, r14
            jge     mergesort_Leave

;       int midIdx = loIdx + ((hiIdx - loIdx) >> 1);
            mov     rax, r14
            sub     rax, r13
            shr     rax, 0x1
            mov     r15, r13
            add     r15, rax

;       mergesort(arr, loIdx, midIdx);
            mov     rdi, r12
            mov     rsi, r13
            mov     rdx, r15
            call    mergesort

;       mergesort(arr, midIdx + 1, hiIdx);
            mov     rdi, r12
            lea     rsi, [r15 + 0x1]
            mov     rdx, r14
            call    mergesort

;       merge(arr, loIdx, midIdx, hiIdx);
            mov     rdi, r12
            mov     rsi, r13
            mov     rdx, r15
            mov     rcx, r14
            call    merge

;   }
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
;   void merge(int *arr, int loIdx, int midIdx, int hiIdx)
;   {
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

;       int leftSz = ((midIdx + 1) - loIdx);
            lea     rbx, [r14 + 0x1]
            sub     rbx, r13

;       int *left = malloc(leftMaxIdx*sizeof(int) + sizeof(int));
            lea     rbx, [rbx * 0x4]
            lea     rdi, [rbx + 0x4]
            call    malloc
            mov     qword [rsp], rax

;       memcpy(left, arr[loIdx], leftSz);
            mov     rdi, qword [rsp]
            lea     rsi, [r12 + r13*0x4]
            mov     rdx, rbx
            call    memcpy

;       left[leftSz] = INT_MAX;
            mov     rax, qword [rsp]
            mov     dword [rax + rbx], INT_MAX

;       int rightSz = hiIdx - midIdx;
            mov     rbx, r15
            sub     rbx, r14

;       int *right = malloc(leftSz*sizeof(int) + sizeof(int));
            lea     rbx, [rbx * 0x4]
            lea     rdi, [rbx + 0x4]
            call    malloc
            mov     qword [rsp + 0x8], rax

;       memcpy(right, arr[midIdx + 1], rightSz);
            mov     rdi, qword [rsp + 0x8]
            lea     rsi, [r12 + (r14 + 0x1)*0x4]
            mov     rdx, rbx
            call    memcpy

;       right[rightSz] = INT_MAX;
            mov     rax, qword [rsp + 0x8]
            mov     dword [rax + rbx], INT_MAX

;       int i = 0;
            mov     r8, 0x0

;       int j = 0;
            mov     r9, 0x0

;       int k = loIdx;
            mov     r10, r13

;       while (k <= hiIdx) {
merge_Loop:
            cmp     r10, r15
            jg      merge_LoopBreak

;           if (left[i] <= right[j]) {
            mov     rax, qword [rsp]
            mov     eax, dword [rax + r8*0x4]
            mov     rcx, qword [rsp + 0x8]
            mov     ecx, dword [rcx + r9*0x4]
            cmp     eax, ecx
            jg      merge_Else

;               arr[k] = left[i];
            mov     dword [r12 + r10*0x4], eax

;               ++i;
            inc     r8

;           } else {
            jmp     merge_Continue
merge_Else:

;               arr[k] = right[j];
            mov     dword [r12 + r10*0x4], ecx

;               ++j;
            inc     r9

;           }
;           ++k;
;       }
merge_Continue:
            inc     r10
            jmp     merge_Loop
merge_LoopBreak:

;        free(left);   
            mov     rdi, qword [rsp]
            call    free

;       free(right);
            mov     rdi, qword [rsp + 0x8]
            call    free

;   }
            add     rsp, 0x10
            pop     rbx
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret
