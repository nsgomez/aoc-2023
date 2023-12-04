#!/usr/bin/python3
import sys

cardLines = [line for line in sys.stdin]
originalCardCount = len(cardLines)
cardInstances = [1] * originalCardCount

totalCards = originalCardCount

cardNum = 1
i = 0

while i < len(cardLines):
    line = cardLines[i]
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
            #print("Card " + str(cardNum) + " has winning number " + str(num))
            cardPoints = cardPoints + 1

    # Insert duplicate cards
    rep = 0
    instanceCount = cardInstances[i]

    while rep < instanceCount:
        j = 1
        while j <= cardPoints:
            if i + j < originalCardCount:
                cardInstances[i + j] = cardInstances[i + j] + 1
                totalCards = totalCards + 1

            j = j + 1

        #print(line)
        rep = rep + 1

    cardNum = cardNum + 1
    i = i + 1

print(totalCards)
