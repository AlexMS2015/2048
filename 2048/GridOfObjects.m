//
//  GridOfObjects.m
//
//  Created by Alex Smith on 26/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "GridOfObjects.h"

@interface GridOfObjects ()

@property (strong, nonatomic) NSMutableArray *objectsPrivate;

@end

@implementation GridOfObjects

-(void)enumerateWithBlock:(void (^)(Position position, int index, id obj))block;
{
    for (int row = 0; row < self.size.rows; row++) {
        for (int col = 0; col < self.size.columns; col++) {
            Position position = (Position){row, col};
            int index = [self indexOfPosition:position];
            id obj = [self objectAtPosition:position];
            block(position, index, obj);
        }
    }
}

-(instancetype)initWithGridSize:(GridSize)size andOrientation:(Orientation)orientation andObjects:(NSArray *)objects
{
    if (self = [super initWithGridSize:size andOrientation:orientation]) {
        _objectsPrivate = [objects mutableCopy];
    }

    return self;
}

-(void)setPosition:(Position)position toObject:(id)object
{
    int indexOfPosition = [self indexOfPosition:position];
    self.objectsPrivate[indexOfPosition] = object;
}

-(id)objectAtPosition:(Position)position
{
    int indexOfPosition = [self indexOfPosition:position];
    return indexOfPosition < [self.objectsPrivate count] ?
                        self.objectsPrivate[indexOfPosition] : nil;
}

-(Position)positionOfObject:(id)object
{
    int indexOfOject = (int)[self.objectsPrivate indexOfObject:object];
    return [self positionOfIndex:indexOfOject];
}

-(void)swapObjectAtPosition:(Position)position1 withObjectAtPosition:(Position)position2
{
    [self.objectsPrivate exchangeObjectAtIndex:[self indexOfPosition:position1]
                             withObjectAtIndex:[self indexOfPosition:position2]];
}

-(NSArray *)objectsInRow:(int)row
{
    NSMutableArray *objectsInRow = [NSMutableArray array];
    for (int currCol = 0; currCol < self.size.columns; currCol++) {
        Position currPos = (Position){row, currCol};
        [objectsInRow addObject:[self objectAtPosition:currPos]];
    }
    
    return [NSArray arrayWithArray:objectsInRow];
}

-(NSArray *)objectsInColumn:(int)column
{
    NSMutableArray *objectsInCol = [NSMutableArray array];
    for (int currRow = 0; currRow < self.size.columns; currRow++) {
        Position currPos = (Position){currRow, column};
        [objectsInCol addObject:[self objectAtPosition:currPos]];
    }
    
    return [NSArray arrayWithArray:objectsInCol];
}

-(void)replaceObjectsInRow:(int)row withObjects:(NSArray *)objects
{
#warning - Could iterate using the 'position for index' method in a single loop?
    
    if ([objects count] == self.size.columns) { // check the right number of objects were passed in
        for (int col = 0; col < self.size.columns; col++) {
            Position objPos = (Position){row, col};
            [self setPosition:objPos toObject:objects[col]];
        }
    }
}

-(void)replaceObjectsInColumn:(int)col withObjects:(NSArray *)objects
{
    if ([objects count] == self.size.rows) { // check the right number of objects were passed in
        for (int row = 0; row < self.size.rows; row++) {
            Position objPos = (Position){row, col};
            [self setPosition:objPos toObject:objects[row]];
        }
    }

}

-(NSString *)description
{
    NSMutableString *descriptionString = [NSMutableString string];
    [descriptionString appendString:@"\n"];
    
    for (int row = 0; row < self.size.rows; row++) {
        for (int col = 0; col < self.size.columns; col++) {
            Position currPos = (Position){row, col};
            NSNumber *currNum = [self objectAtPosition:currPos];
            [descriptionString appendFormat:@"%@    ", currNum];
        }
        [descriptionString appendString:@"\n"];
    }
    
    return descriptionString;
}

#pragma mark - Properties

-(NSArray *)objects
{
    return [self.objectsPrivate copy];
}

-(void)setObjects:(NSArray *)objects
{
    self.objectsPrivate = [objects mutableCopy];
}

-(NSMutableArray *)objectsPrivate
{
    if (!_objectsPrivate)
    {
        _objectsPrivate = [NSMutableArray array];
        for (int i = 0; i <= [self indexOfPosition:(Position){self.size.rows - 1, self.size.columns - 1}]; i++) {
            self.objectsPrivate[i] = [NSNull null];
        }
    }
    
    return _objectsPrivate;
}

#pragma mark - Encoding/Decoding

-(NSArray *)propertyNames
{
    NSMutableArray *propNames = [[super propertyNames] mutableCopy];
    [propNames addObject:@"objects"];
    return [propNames copy];
}

@end
