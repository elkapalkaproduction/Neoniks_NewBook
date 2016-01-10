//
//  Storage.m
//  World
//
//  Created by Andrei Vidrasco on 2/5/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "Storage.h"

@implementation Storage

+ (void)saveData:(NSIndexSet *)set forKey:(NSString *)key {
    if (!set) return;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:set];
    [defaults setObject:data forKey:key];
}


+ (NSIndexSet *)loadDataForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:key];
    if (!data) return nil;
    NSIndexSet *set = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    return set;
}


+ (void)removeDataForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}


+ (void)saveInteger:(NSInteger)integer forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setInteger:integer forKey:key];
}


+ (NSInteger)loadIntegerForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}


+ (BOOL)existsValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end
