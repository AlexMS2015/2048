//
//  CollectionViewDataSource.h
//  CollectionViewTest
//
//  Created by Alex Smith on 22/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CellConfigureBlock)(NSIndexPath *path, id object, UICollectionViewCell *cell);

@interface CollectionViewDataSource : NSObject <UICollectionViewDataSource>

-(instancetype)initWithData:(NSArray <NSArray *>*)data
             cellIdentifier:(NSString *)cellIdentifier
         cellConfigureBlock:(CellConfigureBlock)configureBlock;

@end
