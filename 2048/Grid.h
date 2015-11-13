//
//  Grid.h
//
//  Created by Alex Smith on 27/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PositionStruct.h"
#import "CodableObject.h"

typedef struct {
    int rows, columns;
}GridSize;

typedef enum {
    VERTICAL, HORIZONTAL
}Orientation;

/*
 
 Indexes for different grid orientations:
 
 Horizontal grid:
 
 0   3   6
 1   4   7
 2   5   8
 
 Vertical grid:
 
 0   1   2
 3   4   5
 6   7   8
 
 */

@interface Grid : CodableObject

@property (nonatomic, readonly) GridSize size;
@property (nonatomic, readonly) Orientation orientation;

-(instancetype)initWithGridSize:(GridSize)size andOrientation:(Orientation)orientation;

-(Position)positionOfIndex:(int)index;
-(int)indexOfPosition:(Position)position;
-(Position)randomPositionAdjacentToPosition:(Position)position;

// new methods
-(Position)randomPosition;

@end
