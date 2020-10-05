import math

def permutateByCyclic(A):
    n = len(A)
    B = [0] * n
    offset = math.rand(0, n-1)
    for i in range(n):
        dest = i + offset
        if dest >= n:
            dest = dest - n + 1
        B[dest] = A[i]
    return B