//
//  ViewSwipeGestureHandler.h
//  2048
//
//  Created by Alex Smith on 23/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewSwipeGestureHandlerDelegate <NSObject>

-(void)view:(UIView *)view swipedInDirection:(UISwipeGestureRecognizerDirection)direction;

@end

@interface ViewSwipeGestureHandler : NSObject

@property (weak, nonatomic) id delegate;

-(instancetype)initWithView:(UIView *)view;

@end
