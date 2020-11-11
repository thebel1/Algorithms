#include <stdlib.h>
#include <stdio.h>
#include <limits.h>

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
merge(int *arr, int loIdx, int midIdx, int hiIdx)
{
   int *leftArr, *rightArr;
   int leftLen, rightLen;
   int i, j, k;

   leftLen = midIdx - loIdx + 1;
   rightLen = hiIdx - midIdx;

   leftArr = malloc((leftLen  + 1) * sizeof(*leftArr));
   rightArr = malloc((rightLen + 1) * sizeof(*rightArr));

   for (i = 0; i < leftLen; ++i) {
      leftArr[i] = arr[loIdx + i];
   }

   for (j = 0; j < rightLen; ++j) {
      rightArr[j] = arr[midIdx + j + 1];
   }

   leftArr[leftLen] = INT_MAX;
   rightArr[rightLen] = INT_MAX;

   for (i = 0, j = 0, k = loIdx; k <= hiIdx; ++k) {
      if (leftArr[i] <= rightArr[j]) {
         arr[k] = leftArr[i];
         ++i;
      }
      else {
         arr[k] = rightArr[j];
         ++j;
      }
   }

   free(leftArr);
   free(rightArr);
}

void
msort(int *arr, int loIdx, int hiIdx)
{
   int midIdx;

   if (loIdx < hiIdx) {
      midIdx = (loIdx + hiIdx) / 2;
      msort(arr, loIdx, midIdx);
      msort(arr, midIdx + 1, hiIdx);
      merge(arr, loIdx, midIdx, hiIdx);
   }
}

int
main(int argc, char **argv)
{
   int *arr;
   int size, i;

   if (argc < 2) {
      printf("Must supply an array of numbers\n");
      exit(1);
   }

   size = argc - 1;
   arr = malloc(size * sizeof(*arr));

   for (i = 0; i < size; ++i) {
      arr[i] = atoi(argv[i + 1]);
   }

   printArr(arr, size);
   msort(arr, 0, size - 1);
   printArr(arr, size);

   free(arr);

   return 0;
}