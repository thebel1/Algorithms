            default rel
            global  main
            extern  atoi
            extern  malloc
            extern  free
            extern  printf

%macro      LEFT    1
            shl %1, 0x1
%endmacro

%macro      RIGHT   1
            shl %1, 0x1
            inc %1
%endmacro

%macro      PARENT  1
            shr %1, 0x1
%endmacro

            section .data

outFmt      db  "%d ", 0x0
newline     db  0xa, 0x0

            section .text

; ------------------------------------------------------------------------------
; -- int main(int argc, char **argv);
; ------------------------------------------------------------------------------
main:
            push    r12
            push    r13
            push    r14
            push    r15
            sub     rsp, 0x8
            mov     r12d, edi
            mov     r13, rsi
            cmp     r12d, 0x3
            jl      main_leave
            dec     r12d
            lea     rdi, [r12 * 0x4]
            call    malloc
            mov     r14, rax
            mov     r15d, 0x0
main_prepLoop:
            mov     rdi, qword [r13 + r15*0x8 + 0x8]
            call    atoi
            mov     dword [r14 + r15*0x4], eax
            inc     r15d
            cmp     r15d, r12d
            jl      main_prepLoop
            mov     rdi, r14
            mov     esi, r12d
            call    heapSort
            xor     r15d, r15d
main_printLoop:
            mov     rdi, outFmt
            mov     esi, dword [r14 + r15*0x4]
            call    printf
            inc     r15d
            cmp     r15d, r12d
            jl      main_printLoop
            mov     rdi, newline
            call printf
            mov     rdi, r14
            call    free
main_leave:
            add     rsp, 0x8
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- void buildMaxHeap(int *A, int heapSize);
; ------------------------------------------------------------------------------
buildMaxHeap:
            push    r12
            push    r13
            push    r14
            mov     r12, rdi
            mov     r13d, esi
            mov     r14d, esi
            shr     r14d, 0x1
buildMaxHeap_loop:
            mov     rdi, r12
            mov     esi, r13d
            mov     edx, r14d
            call    maxHeapify
            dec     r14d
            cmp     r14d, 0x0
            jge     buildMaxHeap_loop
            pop     r14
            pop     r13
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- void maxHeapify(int *A, int heapSize, int i);
; ------------------------------------------------------------------------------
maxHeapify:            
            mov     r8d, edx
            LEFT(r8d)
            mov     r9d, edx
            RIGHT(r9d)
            cmp     r8d, esi
            jge     maxHeapify_else1
            mov     eax, dword [rdi + r8*0x4]
            cmp     eax, dword [rdi + rdx*0x4]
            cmovg   rcx, r8
            jg      maxHeapify_if2
maxHeapify_else1:
            mov     ecx, edx
maxHeapify_if2:
            cmp     r9d, esi
            jge     maxHeapify_if3
            mov     eax, dword [rdi + r9*0x4]
            cmp     eax, dword [rdi + rcx*0x4]
            cmovg   rcx, r9
maxHeapify_if3:
            cmp     ecx, edx
            je      maxHeapify_leave
            mov     r10d, dword [rdi + rdx*0x4]   
            mov     r11d, dword [rdi + rcx*0x4]
            mov     dword [rdi + rdx*0x4], r11d
            mov     dword [rdi + rcx*0x4], r10d
            mov     edx, ecx
            jmp     maxHeapify
maxHeapify_leave:
            ret

; ------------------------------------------------------------------------------
; -- void heapSort(int *A, int heapSize);
; ------------------------------------------------------------------------------
heapSort:
            push    r12
            push    r13
            push    r14
            mov     r12, rdi
            mov     r13d, esi
            lea     r14, [r13d - 0x1]
            call    buildMaxHeap
heapSort_loop:
            mov     edx, dword [r12 + r14*0x4]
            mov     ecx, dword [r12]
            mov     dword [r12 + r14*0x4], ecx
            mov     dword [r12], edx
            dec     r13
            mov     rdi, r12
            mov     esi, r13d
            mov     edx, 0x0
            call    maxHeapify
            dec     r14d
            test    r14b, r14b
            jne     heapSort_loop
            pop     r14
            pop     r13
            pop     r12
            ret