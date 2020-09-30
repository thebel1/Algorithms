#include <stdlib.h>
#include <stdio.h>

int main(int argc, char **argv)
{
    return 0;
}

int *permuteByCyclic(int *A, int size)
{
    int *B, offset, dest;

    B = malloc(size * sizeof(*B));
    offset = rand() % (size - 1);

    for (int i = 0; i < size; ++i) {
        dest = i + offset;
        if (dest >= size) {
            dest = dest - n + 1;
        }
        B[dest] = A[i];
    }
    
    return B;
}