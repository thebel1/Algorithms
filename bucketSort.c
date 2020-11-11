#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

void
printArr(float *arr, int size)
{
   int i;

   for (i = 0; i < size; ++i) {
      printf("%0.4f\t", arr[i]);
   }
   printf("\n");
}


void
insertionSort(float *arr, int size)
{
   int i, j;
   float key;

   for (j = 1; j < size; ++j) {
      key = arr[j];
      i = j - 1;
      while (i >= 0 && arr[i] > key) {
         arr[i + 1] = arr[i];
         --i;
      }
      arr[i + 1] = key;
   }
}

void
bucketSort(float *inArr, int size)
{
   float **tmpArr;
   int *tmpSizes;
   int i, j;

   tmpArr = malloc(size * sizeof(*tmpArr));
   tmpSizes = malloc(size * sizeof(*tmpSizes));

   for (i = 0; i < size; ++i) {
      tmpArr[i] = malloc(size * sizeof(**tmpArr));
      memset(tmpArr[i], 0, size * sizeof(**tmpArr));
   }
   memset(tmpSizes, 0, size * sizeof(*tmpSizes));

   for (i = 0; i < size; ++i) {
      j = (int)(size * inArr[i]);
      tmpArr[j][tmpSizes[j]] = inArr[i];
      ++tmpSizes[j];
   }

   for (i = 0; i < size; ++i) {
      insertionSort(tmpArr[i], tmpSizes[i]);
   }

   memset(inArr, 0, size * sizeof(*inArr));
   j = size - 1;
   for (i = size - 1; i >= 0; --i) {
      while (tmpSizes[j] == 0) {
         --j;
      }
      inArr[i] = tmpArr[j][tmpSizes[j] - 1];
      --tmpSizes[j];
   }
   
   free(tmpSizes);
   for (i = 0; i < size; ++i) {
      free(tmpArr[i]);
   }
   free(tmpArr);
}

int
main(int argc, char **argv)
{
   float *arr;
   int size, i;

   if (argc < 2) {
      printf("Must supply array of values\n");
      exit(1);
   }

   size = argc - 1;
   arr = malloc(size * sizeof(*arr));

   for (i = 0; i < size; ++i) {
      arr[i] = atof(argv[i + 1]);
      if (arr[i] >= 1) {
         printf("Values must all be in [0, 1)\n");
         free(arr);
         exit(1);
      }
   }

   printArr(arr, size);
   bucketSort(arr, size);
   printArr(arr, size);

   free(arr);

   return 0;
}