//
//  GridOfObjects.h
//  CollectionViewTest
//
//  Created by Alex Smith on 22/02/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

/*
 
 [ [R0C0, R0C1, R0C2], [R1C0, R1C1, R1C2], [R2C0, R2C1, R2C2] ]
 
 */

#import <Foundation/Foundation.h>
#import "PositionStruct.h"

@interface GridOfObjects : NSObject

@property (strong, nonatomic) NSMutableArray <NSMutableArray *> *objects;
@property (nonatomic) NSInteger numRows;
@property (nonatomic) NSInteger numCols;

-(instancetype)initWithRows:(NSInteger)rows andColumns:(NSInteger)cols;

-(Position)positionOfObject:(id)object;
-(void)swapObjectAtPosition:(Position)position1 withObjectAtPosition:(Position)position2;
-(void)enumerateWithBlock:(void (^)(Position position, id obj))block;
-(Position)randomPositionAdjacentToPosition:(Position)position;

@end
