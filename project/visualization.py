import cv2
import numpy as np
TEXT_HEIGHT = 25
TEXT_WIDTH = 50
HEIGHT_OFFSET = 2
WIDTH_OFFSET = 2.5
medium = 0
height = 0
width = 0

class treeNode:
    def __init__(self, lines, level, grammar):
        self.level = level
        self.lines = lines
        self.grammar = grammar

def AnalysisTree(tree):
    newTree = []
    for line in tree:
        lines = line.split(' ')
        depth = FoundDepth(lines[-2])
        lines = lines[:-2]
        
        if depth >= len(newTree):
            newTree.append([lines])
        else:
            newTree[depth].append(lines)

    for i in range(len(newTree)):
        newTree[i].reverse()
    newTree.insert(0,['program'])
    return newTree

def FoundDepth(string):
    string = string[:-1]
    string = string[6:]
    return int(string)

def ReadFile(path):
    with open(path) as f:
        tree = f.readlines()
    return tree

def CountMax(tree):
    Max = 0
    for line in tree:
        total = 0
        for single in line:
            total += len(single)
        if total > Max:
            Max = total 
    return Max 

def CreateEmptyImg(height, width):
    shape = (int(height * HEIGHT_OFFSET * TEXT_HEIGHT), int(width * WIDTH_OFFSET * TEXT_WIDTH), 3) # y, x, RGB
    medium = int(width * WIDTH_OFFSET * TEXT_WIDTH /2) 
    origin_img = np.full(shape, 255).astype(np.uint8)
    return origin_img, medium

def GetFatherAllText(lines):
    answer = []
    for line in lines:
        for text in line:
            answer.append(text)
    return answer

def FindFatherWidth(search,lines):
    search = search[7:-3]
    newFather = lines
    index = -1
    for i in range(len(lines)):
        if search == lines[i]:
            index = i
            newFather.pop(i)
            break
    return index,newFather            

def TraverseTree(img,tree):
    currentHeight = 20
    for j in range(len(tree)):
        lines = tree[j]
        currentX = 10
        total = len(lines)
        for i in range(total):
            line = lines[i]
            fatherAllText = GetFatherAllText(tree[j-1])
            textNums = 0
            for text in line:
                color = (0,0,0)
                if text.islower():
                    color = (0,0,255)
                    if 'reduce' in text:
                        color = (255,0,255)
                textNums += 1
                cv2.putText(img, text, (currentX, currentHeight), cv2.FONT_HERSHEY_PLAIN, 1, color, 1, cv2.LINE_AA)
                tempTextWidth = len(text)
                currentX += (tempTextWidth * 11)
            if i < total -1:
                cv2.putText(img, '|', (currentX-15, currentHeight), cv2.FONT_HERSHEY_PLAIN, 1, (255, 0, 0), 2, cv2.LINE_AA)
            #畫線
            '''
            if (j >= 1):
                fatherHeight = currentHeight-45
                fatherIndex, fatherAllText = FindFatherWidth(line[-1],fatherAllText)
                childWidth = currentX - (78 * textNums) 
                cv2.line(img, (fatherIndex * 90, fatherHeight + 10), (childWidth, currentHeight - 15), (0, 0, 255), 1)'''
        currentHeight += 45
    return img

def main():
    testPath = 'tree/test1.txt'
    tree = ReadFile(testPath)
    newTree = AnalysisTree(tree)
    height = len(newTree)
    width = CountMax(newTree)
    img, medium = CreateEmptyImg(height, width)
    img = TraverseTree(img, newTree)
    cv2.imshow('Syntax Tree', img)
    cv2.imwrite('test1.jpg',img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()