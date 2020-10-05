#!/usr/bin/python

import sys

def main(argv):
    # TODO: figure out a way of deserializing matrix strings.
    pass

def squareMatrixMul(A, B):
    n = len(A)
    C = [[0]*n for x in range(n)]
    for i in range(n):
        for j in range(n):
            for k in range(n):
                C[i][j] += A[i][k] * B[k][j]
    return C

if __name__ == '__main__':
    main(sys.argv)