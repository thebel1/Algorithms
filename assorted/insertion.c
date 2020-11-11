#include <stdlib.h>
#include <stdio.h>

void
insertion(int *arr, int size)
{
   int i, j, key;

   for (j = 1; j < size; ++j) {
      key = arr[j];
      i = j - 1;
      while (i >= 0 && arr[i] > key) {
         arr[i + 1] = arr[i];
         i = i - 1;
      }
      arr[i + 1] = key;
   }
}

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
main(int argc, char **argv)
{
   int *arr;
   int size, i;

   if (argc < 3) {
      printf("Must supply array of numbers\n");
      exit(1);
   }

   size = argc - 1;
   arr = malloc(size * sizeof(*arr));

   for (i = 0; i < size; ++i) {
      arr[i] = atoi(argv[i + 1]);
   }

   printArr(arr, size);
   insertion(arr, size);
   printArr(arr, size);

   free(arr);

   return 0;
}