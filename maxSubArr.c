#include <stdlib.h>
#include <stdio.h>
#include <limits.h>

struct SubArr {
   int loIdx;
   int hiIdx;
   int sum;
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

struct SubArr *
maxCrossSubArr(int *arr, int loIdx, int midIdx, int hiIdx)
{
   struct SubArr *subArr;
   int leftSum, rightSum, sum;
   int maxLeft, maxRight;
   int i, j;

   leftSum = INT_MIN;
   sum = 0;

   for (i = midIdx; i >= loIdx; --i) {
      sum += arr[i];
      if (sum > leftSum) {
         leftSum = sum;
         maxLeft = i;
      }
   }

   rightSum = INT_MIN;
   sum = 0;

   for (j = midIdx + 1; j <= hiIdx; ++j) {
      sum += arr[j];
      if (sum > rightSum) {
         rightSum = sum;
         maxRight = j;
      }
   }

   subArr = malloc(sizeof(*subArr));
   subArr->loIdx = maxLeft;
   subArr->hiIdx = maxRight;
   subArr->sum = leftSum + rightSum;

   return subArr;
}

struct SubArr *
maxSubArr(int *arr, int loIdx, int hiIdx)
{
   struct SubArr *subArr;
   int midIdx;
   int leftLo, leftHi, leftSum;
   int rightLo, rightHi, rightSum;
   int crossLo, crossHi, crossSum;

   if (loIdx == hiIdx) {
      subArr = malloc(sizeof(*subArr));
      subArr->loIdx = loIdx;
      subArr->hiIdx = hiIdx;
      subArr->sum = arr[loIdx];
      
      return subArr;
   }

   midIdx = (loIdx + hiIdx) / 2;
   
   subArr = maxSubArr(arr, loIdx, midIdx);
   leftLo = subArr->loIdx;
   leftHi = subArr->hiIdx;
   leftSum = subArr->sum;
   free(subArr);

   subArr = maxSubArr(arr, midIdx + 1, hiIdx);
   rightLo = subArr->loIdx;
   rightHi = subArr->hiIdx;
   rightSum = subArr->sum;
   free(subArr);

   subArr = maxCrossSubArr(arr, loIdx, midIdx, hiIdx);
   crossLo = subArr->loIdx;
   crossHi = subArr->hiIdx;
   crossSum = subArr->sum;
   free(subArr);

   subArr = malloc(sizeof(*subArr));
   if (leftSum >= rightSum && leftSum >= crossSum) {
      subArr->loIdx = leftLo;
      subArr->hiIdx = leftHi;
      subArr->sum = leftSum;
      return subArr;
   }
   else if (rightSum >= leftSum && rightSum >= crossSum) {
      subArr->loIdx = rightLo;
      subArr->hiIdx = rightHi;
      subArr->sum = rightSum;
      return subArr;
   }
   else {
      subArr->loIdx = crossLo;
      subArr->hiIdx = crossHi;
      subArr->sum = crossSum;
      return subArr;
   }
}

int
main(int argc, char **argv)
{
   int *arr;
   int size, i;
   struct SubArr *subArr;

   if (argc < 2) {
      printf("Must supply array of numbers\n");
      exit(1);
   }

   size = argc - 1;
   arr = malloc(size * sizeof(*arr));

   for (i = 0; i < size; ++i) {
      arr[i] = atoi(argv[i + 1]);
   }

   printArr(arr, size);
   subArr = maxSubArr(arr, 0, size - 1);
   printf("loIdx:\t%d\nhiIdx:\t%d\nsum:\t%d\n",
          subArr->loIdx, subArr->hiIdx, subArr->sum);
   printArr(&arr[subArr->loIdx],
            subArr->hiIdx - subArr->loIdx + 1);

   free(subArr);
   free(arr);

   return 0;
}