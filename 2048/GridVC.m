//
//  GridVC.m
//  Sliding Puzzle
//
//  Created by Alex Smith on 22/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "GridVC.h"

@interface GridVC ()

@property (nonatomic, copy) void (^cellConfigureBlock)(UICollectionViewCell *, Position, int);
@property (nonatomic, copy) void (^cellTapHandler)(UICollectionViewCell *, Position, int);
@property (nonatomic) float cellWidth;
@property (nonatomic) float cellHeight;

@end

@implementation GridVC

#define CELL_IDENTIFIER @"CollectionCell"

#pragma mark - Properties

-(float)cellWidth
{
    if (_cellWidth == 0) {
        if (self.collectionView.scrollEnabled) {
            UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
            self.cellWidth = layout.scrollDirection == UICollectionViewScrollDirectionVertical ?
            self.collectionView.bounds.size.width / self.grid.size.columns :
            self.collectionView.bounds.size.height / self.grid.size.rows;
            self.cellHeight = self.cellWidth;
        } else {
            self.cellWidth = self.collectionView.bounds.size.width / self.grid.size.columns;
            self.cellHeight = self.collectionView.bounds.size.height / self.grid.size.rows;
        }
        
        //NSLog(@"cell w = %f", _cellWidth);
        //NSLog(@"height h = %f", self.cellHeight);
    }
    
    return _cellWidth;
}

-(void)setCollectionView:(UICollectionView *)collectionView
{
    _collectionView = collectionView;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
}

#pragma mark - Initialiser

-(instancetype)initWithgridSize:(GridSize)size collectionView:(UICollectionView *)collectionView andCellConfigureBlock:(void (^)(UICollectionViewCell *, Position, int))cellConfigureBlock andCellTapHandler:(void (^)(UICollectionViewCell *, Position, int))cellTapHandler
{
    if (self = [super init]) {
        self.collectionView = collectionView;
        self.cellConfigureBlock = cellConfigureBlock;
        self.cellTapHandler = cellTapHandler;
        
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        Orientation orientation = layout.scrollDirection == UICollectionViewScrollDirectionVertical ? VERTICAL : HORIZONTAL;
        
        self.grid = [[Grid alloc] initWithGridSize:size andOrientation:orientation];
        
        // add a swipe gesture recogniser as a test
        [self.collectionView addGestureRecognizer:[self swipeGestureWithDirection:UISwipeGestureRecognizerDirectionLeft]];
        [self.collectionView addGestureRecognizer:[self swipeGestureWithDirection:UISwipeGestureRecognizerDirectionRight]];
        [self.collectionView addGestureRecognizer:[self swipeGestureWithDirection:UISwipeGestureRecognizerDirectionUp]];
        [self.collectionView addGestureRecognizer:[self swipeGestureWithDirection:UISwipeGestureRecognizerDirectionDown]];
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
        [self.delegate swipedInDirection:swipeGesture.direction];
    }
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int objIndex = (int)indexPath.item;
    Position currentPos = [self.grid positionOfIndex:objIndex];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if (self.cellTapHandler)
        self.cellTapHandler(cell, currentPos, objIndex);
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.cellWidth, self.cellHeight);
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.grid.size.rows * self.grid.size.columns;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    int objIndex = (int)indexPath.item;
    Position currentPos = [self.grid positionOfIndex:objIndex];
    self.cellConfigureBlock(cell, currentPos, objIndex);
    return cell;
}

@end