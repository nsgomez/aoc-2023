#!/usr/bin/python3
import sys

totalPoints = 0
cardNum = 1

for line in sys.stdin:
    rawNumbers = line.split(': ')[1]
    numbers = rawNumbers.split(' | ')

    winningNumbers = []
    heldNumbers = []

    for x in numbers[0].split(' '):
        if not x.strip():
            continue

        winningNumbers.append(int(x.strip()))

    for y in numbers[1].split(' '):
        if not y.strip():
            continue

        heldNumbers.append(int(y.strip()))

    cardPoints = 0
    for num in heldNumbers:
        if winningNumbers.count(num) > 0:
            if cardPoints == 0:
                cardPoints = 1
            else:
                cardPoints = cardPoints * 2

    cardNum = cardNum + 1
    totalPoints = totalPoints + cardPoints

print(totalPoints)
