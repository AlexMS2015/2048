//
//  TileView.m
//  2048
//
//  Created by Alex Smith on 22/11/2015.
//  Copyright © 2015 Alex Smith. All rights reserved.
//

#import "TileView.h"

@implementation TileView

-(NSDictionary *)tileColours
{
    return @{@0 : [UIColor whiteColor],
             @2 : [UIColor grayColor],
             @4 : [UIColor greenColor],
             @8 : [UIColor redColor],
             @16 : [UIColor blueColor],
             @32 : [UIColor orangeColor]};
}

-(void)setValue:(int)value
{
    _value = value;
    //[self setNeedsDisplay];
    
    self.backgroundColor = [self tileColours][[NSNumber numberWithInt:self.value]];
    if ([self.subviews count] == 0) {
        //UIImageView *background = [[UIImageView alloc] initWithFrame:self.bounds];
        //background.image = [UIImage imageNamed:@"Tile"];
        //[self addSubview:background];
        
        UILabel *cellValueLabel = [[UILabel alloc] initWithFrame:self.bounds];
        cellValueLabel.textAlignment = NSTextAlignmentCenter;
        cellValueLabel.font = [UIFont systemFontOfSize:28];
        cellValueLabel.text = self.value == 0 ? @"" : [NSString stringWithFormat:@"%d", self.value];
        cellValueLabel.layer.borderColor = [UIColor blackColor].CGColor;
        cellValueLabel.layer.borderWidth = 1.0;
        [self addSubview:cellValueLabel];
    } else {
        UILabel *cellValueLabel = [self.subviews lastObject];
        cellValueLabel.text = self.value == 0 ? @"" : [NSString stringWithFormat:@"%d", self.value];
    }
}

/*-(void)layoutSubviews
{
    [super layoutSubviews];
    self.alpha = 1.0;
    self.backgroundColor = [self tileColours][[NSNumber numberWithInt:self.value]];
    if ([self.subviews count] == 0) {
        //UIImageView *background = [[UIImageView alloc] initWithFrame:self.bounds];
        //background.image = [UIImage imageNamed:@"Tile"];
        //[self addSubview:background];
        
        UILabel *cellValueLabel = [[UILabel alloc] initWithFrame:self.bounds];
        cellValueLabel.textAlignment = NSTextAlignmentCenter;
        cellValueLabel.font = [UIFont systemFontOfSize:28];
        cellValueLabel.text = self.value == 0 ? @"" : [NSString stringWithFormat:@"%d", self.value];
        cellValueLabel.layer.borderColor = [UIColor blackColor].CGColor;
        cellValueLabel.layer.borderWidth = 1.0;
        [self addSubview:cellValueLabel];
    } else {
        UILabel *cellValueLabel = [self.subviews lastObject];
        cellValueLabel.text = self.value == 0 ? @"" : [NSString stringWithFormat:@"%d", self.value];
    }
}*/

@end
