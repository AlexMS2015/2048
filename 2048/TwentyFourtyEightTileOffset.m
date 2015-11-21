//
//  TwentyFourtyEightTileOffset.m
//  2048
//
//  Created by Alex Smith on 17/11/2015.
//  Copyright © 2015 Alex Smith. All rights reserved.
//

#import "TwentyFourtyEightTileOffset.h"

@implementation TwentyFourtyEightTileOffset

-(instancetype)init
{
    if (self = [super init]) {
        self.rowOffset = 0;
        self.colOffset = 0;
        self.visible = YES;
        self.merged = NO;
    }
    
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Row = %d, Col = %d, Vis = %d, Merg = %d", self.rowOffset, self.colOffset, self.visible, self.merged];
}

@end
