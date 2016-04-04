//
//  UICollectionViewFlowLayout+GridLayout.m
//  2048
//
//  Created by Alex Smith on 24/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "UICollectionViewFlowLayout+GridLayout.h"

@implementation UICollectionViewFlowLayout (GridLayout)

-(void)layoutAsGrid
{
    self.minimumInteritemSpacing = 0.0;
    self.minimumLineSpacing = 0.0;
    
    float width = self.collectionView.bounds.size.width;
    float height = self.collectionView.bounds.size.height;
    
    NSUInteger numSections = self.collectionView.numberOfSections;
    NSUInteger numItems = [self.collectionView numberOfItemsInSection:0];
    
    if (!self.collectionView.scrollEnabled) {
        self.itemSize = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ?
        CGSizeMake(width / numSections, height / numItems) : CGSizeMake(width / numItems, height / numSections);
    } else {
        if (self.collectionView.numberOfSections == 1.0) {
            self.itemSize = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ?
            CGSizeMake(height, height) : CGSizeMake(width, width);
        } else {
            self.itemSize = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ?
            CGSizeMake(height / numItems, height / numItems) : CGSizeMake(width / numItems, width / numItems);
        }
    }
}

@end
