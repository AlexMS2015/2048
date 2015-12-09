//
//  UILabel+GameTile.m
//  2048
//
//  Created by Alex Smith on 6/12/2015.
//  Copyright © 2015 Alex Smith. All rights reserved.
//

#import "UILabel+GameTile.h"

@implementation UILabel (GameTile)

+(UILabel *)newGameTileWithFrame:(CGRect)frame
{
    UILabel *tileLabel = [[UILabel alloc] initWithFrame:frame];
    
    tileLabel.textAlignment = NSTextAlignmentCenter;
    tileLabel.font = [UIFont systemFontOfSize:28];
    tileLabel.layer.borderColor = [UIColor blackColor].CGColor;
    tileLabel.layer.borderWidth = 0.3;
    
    return tileLabel;
}

@end
