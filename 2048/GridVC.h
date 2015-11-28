//
//  GridVC.h
//  Sliding Puzzle
//
//  Created by Alex Smith on 22/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Grid.h"

@protocol GridVCDelegate <NSObject>

@optional
// called when the user swipes anywhere in the collection view in a particular direction. implemented as a delegate as this feature is specific to the entire collection view unlike tapping a cell which is specific to that cell
-(void)swipedInDirection:(UISwipeGestureRecognizerDirection)direction;

@end

@interface GridVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) id<GridVCDelegate> delegate;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) Grid *grid;

// the 'Orientation' of the grid will be determined by the passed in collectionView's scrolling direction.
-(instancetype)initWithgridSize:(GridSize)size
                 collectionView:(UICollectionView *)collectionView
          andCellConfigureBlock:(void (^)(UICollectionViewCell *cell, Position position, int index))cellConfigureBlock
              andCellTapHandler:(void (^)(UICollectionViewCell *cell, Position position, int index))cellTapHandler;

-(NSIndexPath *)indexPathForPosition:(Position)position;
-(UICollectionViewCell *)cellAtPosition:(Position)position;

@end
