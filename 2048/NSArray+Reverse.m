
//
//  NSArray+Reverse.m
//  2048
//
//  Created by Alex Smith on 14/11/2015.
//  Copyright © 2015 Alex Smith. All rights reserved.
//

#import "NSArray+Reverse.h"

@implementation NSArray (Reverse)

-(NSArray *)arrayInReverseOrder
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSNumber *tile in [self reverseObjectEnumerator]) {
        [tempArray addObject:tile];
    }
    
    return [NSArray arrayWithArray:tempArray];
}

@end
