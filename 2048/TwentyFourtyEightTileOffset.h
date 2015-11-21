//
//  TwentyFourtyEightTileOffset.h
//  2048
//
//  Created by Alex Smith on 17/11/2015.
//  Copyright © 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwentyFourtyEightTileOffset : NSObject

@property (nonatomic) int rowOffset;
@property (nonatomic) int colOffset;
@property (nonatomic) BOOL visible;
@property (nonatomic) BOOL merged;

@end
