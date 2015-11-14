//
//  TwentyFourtyEight.m
//  2048
//
//  Created by Alex Smith on 18/10/2015.
//  Copyright © 2015 Alex Smith. All rights reserved.
//

#import "TwentyFourtyEight.h"
#import "NSArray+Reverse.h"

@interface TwentyFourtyEight ()

@property (nonatomic) BOOL gameInPlay;
@property (nonatomic) int score;
@property (nonatomic, strong) GridOfObjects *board;

@end

@implementation TwentyFourtyEight

#pragma mark - Initialiser

-(instancetype)initWithGameOfSize:(GridSize)size;
{
    if (self = [super init]) {
        self.board = [[GridOfObjects alloc] initWithGridSize:size andOrientation:VERTICAL];
        
        // set all tiles to 0 initially
        for (int row = 0; row < self.board.size.rows; row++) {
            for (int col = 0; col < self.board.size.columns; col++) {
                [self.board setPosition:(Position){row,col} toObject:[NSNumber numberWithInt:0]];
            }
        }
        
        [self newTile];
        [self newTile];
        
        /*for (int i = 0; i < 10; i++) {
            NSLog(@"BOARD BEFORE");
            NSLog(@"%@", self.board);
            [self swipeInDirection:UP];
            NSLog(@"BOARD AFTER");
            NSLog(@"%@", self.board);
            [self newTile];
        }*/

    }
    
    return self;
}

#pragma mark - Other

-(void)swipeInDirection:(SwipeDirection)direction;
{
    NSLog(@"BOARD BEFORE");
    NSLog(@"%@", self.board);

    NSArray *tilesToMerge;
    NSArray *mergedTiles;
    
    if (direction == LEFT || direction == RIGHT) {
        for (int row = 0; row < self.board.size.rows; row++) {
            
            tilesToMerge = [self.board objectsInRow:row reversed:direction == RIGHT];
            mergedTiles = [self mergeLine:tilesToMerge];
            
            [self.board replaceObjectsInRow:row withObjects:mergedTiles reversed:direction == RIGHT];
        }
    } else if (direction == UP || direction == DOWN) {
        for (int col = 0; col < self.board.size.columns; col++) {
            
            tilesToMerge = [self.board objectsInColumn:col reversed:direction == DOWN];
            mergedTiles = [self mergeLine:tilesToMerge];
            
            [self.board replaceObjectsInColumn:col withObjects:mergedTiles reversed:direction == DOWN];
        }
    }
    
    NSLog(@"BOARD AFTER");
    NSLog(@"%@", self.board);
    [self newTile];
}

-(void)newTile
{
    // pick a random blank spot on the board
    int valueAtRandomPos = -100;
    Position randomPos;
    while (valueAtRandomPos != 0) {
        randomPos = [self.board randomPosition];
        NSNumber *valueObjectAtRandPos = (NSNumber *)[self.board objectAtPosition:randomPos];
        valueAtRandomPos = [valueObjectAtRandPos intValue];
    }
    
    // pick a tile value (2 or 4 - weighted)
    int num = arc4random() % 10;
    int tileValue = 2;
    
    if (num > 8) {
        tileValue = 4;
    }
    
    // place tile value in the random blank spot
    [self.board setPosition:randomPos toObject:[NSNumber numberWithInt:tileValue]];
}

-(NSArray *)mergeLine:(NSArray *)line
{
    NSMutableArray *mergedLine = [line mutableCopy];
    
    // remove all 0's from the merged line (will add them back later)
    [mergedLine removeObject:[NSNumber numberWithInt:0]];
    
    // find the number of 0's to add back later
    NSCountedSet *zeroCounter = [NSCountedSet setWithArray:line];
    NSUInteger numZeroesInLine = [zeroCounter countForObject:[NSNumber numberWithInt:0]];
    
    // merge the non-zero tiles
    if ([mergedLine count] > 1) {
        int tileIdx = 0;
        while (tileIdx < [mergedLine count] - 1) {
            if ([ mergedLine[tileIdx] isEqualToNumber:mergedLine[tileIdx + 1] ]) {
                int summedVal = [mergedLine[tileIdx] intValue] + [mergedLine[tileIdx + 1] intValue];
                mergedLine[tileIdx] = [NSNumber numberWithInt:summedVal];
                // slide the tiles left (we now need to append another 0 at the end)
                [mergedLine removeObjectAtIndex:tileIdx + 1];
                numZeroesInLine++;
            }
            tileIdx++;
        }
    }
    
    // add back the zeroes
    for (int zeroCount = 0; zeroCount < numZeroesInLine; zeroCount++) {
        [mergedLine addObject:[NSNumber numberWithInt:0]];
    }
    
    return [NSArray arrayWithArray:mergedLine];
}

@end
