//
//  CodableObject.h
//
//  Created by Alex Smith on 30/08/2015.
//  Copyright (c) 2015 Alex Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodableObject : NSObject <NSCoding>

@property (strong, nonatomic) NSArray *propertyNames;

@end