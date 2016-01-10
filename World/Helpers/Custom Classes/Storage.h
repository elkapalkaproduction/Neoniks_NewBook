//
//  Storage.h
//  World
//
//  Created by Andrei Vidrasco on 2/5/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Storage : NSObject

+ (void)saveData:(NSIndexSet *)set forKey:(NSString *)key;
+ (NSIndexSet *)loadDataForKey:(NSString *)key;
+ (void)removeDataForKey:(NSString *)key;

+ (void)saveInteger:(NSInteger)integer forKey:(NSString *)key;
+ (NSInteger)loadIntegerForKey:(NSString *)key;

+ (BOOL)existsValueForKey:(NSString *)key;

@end
