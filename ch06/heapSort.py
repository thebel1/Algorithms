#!/usr/bin/python

import sys, math

def heapLeft(i):
    return i << 1

def heapRight(i):
    return (i << 1) + 1

def heapParent(i):
    return i >> 1

def maxHeapify(A, heapSize, i):
    left = heapLeft(i)
    right = heapRight(i)
    if left < heapSize and A[left] > A[i]:
        largest = left
    else:
        largest = i
    if right < heapSize and A[right] > A[largest]:
        largest = right
    if largest != i:
        tmp = A[i]
        A[i] = A[largest]
        A[largest] = tmp
        maxHeapify(A, heapSize, largest)

def buildMaxHeap(A):
    n = int(math.floor(len(A)/2))
    for i in range(n, -1, -1):
        maxHeapify(A, len(A), i)

def heapSort(A):
    heapSize = len(A)
    buildMaxHeap(A)
    for i in range(heapSize - 1, 0, -1):
        tmp = A[0]
        A[0] = A[i]
        A[i] = tmp
        heapSize -= 1
        maxHeapify(A, heapSize, 0)

def main(argv):
    if len(argv) < 3:
        print('Must supply input array.')
        exit(1)

    arr = []
    for num in argv[1:]:
        arr.append(int(num))
    
    heapSort(arr)
    print(arr)

if __name__ == '__main__':
    main(sys.argv)