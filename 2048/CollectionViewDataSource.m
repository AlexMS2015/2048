//
//  CollectionViewDataSource.m
//  CollectionViewTest
//
//  Created by Alex Smith on 22/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import "CollectionViewDataSource.h"

@interface CollectionViewDataSource ()

@property (nonatomic) NSInteger sections;
@property (nonatomic) NSInteger items;
@property (strong, nonatomic) NSString *cellIdentifier;
@property (copy, nonatomic) CellConfigureBlock configureBlock;

@end

@implementation CollectionViewDataSource

-(instancetype)initWithSections:(NSInteger)section itemsPerSection:(NSInteger)items cellIdentifier:(NSString *)cellIdentifier cellConfigureBlock:(CellConfigureBlock)configureBlock
{
    if (self = [super init]) {
        self.sections = section;
        self.items = items;
        self.cellIdentifier = cellIdentifier;
        self.configureBlock = configureBlock;
    }
    
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sections;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    if (self.configureBlock) self.configureBlock(indexPath.section, indexPath.item, cell);
    
    return cell;
}

@end
