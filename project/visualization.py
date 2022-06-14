import cv2
import numpy as np
TEXT_HEIGHT = 25
TEXT_WIDTH = 50
HEIGHT_OFFSET = 1.2
WIDTH_OFFSET = 2
medium = 0
height = 0
width = 0

class treeNode:
    def __init__(self, lines, level, grammar):
        self.level = level
        self.lines = lines
        self.grammar = grammar

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
        single = line.split(' ')
        temp = len(single) - 2
        if temp > Max:
            Max = temp 
    return Max 

def CreateEmptyImg(height, width):
    shape = (int(height * HEIGHT_OFFSET * TEXT_HEIGHT), int(width * WIDTH_OFFSET * TEXT_WIDTH), 3) # y, x, RGB
    medium = int(width * WIDTH_OFFSET * TEXT_WIDTH /2) 
    origin_img = np.full(shape, 255).astype(np.uint8)
    return origin_img, medium

def TraverseTree(img,tree,medium):
    currentHeight = 10
    for line in tree:
        lines = line.split(' ')
        lines = lines[:-2]
        currentX = medium
        currentX -= int(70 * len(lines)/2)
        for text in lines:
            #           影像, 文字, 座標, 字型, 大小, 顏色, 線條寬度, 線條種類
            #cv2.putText(emptyImg, 'test', (10, 40), cv2.FONT_HERSHEY_PLAIN, 1, (0, 0, 0), 1, cv2.LINE_AA)
            cv2.putText(img, text, (currentX, currentHeight), cv2.FONT_HERSHEY_PLAIN, 1, (0, 0, 0), 1, cv2.LINE_AA)
            tempTextWidth = len(text)
            currentX += (tempTextWidth * 11)
        currentHeight += 20
    return img
def main():
    testPath = 'tree/test1.txt'
    tree = ReadFile(testPath)
    height = len(tree)
    width = CountMax(tree)
    emptyImg, medium = CreateEmptyImg(height, width)
    newTree = []
    for line in tree:
        lines = line.split(' ')
        print(lines)
        depth = FoundDepth(lines[-2])
        lines = lines[:-3]
        if depth >= len(newTree):
            newTree.append([lines])
        else:
            newTree[depth].append(lines)
    
    print(newTree)

    img = TraverseTree(emptyImg, tree,medium)
    cv2.imshow('My Image', img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()