//
//  TFETile.h
//  2048
//
//  Created by Alex Smith on 22/11/2015.
//  Copyright © 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFETile : NSObject

@property (nonatomic) int value;
@property (nonatomic) int previousValue;
@property (nonatomic) int lastMoveRowOffset;
@property (nonatomic) int lastMoveColOffset;
@property (nonatomic) BOOL lastMoveMerged;
@property (nonatomic) BOOL lastMoveNewTile;

-(void)resetTileForNextMove;

@end
