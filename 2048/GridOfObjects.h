//
//  GridOfObjects.h
//
//  Created by Alex Smith on 26/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Grid.h"
#import "NSArray+Reverse.h"

@interface GridOfObjects : Grid

#warning - THERE NEEDS TO BE A CHECK TO STOP INSERTING AT POSITONS OUTSIDE THE GRID (too large)

#warning - WHY is this public?
@property (nonatomic, strong) NSArray *objects;

-(instancetype)initWithGridSize:(GridSize)size
                 andOrientation:(Orientation)orientation
                     andObjects:(NSArray *)objects; // will initiate with NSNull object in every position if the superclass's initialiser is used or no objects are provided to this method

-(id)objectAtPosition:(Position)position;
-(Position)positionOfObject:(id)object;

-(void)setPosition:(Position)position toObject:(id)object;
-(void)swapObjectAtPosition:(Position)position1 withObjectAtPosition:(Position)position2;

-(NSArray *)objectsInRow:(int)row;
-(NSArray *)objectsInColumn:(int)column;
-(void)replaceObjectsInRow:(int)row withObjects:(NSArray *)objects;
-(void)replaceObjectsInColumn:(int)col withObjects:(NSArray *)objects;

-(void)enumerateWithBlock:(void (^)(Position position, int index, id obj))block;

@end
