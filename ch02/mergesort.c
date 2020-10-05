#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <limits.h>

#define CRASH { *(int*)0 = 1; }

void mergesort(int *arr, int p, int r);

int main(int argc, char **argv)
{
    int *arr, arrSz;

    if (argc < 3) {
        printf("Must supply list of numbers to sort.\n");
        return 0;
    }

    arrSz = argc - 1;
    arr = malloc(arrSz * sizeof(*arr));
    for (int i = 0; i < argc - 1; ++i) {
        arr[i] = atoi(argv[i + 1]);
    }

    mergesort(arr, 0, arrSz - 1);

    for (int i = 0; i < arrSz; ++i) {
        printf("%d\n", arr[i]);
    }

    free(arr);

    return 0;
}

void merge(int *arr, int loIdx, int midIdx, int hiIdx)
{
    int *left, *right, leftSz, rightSz, i, j, k;

    leftSz = midIdx - loIdx + 2;
    rightSz = hiIdx - midIdx + 1;

    left = malloc(leftSz * sizeof(*left));
    right = malloc(rightSz * sizeof(*right));

    memcpy(left, &arr[loIdx], (leftSz - 1) * sizeof(*left));
    memcpy(right, &arr[midIdx + 1], (rightSz - 1) * sizeof(*right));

    left[leftSz - 1] = INT_MAX;
    right[rightSz - 1] = INT_MAX;

    i = 0;
    j = 0;
    for (k = loIdx; k <= hiIdx; ++k) {
        if (left[i] <= right[j]) {
            arr[k] = left[i];
            ++i;
        }
        else {
            arr[k] = right[j];
            ++j;
        }
    }

    free(left);
    free(right);
}

void mergesort(int *arr, int loIdx, int hiIdx)
{
    int midIdx;

    if (loIdx < hiIdx) {
        // Division by two but keeping it an int.
        midIdx = loIdx + ((hiIdx - loIdx) >> 1);

        mergesort(arr, loIdx, midIdx);
        mergesort(arr, midIdx + 1, hiIdx);
        merge(arr, loIdx, midIdx, hiIdx);
    }
}