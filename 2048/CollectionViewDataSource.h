//
//  CollectionViewDataSource.h
//  CollectionViewTest
//
//  Created by Alex Smith on 22/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CellConfigureBlock)(NSInteger section, NSInteger item, UICollectionViewCell *cell);

@interface CollectionViewDataSource : NSObject <UICollectionViewDataSource>

-(instancetype)initWithSections:(NSInteger)section
                itemsPerSection:(NSInteger)items
                 cellIdentifier:(NSString *)cellIdentifier
             cellConfigureBlock:(CellConfigureBlock)configureBlock;

@end
