#include <stdlib.h>
#include <stdio.h>

int main(int argc, char **argv)
{
    int *arr;
    int arrSz;

    if (argc < 3) {
        printf("Must supply list of numbers to sort.\n");
        return 0;
    }

    arrSz = argc - 1;
    arr = malloc(arrSz * sizeof(*arr));
    for (int i = 0; i < argc - 1; ++i) {
        arr[i] = atoi(argv[i + 1]);
    }

    int i, key;
    for (int j = 1; j < arrSz; ++j) {
        key = arr[j];
        i = j - 1;
        while (i >= 0 && arr[i] > key) {
            arr[i + 1] = arr[i];
            --i;
        }
        arr[i + 1] = key;
    }

    for (int i = 0; i < arrSz; ++i) {
        printf("%d\n", arr[i]);
    }

    free(arr);

    return 0;
}

void isort(int *arr, int size)
{

}