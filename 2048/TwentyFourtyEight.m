//
//  TwentyFourtyEight.m
//  2048
//
//  Created by Alex Smith on 18/10/2015.
//  Copyright © 2015 Alex Smith. All rights reserved.
//

#import "TwentyFourtyEight.h"
#import "NSArray+Reverse.h"
#import "TwentyFourtyEightTileOffset.h"

@interface TwentyFourtyEight ()

@property (nonatomic) BOOL gameInPlay;
@property (nonatomic) int score;
@property (nonatomic, strong) GridOfObjects *board;
@property (nonatomic, strong) GridOfObjects *offsetsForMostRecentMove;

@end

@implementation TwentyFourtyEight

#pragma mark - Initialiser

-(instancetype)initWithGameOfSize:(GridSize)size;
{
    if (self = [super init]) {
        self.board = [[GridOfObjects alloc] initWithGridSize:size andOrientation:VERTICAL];
        self.offsetsForMostRecentMove = [[GridOfObjects alloc] initWithGridSize:size andOrientation:VERTICAL];
        
        // set all tiles to 0 initially
        for (int row = 0; row < self.board.size.rows; row++) {
            for (int col = 0; col < self.board.size.columns; col++) {
                [self.board setPosition:(Position){row,col} toObject:[NSNumber numberWithInt:0]];
            }
        }
        
        [self newTile];
        [self newTile];
    }
    
    return self;
}

#pragma mark - Other

-(void)swipeInDirection:(NSString *)direction;
{
    //NSLog(@"BOARD BEFORE");
    //NSLog(@"%@", self.board);
#warning - This isn't really neccessary?
    self.offsetsForMostRecentMove = [[GridOfObjects alloc] initWithGridSize:self.board.size andOrientation:VERTICAL];
    
    NSArray *tilesToMerge;
    NSArray *mergedTilesAndOffsets;
    
    if ([direction isEqualToString:@"LEFT"] || [direction isEqualToString:@"RIGHT"]) {
        for (int row = 0; row < self.board.size.rows; row++) {
            tilesToMerge = [self.board objectsInRow:row reversed:NO];
            
            mergedTilesAndOffsets = [self mergeLine:tilesToMerge inDirection:direction];
            [self.board replaceObjectsInRow:row withObjects:[mergedTilesAndOffsets firstObject] reversed:NO];
            [self.offsetsForMostRecentMove replaceObjectsInRow:row withObjects:[mergedTilesAndOffsets lastObject] reversed:NO];
        }
    } else if ([direction isEqualToString:@"UP"] || [direction isEqualToString:@"DOWN"]) {
        for (int col = 0; col < self.board.size.columns; col++) {
            tilesToMerge = [self.board objectsInColumn:col reversed:NO];
            
            mergedTilesAndOffsets = [self mergeLine:tilesToMerge inDirection:direction];
            [self.board replaceObjectsInColumn:col withObjects:[mergedTilesAndOffsets firstObject] reversed:NO];
            [self.offsetsForMostRecentMove replaceObjectsInColumn:col withObjects:[mergedTilesAndOffsets lastObject] reversed:NO];
        }
    }
    
    //self.score += 1;
    [self newTile];
    
    //NSLog(@"BOARD AFTER");
    //NSLog(@"%@", self.board);
    //NSLog(@"%@", self.offsetsForMostRecentMove);
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
    
    // add the tile's value to the score
    self.score += tileValue;
}

-(NSDictionary *)directionOffsets
{
    return @{@"UP" : @[@(-1), @(0)],
             @"DOWN" : @[@(1), @(0)],
             @"LEFT" : @[@(0), @(-1)],
             @"RIGHT" : @[@(0), @(1)]};
}

-(NSArray *)directionToReverse
{
    return @[@"DOWN", @"RIGHT"];
}

-(NSArray *)mergeLine:(NSArray *)line inDirection:(NSString *)direction
{
    //NSLog(@"Unmerged Line: %@", line);
    
    NSMutableArray *mergedLine = [line mutableCopy];
    
    NSMutableArray *offsets = [NSMutableArray array];
    for (int i = 0; i < [mergedLine count]; i++)
        [offsets addObject:[[TwentyFourtyEightTileOffset alloc] init]];
    
    NSArray *offsetForDir = [self directionOffsets][direction];
    int rowOffset = [[offsetForDir firstObject] intValue];
    int colOffset = [[offsetForDir lastObject] intValue];
    
    if ([[self directionToReverse] containsObject:direction]) {
        mergedLine = [[mergedLine arrayInReverseOrder] mutableCopy];
        offsets = [[offsets arrayInReverseOrder] mutableCopy];
    }
    
    for (int tileIdx = 1; tileIdx < [mergedLine count]; tileIdx++) {
        if ([mergedLine[tileIdx] intValue] != 0) {
            TwentyFourtyEightTileOffset *offset = offsets[tileIdx];
            for (int tileIdx2 = tileIdx - 1; tileIdx2 >= 0; tileIdx2--) {
                if ([mergedLine[tileIdx2] intValue] == 0) {
                    [mergedLine exchangeObjectAtIndex:tileIdx2 withObjectAtIndex:tileIdx2 + 1];
                    offset.rowOffset += rowOffset;
                    offset.colOffset += colOffset;
                } else if ([mergedLine[tileIdx2] isEqualToNumber:mergedLine[tileIdx2 +1]]) {
                    TwentyFourtyEightTileOffset *offsetAtIdx2 = (TwentyFourtyEightTileOffset *)offsets[tileIdx2];
                    
                    if (offsetAtIdx2.merged == NO) {
                        int summedVal = 2 * [mergedLine[tileIdx2] intValue];
                        mergedLine[tileIdx2] = [NSNumber numberWithInt:summedVal];
                        mergedLine[tileIdx2 + 1] = [NSNumber numberWithInt:0];
                        
                        offsetAtIdx2.merged = YES;
                        offset.rowOffset += rowOffset;
                        offset.colOffset += colOffset;
                        
                        offset.visible = NO;
                        self.score += summedVal;
                        
                        break; // prevents multiple merges (e.g. [4, 2, 2] becoming [8, 0, 0] instead of [4, 4, 0]
                    }
                }
            }
        }
    }
    
    if ([[self directionToReverse] containsObject:direction]) {
        mergedLine = [[mergedLine arrayInReverseOrder] mutableCopy];
        offsets = [[offsets arrayInReverseOrder] mutableCopy];
    }
    
    //NSLog(@"Merged Line: %@", mergedLine);
    //NSLog(@"Offsets: %@", offsets);
    
    return @[mergedLine, offsets];
}

#pragma mark - Old Code

/*-(void)swipeInDirection:(SwipeDirection)direction;
{
    //NSLog(@"BOARD BEFORE");
    //NSLog(@"%@", self.board);
    
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
    
    [self newTile];
    
    //NSLog(@"BOARD AFTER");
    //NSLog(@"%@", self.board);
    //NSLog(@"\n Score is %d", self.score);
}*/

/*-(NSArray *)mergeLine:(NSArray *)line
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
}*/

@end
