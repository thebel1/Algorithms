import sys
import math

def main(argv):
    arr = []
    for idx in range(1, len(argv)):
        arr.append(int(argv[idx]))
    mergesort(arr, 0, len(arr) - 1)
    print(arr)

def mergesort(arr, loIdx, hiIdx):
    if loIdx < hiIdx:
        midIdx = loIdx + int(math.floor((hiIdx - loIdx) / 2))
        mergesort(arr, loIdx, midIdx)
        mergesort(arr, midIdx + 1, hiIdx)
        merge(arr, loIdx, midIdx, hiIdx)

def merge(arr, loIdx, midIdx, hiIdx):
    left = arr[loIdx:midIdx + 1]
    right = arr[midIdx + 1:hiIdx + 1]
    left.append(sys.maxsize)
    right.append(sys.maxsize)
    i = 0
    j = 0
    for k in range(loIdx, hiIdx + 1):
        if left[i] <= right[j]:
            arr[k] = left[i]
            i += 1
        else:
            arr[k] = right[j]
            j += 1

if __name__ == "__main__":
    main(sys.argv)