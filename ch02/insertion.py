import sys

def main(argv):
    arr = []
    for idx in range(1, len(argv)):
        arr.append(int(argv[idx]))
    isort(arr)
    print(arr)

def isort(arr):
    for j in range(1, len(arr)):
        key = arr[j]
        i = j - 1
        while i >= 0 and arr[i] > key:
            arr[i + 1] = arr[i]
            i -= 1
        arr[i + 1] = key

if __name__ == '__main__':
    main(sys.argv)