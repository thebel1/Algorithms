#include <stdlib.h>
#include <stdio.h>

int *squareMatrixMul(int *A, int *B, int size);

// TODO: figure out how to deserialize a string into a matrix.
int main(int argc, char **argv)
{
    
    return 0;
}

int *squareMatrixMul(int *A, int *B, int size)
{
    int *C;

    // Allocate space for a square matrix.
    C = malloc(size * size * sizeof(*C));

    for (int i = 0; i < size; ++i) {
        for (int j = 0; j < size; ++j) {
            for (int k = 0; k < size; ++k) {
                C[i*size + j] += A[i*size + k] * B[k*size + j];
            }
        }
    }

    return C;
}