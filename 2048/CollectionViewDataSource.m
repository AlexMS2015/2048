//
//  CollectionViewDataSource.m
//  CollectionViewTest
//
//  Created by Alex Smith on 22/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "CollectionViewDataSource.h"

@interface CollectionViewDataSource ()

@property (strong, nonatomic) NSArray<NSArray *> *data;
@property (strong, nonatomic) NSString *cellIdentifier;
@property (copy, nonatomic) CellConfigureBlock configureBlock;

@end

@implementation CollectionViewDataSource

-(instancetype)initWithData:(NSArray<NSArray *> *)data cellIdentifier:(NSString *)cellIdentifier cellConfigureBlock:(CellConfigureBlock)configureBlock
{
    if (self = [super init]) {
        self.data = data;
        self.cellIdentifier = cellIdentifier;
        self.configureBlock = configureBlock;
    }
    
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.data count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.data[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    if (self.configureBlock) {
        self.configureBlock(indexPath, self.data[indexPath.section][indexPath.item], cell);
    }
    
    return cell;
}

@end
