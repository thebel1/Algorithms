#include <stdlib.h>
#include <stdio.h>

void
printArr(int *arr, int size)
{
   int i;

   for (i = 0; i < size; ++i) {
      printf("%d\t", arr[i]);
   }
   printf("\n");
}

int
partition(int *arr, int loIdx, int hiIdx)
{
   int x, i, j, tmp;

   x = arr[hiIdx];
   i = loIdx - 1;

   for (j = loIdx; j < hiIdx; ++j) {
      if (arr[j] <= x) {
         ++i;
         tmp = arr[i];
         arr[i] = arr[j];
         arr[j] = tmp;
      }
   }

   tmp = arr[i + 1];
   arr[i + 1] = arr[hiIdx];
   arr[hiIdx] = tmp;

   return i + 1;
}

void
quickSortImpl(int *arr, int loIdx, int hiIdx)
{
   int part;

   if (loIdx < hiIdx) {
      part = partition(arr, loIdx, hiIdx);
      quickSortImpl(arr, loIdx, part - 1);
      quickSortImpl(arr, part + 1, hiIdx);
   }
}

void
quickSort(int *arr, int size)
{
   quickSortImpl(arr, 0, size - 1);
}

int
main(int argc, char **argv)
{
   int *arr;
   int size, i;

   if (argc < 2) {
      printf("Must supply an array of values\n");
      exit(1);
   }

   size = argc - 1;
   arr = malloc(size * sizeof(*arr));

   for (i = 0; i < size; ++i) {
      arr[i] = atoi(argv[i + 1]);
   }

   printArr(arr, size);
   quickSort(arr, size);
   printArr(arr, size);

   free(arr);

   return 0;
}