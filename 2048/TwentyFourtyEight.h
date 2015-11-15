//
//  TwentyFourtyEight.h
//  2048
//
//  Created by Alex Smith on 18/10/2015.
//  Copyright © 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GridOfObjects.h"
@import UIKit;

typedef enum {
    UP, DOWN, LEFT, RIGHT
} SwipeDirection;

@interface TwentyFourtyEight : NSObject

@property (nonatomic, readonly) BOOL gameInPlay;
@property (nonatomic, readonly) int score;
@property (nonatomic, strong, readonly) GridOfObjects *board; // tile values are stored as NSNumber objects

-(instancetype)initWithGameOfSize:(GridSize)size;
-(void)swipeInDirection:(SwipeDirection)direction;

@end
