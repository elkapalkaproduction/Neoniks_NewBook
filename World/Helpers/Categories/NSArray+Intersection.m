//
//  NSArray+Intersection.m
//  World
//
//  Created by Andrei Vidrasco on 1/10/16.
//  Copyright © 2016 Andrei Vidrasco. All rights reserved.
//

#import "NSArray+Intersection.h"

@implementation NSArray (Intersection)

- (NSArray *)intersectWithArray:(NSArray *)array {
    NSMutableSet *set1 = [NSMutableSet setWithArray:self];
    NSSet *set2 = [NSSet setWithArray:array];
    [set1 intersectSet:set2];
    
    return [set1 allObjects];
}

@end
