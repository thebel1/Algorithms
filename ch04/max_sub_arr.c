#include <stdlib.h>
#include <stdio.h>
#include <limits.h>

#define CRASH { asm("ud2"); }

typedef struct SubArray {
    int loIdx;
    int hiIdx;
    int sum;
} SubArray;

SubArray *maxCrossingSubArray(int *arr, int loIdx, int midIdx, int hiIdx)
{
    int sum, leftSum, rightSum, maxLeft, maxRight;
    SubArray *subArr;

    subArr = malloc(sizeof(*subArr));

    leftSum = INT_MIN;
    sum = 0;
    for (int i = midIdx; i >= loIdx; --i) {
        sum += arr[i];
        if (sum > leftSum) {
            leftSum = sum;
            maxLeft = i;
        }
    }

    rightSum = INT_MIN;
    sum = 0;
    for (int j = midIdx + 1; j <= hiIdx; ++j) {
        sum += arr[j];
        if (sum > rightSum) {
            rightSum = sum;
            maxRight = j;
        }
    }

    subArr->loIdx = maxLeft;
    subArr->hiIdx = maxRight;
    subArr->sum = leftSum + rightSum;

    return subArr;
}

SubArray *maxSubArray(int *arr, int loIdx, int hiIdx)
{
    SubArray *subArr;

    // Edge case: single array element.
    if (hiIdx == loIdx) {
        subArr = malloc(sizeof(*subArr));
        subArr->loIdx = loIdx;
        subArr->hiIdx = hiIdx;
        subArr->sum = arr[loIdx];
        goto leave;
    }
    
    // Divide by 2 while keeping it an int.
    int midIdx = (loIdx + hiIdx) >> 1;

    SubArray *leftSubArr = maxSubArray(arr, loIdx, midIdx);
    SubArray *rightSubArr = maxSubArray(arr, midIdx + 1, hiIdx);
    SubArray *crossSubArr = maxCrossingSubArray(arr, loIdx, midIdx, hiIdx);

    if (leftSubArr->sum >= rightSubArr->sum
        && leftSubArr->sum >= crossSubArr->sum)
    {
        subArr = leftSubArr;
        free(rightSubArr);
        free(crossSubArr);
        goto leave;
    }
    else if (rightSubArr->sum >= leftSubArr->sum
        && rightSubArr->sum >= crossSubArr->sum)
    {
        subArr = rightSubArr;
        free(leftSubArr);
        free(crossSubArr);
        goto leave;
    }
    
    subArr = crossSubArr;
    free(leftSubArr);
    free(rightSubArr);

leave:
    return subArr;
}

int main(int argc, char **argv)
{
    int *arr, arrSz;
    SubArray *subArr;

    if (argc < 3) {
        printf("Must supply array.\n");
        exit(1);
    }

    arrSz = argc - 1;
    arr = malloc(arrSz*sizeof(*arr));
    for (int i = 0; i < arrSz; ++i) {
        arr[i] = atoi(argv[i + 1]);
    }

    subArr = maxSubArray(arr, 0, arrSz - 1);

    printf("[%d, %d, %d]\n", subArr->loIdx, subArr->hiIdx, subArr->sum);
    for (int i = subArr->loIdx; i <= subArr->hiIdx; ++i) {
        printf("%d\n", arr[i]);
    }

    free(subArr);
    free(arr);

    return 0;
}

