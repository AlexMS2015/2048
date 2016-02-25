//
//  GridOfObjects.m
//  CollectionViewTest
//
//  Created by Alex Smith on 22/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "GridOfObjects.h"

@implementation GridOfObjects

-(instancetype)initWithRows:(NSInteger)rows andColumns:(NSInteger)cols
{
    if (self = [super init]) {
        self.objects = [NSMutableArray arrayWithCapacity:rows];
        
        for (int row = 0; row < rows; row++) {
            self.objects[row] = [NSMutableArray arrayWithCapacity:cols];
        }
        
        self.numRows = rows;
        self.numCols = cols;
    }
    
    return self;
}

-(void)swapObjectAtPosition:(Position)position1 withObjectAtPosition:(Position)position2
{
    id obj1 = self.objects[position1.row][position1.column];
    id obj2 = self.objects[position2.row][position2.column];
    
    [self.objects[position1.row] replaceObjectAtIndex:position1.column withObject:obj2];
    [self.objects[position2.row] replaceObjectAtIndex:position2.column withObject:obj1];
}

-(Position)positionOfObject:(id)object
{
    __block Position objectPos = (Position){999, 999};
    
    [self enumerateWithBlock:^(Position position, id obj) {
        if (obj == object) {
            objectPos = position;
        }
    }];
    
    return objectPos;
}

-(void)enumerateWithBlock:(void (^)(Position position, id object))block
{
    for (int row = 0; row < self.numRows; row++) {
        for (int col = 0; col < self.numCols; col++) {
            Position position = (Position){row, col};
            block(position, self.objects[row][col]);
        }
    }
}

-(Position)randomPositionAdjacentToPosition:(Position)position
{
    Position adjacentPos = position;
    
    NSInteger maxRow = self.numRows - 1;
    NSInteger maxCol = self.numCols - 1;
    
    while (PositionsAreEqual(position, adjacentPos)) {
        int randomTile = arc4random() % 4;
        
        if (randomTile == 0 && position.column > 0) {
            adjacentPos.column--;
        } else if (randomTile == 1 && position.column < maxCol) {
            adjacentPos.column++;
        } else if (randomTile == 2 && position.row > 0) {
            adjacentPos.row--;
        } else if (randomTile == 3 && position.row < maxRow) {
            adjacentPos.row++;
        }
    }
    
    return adjacentPos;
}

@end
