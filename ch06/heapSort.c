#include <stdlib.h>
#include <stdio.h>

#define CRASH { asm("ud2"); }

#define PARENT(i) (i >> 1)
#define LEFT(i) (i << 1)
#define RIGHT(i) ((i << 1) + 1)

void maxHeapify(int *A, int heapSize, int i)
{
    int left, right, largest, tmp;

    left = LEFT(i);
    right = RIGHT(i);

    if (left < heapSize && A[left] > A[i]) {
        largest = left;
    }
    else {
        largest = i;
    }

    if (right < heapSize && A[right] > A[largest]) {
        largest = right;
    }

    if (largest != i) {
        tmp = A[i];
        A[i] = A[largest];
        A[largest] = tmp;
        maxHeapify(A, heapSize, largest);
    }
}

void buildMaxHeap(int *A, int heapSize)
{
    int i;

    i = (heapSize >> 1);
    for (; i >= 0; --i) {
        maxHeapify(A, heapSize, i);
    }
}

void heapSort(int *A, int heapSize)
{
    buildMaxHeap(A, heapSize);

    for (int i = heapSize - 1; i >= 1; --i) {
        int tmp = A[0];
        A[0] = A[i];
        A[i] = tmp;
        --heapSize;
        maxHeapify(A, heapSize, 0);
    }
}

int main(int argc, char **argv)
{
    int *arr, arrSz;

    if (argc < 3) {
        printf("Must supply array to use as heap.\n");
        exit(1);
    }

    arrSz = argc - 1;
    arr = malloc(arrSz * sizeof(*arr));
    for (int i = 0; i < arrSz; ++i) {
        arr[i] = atoi(argv[i + 1]);
    }

    heapSort(arr, arrSz);

    for (int i = 0; i < arrSz; ++i) {
        printf("%d ", arr[i]);
    }
    printf("\n");

    free(arr);

    return 0;
}