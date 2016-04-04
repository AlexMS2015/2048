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

-(instancetype)initWithRows:(NSInteger)rows andColumns:(NSInteger)cols
{
    if (self = [super init]) {

        self.board = [[GridOfObjects alloc] initWithRows:rows andColumns:cols];

        // set all tiles to 0 initially
        for (int row = 0; row < rows; row++) {
            for (int col = 0; col < cols; col++) {
                TFETile *newTile = [[TFETile alloc] init];
                newTile.value = 0;
                self.board.objects[row][col] = newTile;
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
    NSMutableArray *tilesToMerge;
    NSArray *mergedTiles;
    
    if ([direction isEqualToString:@"LEFT"] || [direction isEqualToString:@"RIGHT"]) {
        for (int row = 0; row < self.board.numRows; row++) {
            tilesToMerge = self.board.objects[row];
            
            mergedTiles = [self mergeLine:tilesToMerge inDirection:direction];
            self.board.objects[row] = [mergedTiles mutableCopy];
        }
    } else if ([direction isEqualToString:@"UP"] || [direction isEqualToString:@"DOWN"]) {
        
        // average code but not worth optimising given the arrays are small:
        
        for (int col = 0; col < self.board.numCols; col++) {
            tilesToMerge = [NSMutableArray array];
            for (int row = 0; row < self.board.numRows; row++) {
                [tilesToMerge addObject:self.board.objects[row][col]];
                NSLog(@"%@", tilesToMerge);
            }
            mergedTiles = [self mergeLine:tilesToMerge inDirection:direction];
            
            for (int row = 0; row < self.board.numRows; row++) {
                self.board.objects[row][col] = mergedTiles[row];
            }
        }
    }

    [self newTile];
}

-(void)newTile
{
    // pick a random blank spot on the board
    int valueAtRandomPos = -100;
    Position randomPos;
    while (valueAtRandomPos != 0) {
        
        randomPos = (Position){ arc4random() % self.board.numRows,
                                arc4random() % self.board.numCols};
        
        TFETile *tileAtRandomPos = self.board.objects[randomPos.row][randomPos.column];
        valueAtRandomPos = tileAtRandomPos.value;
    }
    
    // pick a tile value (2 or 4 - weighted)
    int num = arc4random() % 10;
    int tileValue = 2;
    
    if (num > 8)
        tileValue = 4;
    
    TFETile *tile = self.board.objects[randomPos.row][randomPos.column];
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

-(NSArray *)directionsToReverse
{
    return @[@"DOWN", @"RIGHT"];
}

-(NSArray *)mergeLine:(NSArray *)line inDirection:(NSString *)direction
{
    for (TFETile *tile in line)
        [tile resetTileForNextMove];
    
    NSMutableArray *mergedLine = [line mutableCopy];
    
    NSArray *offsetForDir = [self directionOffsets][direction];
    int rowOffset = [[offsetForDir firstObject] intValue];
    int colOffset = [[offsetForDir lastObject] intValue];
    
    if ([[self directionsToReverse] containsObject:direction])
        mergedLine = [[mergedLine arrayInReverseOrder] mutableCopy];
    
    for (int tileIdx = 1; tileIdx < [mergedLine count]; tileIdx++) {
        TFETile *originalTile = mergedLine[tileIdx];
        
        if (originalTile.value != 0) {
            
            for (int tileIdx2 = tileIdx - 1; tileIdx2 >= 0; tileIdx2--) {
                TFETile *originalTileCurrent = mergedLine[tileIdx2 + 1];
                TFETile *tileToSwapOrMerge = mergedLine[tileIdx2];
                
                if (tileToSwapOrMerge.value == 0) {
                    
                    tileToSwapOrMerge.value = originalTileCurrent.value;
                    originalTileCurrent.value = 0;
                    
                    originalTile.lastMoveRowOffset += rowOffset;
                    originalTile.lastMoveColOffset += colOffset;
                    
                } else if (originalTileCurrent.value == tileToSwapOrMerge.value) {
                    
                    if (tileToSwapOrMerge.lastMoveMerged == NO) {
                        
                        tileToSwapOrMerge.value += originalTileCurrent.value;
                        originalTileCurrent.value = 0;
                        
                        originalTile.lastMoveRowOffset += rowOffset;
                        originalTile.lastMoveColOffset += colOffset;
                        tileToSwapOrMerge.lastMoveMerged = YES;
                        
                        break; // prevents multiple merges (e.g. [4, 2, 2] becoming [8, 0, 0] instead of [4, 4, 0]
                    }
                } else {
                    break; // if the tile hasn't been merged or moved 1 position over then no need to keep checking
                }
            }
        }
    }
    
    if ([[self directionsToReverse] containsObject:direction])
        mergedLine = [[mergedLine arrayInReverseOrder] mutableCopy];
    
    return [NSArray arrayWithArray:mergedLine];
}

@end
