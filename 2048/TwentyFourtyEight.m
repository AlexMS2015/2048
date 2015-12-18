//
//  TwentyFourtyEight.m
//  2048
//
//  Created by Alex Smith on 18/10/2015.
//  Copyright © 2015 Alex Smith. All rights reserved.
//

#import "TwentyFourtyEight.h"
#import "NSArray+Reverse.h"
#import "TFETile.h"

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
                TFETile *newTile = [[TFETile alloc] init];
                newTile.value = 0;
                [self.board setPosition:(Position){row, col} toObject:newTile];
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
    
    NSArray *tilesToMerge;
    NSArray *mergedTiles;
    
    if ([direction isEqualToString:@"LEFT"] || [direction isEqualToString:@"RIGHT"]) {
        for (int row = 0; row < self.board.size.rows; row++) {
            tilesToMerge = [self.board objectsInRow:row];
            
            mergedTiles = [self mergeLine:tilesToMerge inDirection:direction];
            [self.board replaceObjectsInRow:row withObjects:mergedTiles];
        }
    } else if ([direction isEqualToString:@"UP"] || [direction isEqualToString:@"DOWN"]) {
        for (int col = 0; col < self.board.size.columns; col++) {
            tilesToMerge = [self.board objectsInColumn:col];
            
            mergedTiles = [self mergeLine:tilesToMerge inDirection:direction];
            [self.board replaceObjectsInColumn:col withObjects:mergedTiles];
        }
    }
    
    //self.score += 1;
    [self newTile];
    
    //NSLog(@"BOARD AFTER");
    //NSLog(@"%@", self.board);
}

-(void)newTile
{
    // pick a random blank spot on the board
    int valueAtRandomPos = -100;
    Position randomPos;
    while (valueAtRandomPos != 0) {
        randomPos = [self.board randomPosition];
        TFETile *tileAtRandomPos = [self.board objectAtPosition:randomPos];
        valueAtRandomPos = tileAtRandomPos.value;
    }
    
    // pick a tile value (2 or 4 - weighted)
    int num = arc4random() % 10;
    int tileValue = 2;
    
    if (num > 8)
        tileValue = 4;

    TFETile *tile = [self.board objectAtPosition:randomPos];
    tile.value = tileValue;
    tile.lastMoveNewTile = YES;
    
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
    NSMutableArray *mergedLine = [line mutableCopy];

    NSArray *offsetForDir = [self directionOffsets][direction];
    int rowOffset = [[offsetForDir firstObject] intValue];
    int colOffset = [[offsetForDir lastObject] intValue];
    
    if ([[self directionToReverse] containsObject:direction])
        mergedLine = [[mergedLine arrayInReverseOrder] mutableCopy];
    
#warning - The tile should have a 'reset' method
    for (int tileIdx = 0; tileIdx < [mergedLine count]; tileIdx++) {
        TFETile *originalTile = mergedLine[tileIdx];
        originalTile.previousValue = originalTile.value;
        originalTile.lastMoveRowOffset = 0;
        originalTile.lastMoveColOffset = 0;
        originalTile.lastMoveMerged = NO;
        originalTile.lastMoveNewTile = NO;
    }
    
    //NSLog(@"Unmerged Line: %@", line);
    
    for (int tileIdx = 1; tileIdx < [mergedLine count]; tileIdx++) {
        TFETile *originalTile = mergedLine[tileIdx];
        if (originalTile.value != 0) {

            for (int tileIdx2 = tileIdx - 1; tileIdx2 >= 0; tileIdx2--) {
                TFETile *originalTileCurrent = mergedLine[tileIdx2 + 1];
                TFETile *tileToSwap = mergedLine[tileIdx2];
                
                if (tileToSwap.value == 0) {
                    
                    tileToSwap.value = originalTileCurrent.value;
                    originalTileCurrent.value = 0;
                    
                    originalTile.lastMoveRowOffset += rowOffset;
                    originalTile.lastMoveColOffset += colOffset;
                    
                } else if (originalTileCurrent.value == tileToSwap.value) {

                    if (tileToSwap.lastMoveMerged == NO) {
                        
                        tileToSwap.value += originalTileCurrent.value;
                        originalTileCurrent.value = 0;
                        
                        originalTile.lastMoveRowOffset += rowOffset;
                        originalTile.lastMoveColOffset += colOffset;
                        tileToSwap.lastMoveMerged = YES;
                        
                        break; // prevents multiple merges (e.g. [4, 2, 2] becoming [8, 0, 0] instead of [4, 4, 0]
                    }
                }
            }
        }
    }
    
    if ([[self directionToReverse] containsObject:direction])
        mergedLine = [[mergedLine arrayInReverseOrder] mutableCopy];
    
    return [NSArray arrayWithArray:mergedLine];
}

@end
