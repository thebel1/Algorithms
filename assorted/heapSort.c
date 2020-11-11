#include <stdlib.h>
#include <stdio.h>

#define PARENT(_idx) ((int)_idx / 2)
#define LEFT(_idx) (2 * _idx)
#define RIGHT(_idx) (2*_idx + 1)

struct Heap {
   int *arr;
   int arrSize;
   int heapSize;
};

void
printArr(int *arr, int size)
{
   int i;

   for (i = 0; i < size; ++i) {
      printf("%d\t", arr[i]);
   }
   printf("\n");
}

void
maxHeapify(struct Heap *heap, int idx)
{
   int left, right;
   int largest;
   int tmp;

   left = LEFT(idx);
   right = RIGHT(idx);

   if (left < heap->heapSize
       && heap->arr[left] > heap->arr[idx]) {
      largest = left;
   }
   else {
      largest = idx;
   }

   if (right < heap->heapSize
       && heap->arr[right] > heap->arr[largest]) {
      largest = right;
   }

   if (largest != idx) {
      tmp = heap->arr[idx];
      heap->arr[idx] = heap->arr[largest];
      heap->arr[largest] = tmp;
      maxHeapify(heap, largest);
   }
}

void
buildMaxHeap(int *arr,
             int arrSize,
             struct Heap *heap)
{
   int i;
   
   heap->arr = arr;
   heap->arrSize = arrSize;
   heap->heapSize = arrSize;

   for (i = (arrSize - 1) / 2; i >= 0; --i) {
      maxHeapify(heap, i);
   }
}

void
heapSort(int *arr, int size)
{
   struct Heap heap;
   int i;
   int tmp;

   buildMaxHeap(arr, size, &heap);

   for (i = size - 1; i >= 0; --i) {
      tmp = arr[0];
      arr[0] = arr[i];
      arr[i] = tmp;
      --heap.heapSize;
      maxHeapify(&heap, 0);
   }
}

int
main(int argc, char **argv)
{
   int *arr;
   int size, i;

   if (argc < 2) {
      printf("Must supply array of values\n");
      exit(1);
   }

   size = argc - 1;
   arr = malloc(size * sizeof(*arr));

   for (i = 0; i < size; ++i) {
      arr[i] = atoi(argv[i + 1]);
   }

   printArr(arr, size);
   heapSort(arr, size);
   printArr(arr, size);

   free(arr);

   return 0;
}