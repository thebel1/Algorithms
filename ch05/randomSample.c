#include <stdlib.h>
#include <stdio.h>

#define SAMPLE_INIT_SZ 32

typedef struct Sample {
    int *arr;
    int size;
    int allocSz;
} Sample;

Sample *initSample()
{
    Sample *S;

    S = malloc(sizeof(*S));

    S->allocSz = SAMPLE_INIT_SZ
    S->arr = malloc(S->allocSz);
    S->size = 0;

    return S;
}

void pushSample(Sample *S, int elem)
{
    if (S->size + 1 >= S->allocSz) {
        S->arr = realloc(S->arr, S->allocSz * 2);
    }
    S->arr[S->size++] = elem;
}

int popSample(Sample *S)
{
    if (S->size == 0) {
        return NULL;
    }

    return S->arr[--S->size];
}

void freeSample(Sample *S)
{
    free(S->arr);
    free(S);
}

Sample *randomSample(int m, int n)
{
    int i;
    Sample *S;

    if (m == 0) {
        S = initSample();
        return S;
    }

    S = randomSample(m - 1, n - 1);
    i = rand() % (n - 1);

    for (int j = 0; j < S->size; ++j) {
        if (i == S->arr[j]) {
            pushSample(S, n);
        }
        else {
            pushSample(S, i);
        }
    }

    return S;
}

int main(int argc, char **argv)
{
    return 0;
}