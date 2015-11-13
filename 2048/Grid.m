//
//  Grid.m
//
//  Created by Alex Smith on 27/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "Grid.h"

@interface Grid ()

@property (nonatomic, readwrite) GridSize size;
@property (nonatomic, readwrite) Orientation orientation;
@property (strong, nonatomic, readwrite) NSString *gridSizeString;

@end

@implementation Grid

-(instancetype)initWithGridSize:(GridSize)size andOrientation:(Orientation)orientation
{
    if (self = [super init]) {
        self.size = size;
        self.orientation = orientation;
    }
    
    return self;
}

-(Position)positionOfIndex:(int)index;
{
    return self.orientation == VERTICAL ?
        (Position){index / self.size.columns, index % self.size.columns} :
        (Position){index % self.size.rows, index / self.size.rows};
}

-(int)indexOfPosition:(Position)position;
{
    return self.orientation == VERTICAL ?
        self.size.columns * position.row + position.column :
        self.size.rows * position.column + position.row;
}

-(Position)randomPosition
{
    int randomRow = arc4random() % self.size.rows;
    int randomCol = arc4random() % self.size.columns;
    
    return (Position){randomRow, randomCol};
}

-(Position)randomPositionAdjacentToPosition:(Position)position
{
    Position adjacentPos = position;
    
    int maxRow = self.size.rows - 1;
    int maxCol = self.size.columns - 1;

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

#pragma mark - Coding/Decoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeInt:self.size.rows forKey:@"rows"];
    [aCoder encodeInt:self.size.columns forKey:@"columns"];
    [aCoder encodeInt:self.orientation forKey:@"orientation"];

}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        int rows = [aDecoder decodeIntForKey:@"rows"];
        int columns = [aDecoder decodeIntForKey:@"columns"];
        self.size = (GridSize){rows, columns};
        
        self.orientation = [aDecoder decodeIntForKey:@"orientation"];
    }
    
    return self;
}

-(NSArray *)propertyNames
{
    return @[];
}

@end
