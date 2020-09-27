import sys
import math

def main(argv):
    arr = [int(x) for x in argv[1:]]
    tmp = maxSubArray(arr, 0, len(arr) - 1)
    print(tmp)
    print(arr[tmp[0]:tmp[1] + 1])

def maxSubArray(arr, loIdx, hiIdx):
    if hiIdx == loIdx:
        return [loIdx, hiIdx, arr[loIdx]]
    else:
        midIdx = int(math.floor((loIdx + hiIdx) / 2))
        tmp = maxSubArray(arr, loIdx, midIdx)
        #print('left:\t' + str(tmp))
        leftLo = tmp[0]
        leftHi = tmp[1]
        leftSum = tmp[2]
        tmp = maxSubArray(arr, midIdx + 1, hiIdx)
        #print('right:\t' + str(tmp))
        rightLo = tmp[0]
        rightHi = tmp[1]
        rightSum = tmp[2]
        tmp = maxCrossingSubArray(arr, loIdx, midIdx, hiIdx)
        #print('cross:\t' + str(tmp))
        crossLo = tmp[0]
        crossHi = tmp[1]
        crossSum = tmp[2]
        if leftSum >= rightSum and leftSum >= crossSum:
            return [leftLo, leftHi, leftSum]
        elif rightSum >= leftSum and rightSum >= crossSum:
            return [rightLo, rightHi, rightSum]
        else:
            return [crossLo, crossHi, crossSum]

def maxCrossingSubArray(arr, loIdx, midIdx, hiIdx):
    leftSum = -sys.maxsize
    mySum = 0
    for i in range(midIdx, loIdx - 1, -1):
        mySum += arr[i]
        if mySum > leftSum:
            leftSum = mySum
            maxLeft = i
    rightSum = -sys.maxsize
    mySum = 0
    for j in range(midIdx + 1, hiIdx + 1):
        mySum += arr[j]
        if mySum > rightSum:
            rightSum = mySum
            maxRight = j
    return [maxLeft, maxRight, leftSum + rightSum]

if __name__ == '__main__':
    main(sys.argv)