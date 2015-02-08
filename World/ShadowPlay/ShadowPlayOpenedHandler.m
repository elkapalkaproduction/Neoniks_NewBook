//
//  ShadowPlayOpenedHandler.m
//  World
//
//  Created by Andrei Vidrasco on 2/3/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "ShadowPlayOpenedHandler.h"
#import "Storage.h"

NSString *const MagicSchoolKey = @"MagicSchoolKey";

@implementation ShadowPlayOpenedHandler

+ (instancetype)sharedHandler {
    static id sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });

    return sharedMyManager;
}


- (BOOL)isOpenedCharacter:(ShadowCharacter)character {
    NSIndexSet *set = [Storage loadDataForKey:MagicSchoolKey];

    return [set containsIndex:character];
}


- (NSIndexSet *)allOpenedCharacter {
    return [Storage loadDataForKey:MagicSchoolKey];
}


- (void)markAsOpenedCharacter:(ShadowCharacter)character {
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndexSet:[Storage loadDataForKey:MagicSchoolKey]];
    [set addIndex:character];
    [Storage saveData:set forKey:MagicSchoolKey];
}


- (void)resetOpenedCharacter {
    [Storage removeDataForKey:MagicSchoolKey];
}

@end
