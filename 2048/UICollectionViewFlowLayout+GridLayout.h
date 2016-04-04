//
//  UICollectionViewFlowLayout+GridLayout.h
//  2048
//
//  Created by Alex Smith on 24/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

/*
 
 If scroll direction is vertical then cells will be layed out like this:
 
            Item0       Item1       Item2
 Sec0       (S0,I0)     (S0, I1)
 Sec1       (S1,I0)
 Sec2
 
 If scroll direction is horizontal then cells will be layed out like this:
 
            Sec0        Sec1       Sec2
 Item0      (S0,I0)     (S1, I0)
 Item1      (S0,I1)
 Item2
 
 If scrolling is enabled then the cells wil be sized as squares. If it is disabled, the cells will
 exactly fit inside the bounds of the collection view (like a Chess boards).
 
 If the number of sections is 1 and the grid is scrolling then the above layouts will be reversed (e.g.
 for horizontal it will flow like this: I1 --> I2 --> I3).
 
 Spacing between items and spacing between sections is 0.
 
 */

#import <UIKit/UIKit.h>

@interface UICollectionViewFlowLayout (GridLayout)

-(void)layoutAsGrid;

@end
