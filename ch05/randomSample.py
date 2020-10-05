import math

def randomSample(m, n):
    if m == 0:
        return []
    S = randomSample(m - 1, n - 1)
    i = math.rand(1, n)
    if i in S:
        S.append(n)
    else:
        S.append(i)
    return S