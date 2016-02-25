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

@interface TwentyFourtyEight : NSObject

@property (nonatomic, readonly) BOOL gameInPlay;
@property (nonatomic, readonly) int score;
@property (nonatomic, strong, readonly) GridOfObjects *board; // tiles stores as 'TFETile' objects

-(instancetype)initWithRows:(NSInteger)rows andColumns:(NSInteger)cols;
-(void)swipeInDirection:(NSString *)direction;

@end