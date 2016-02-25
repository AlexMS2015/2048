//
//  ViewSwipeGestureHandler.m
//  2048
//
//  Created by Alex Smith on 23/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "ViewSwipeGestureHandler.h"

@implementation ViewSwipeGestureHandler

-(instancetype)initWithView:(UIView *)view
{
    if (self = [super init]) {
        [view addGestureRecognizer:[self swipeGestureWithDirection:UISwipeGestureRecognizerDirectionLeft]];
        [view addGestureRecognizer:[self swipeGestureWithDirection:UISwipeGestureRecognizerDirectionRight]];
        [view addGestureRecognizer:[self swipeGestureWithDirection:UISwipeGestureRecognizerDirectionUp]];
        [view addGestureRecognizer:[self swipeGestureWithDirection:UISwipeGestureRecognizerDirectionDown]];
    }
    
    return self;
}

-(UISwipeGestureRecognizer *)swipeGestureWithDirection:(UISwipeGestureRecognizerDirection)direction
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipe.direction = direction;
    
    return swipe;
}

-(void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;
{
    if ([gestureRecognizer isMemberOfClass:[UISwipeGestureRecognizer class]]) {
        UISwipeGestureRecognizer *swipeGesture = (UISwipeGestureRecognizer *)gestureRecognizer;
        [self.delegate view:swipeGesture.view swipedInDirection:swipeGesture.direction];
    }
}

@end
