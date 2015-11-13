//
//  CodableObject.m
//
//  Created by Alex Smith on 30/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import "CodableObject.h"

@implementation CodableObject

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        for (NSString *key in self.propertyNames) {
            id object = [aDecoder decodeObjectForKey:key];
            [self setValue:object forKey:key];
        }
    }

    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSString *key in self.propertyNames) {
        id object = [self valueForKey:key];
        [aCoder encodeObject:object forKey:key];
    }
}

@end
