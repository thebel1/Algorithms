#include <stdlib.h>
#include <stdio.h>
#include <string.h>

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
arrayMax(int *arr, int size)
{
   int i, max;

   max = arr[0];

   for (i = 0; i < size; ++i) {
      if (arr[i] > max) {
         max = arr[i];
      }
   }

   return max;
}

void
countingSort(int *inArr, int size, int k, int *outArr)
{
   int *tmpArr;
   int i, j;

   i = 0;
   ++i;

   tmpArr = malloc((k + 1) * sizeof(*tmpArr));
   memset(tmpArr, 0, (k + 1) * sizeof(*tmpArr));

   for (j = 0; j < size; ++j) {
      tmpArr[inArr[j]] += 1;
   }

   for (i = 1; i < (k + 1); ++i) {
      tmpArr[i] += tmpArr[i - 1];
   }
   
   memset(outArr, 0, size * sizeof(*outArr));
   for (j = size - 1; j >= 0; --j) {
      outArr[tmpArr[inArr[j]] - 1] = inArr[j];
      --tmpArr[inArr[j]];
   }

   free(tmpArr);

}

int
main(int argc, char **argv)
{
   int *inArr, *outArr;
   int size, i, max;

   if (argc < 2) {
      printf("Must supply array of values\n");
      exit(1);
   }

   size = argc - 1;
   inArr = malloc(size * sizeof(*inArr));
   outArr = malloc(size * sizeof(*outArr));

   for (i = 0; i < size; ++i) {
      
      inArr[i] = atoi(argv[i + 1]);

      if (inArr[i] < 0) {
         printf("All numbers must be >0\n");
         free(outArr);
         free(inArr);
         exit(1);
      }
   }
   
   max = arrayMax(inArr, size);

   printArr(inArr, size);
   countingSort(inArr, size, max, outArr);
   printArr(outArr, size);

   free(outArr);
   free(inArr);

   return 0;
}