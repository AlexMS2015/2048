//
//  TFETile.m
//  2048
//
//  Created by Alex Smith on 22/11/2015.
//  Copyright © 2015 Alex Smith. All rights reserved.
//

#import "TFETile.h"

@implementation TFETile

-(instancetype)init
{
    if (self = [super init]) {
        self.lastMoveRowOffset = 0;
        self.lastMoveColOffset = 0;
        self.lastMoveMerged = NO;
        self.lastMoveNewTile = NO;
    }
    
    return self;
}

-(NSString *)description
{
    //return [NSString stringWithFormat:@"Val %d, Row %d, Col %d, Mrg %d", self.value, self.lastMoveRowOffset, self.lastMoveColOffset, self.lastMoveMerged];
    return [NSString stringWithFormat:@"Val %d", self.value];

}

@end
