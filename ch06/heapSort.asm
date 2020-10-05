            default rel
            global  main
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
            ud2
            ret

; ------------------------------------------------------------------------------
; -- void buildMaxHeap(int *A, int heapSize);
; ------------------------------------------------------------------------------
buildMaxHeap:
            ud2
            ret

; ------------------------------------------------------------------------------
; -- void maxHeapify(int *A, int heapSize, int i);
; ------------------------------------------------------------------------------
maxHeapify:
            xor     ecx, ecx
            mov     r8, rdx
            LEFT(r8d)
            mov     r9, rdx
            RIGHT(r9d)
            mov     r10d, 0x1
            xor     r11d, r11d
            cmp     r8d, esi
            cmovge  r10, r11
            mov     eax, dword [rdi + r8*0x4]
            cmp     eax, dword [rdi + rdx*0x4]
            cmovle  r10, r11
            test    r10b, r10b
            cmovne  rcx, r8
            mov     r10d, 0x1
            cmp     r9d, esi
            cmovge  r10, r11
            mov     eax, dword [rdi + r9*0x4]     
            cmp     eax, dword [rdi + rcx*0x4]
            cmovle  r10, r11
            test    r10b, r10b
            cmovne  ecx, r9
            cmp     ecx, edx
            jne     maxHeapify_leave
            mov     r10d, dword [rdi + rdx*0x4]
            mov     r11d, dword [rdi + rcx*0x4]
            mov     dword [rdi + rdx*0x4], r11d
            mov     dword [rdi + rcx*0x4], r10d
            mov     esi, ecx
            jmp     maxHeapify
maxHeapify_leave:
            ud2
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
            mov     esi, 0x0
            call    maxHeapify
            dec     r14d
            test    r14b, r14b
            jne     heapSort_loop
            pop     r14
            pop     r13
            pop     r12
            ret