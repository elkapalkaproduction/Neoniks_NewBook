//
//  InventaryContentHandler.m
//  World
//
//  Created by Andrei Vidrasco on 4/26/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "InventaryContentHandler.h"
#import "Storage.h"

@interface InventaryContentHandler ()

@property (strong, nonatomic) NSArray *items;

@end

@implementation InventaryContentHandler

+ (instancetype)sharedHandler {
    static id sharedHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHandler = [[self alloc] init];
    });
    
    return sharedHandler;
}


- (NSInteger)numberOfItems {
    return self.items.count;
}


- (InventaryItemOption *)inventaryOptionForType:(InventaryBarIconType)type {
    if (type < self.items.count) {
        return self.items[type];
    } else {
        return nil;
    }
}


- (InventaryIconShowing)formatItemForType:(InventaryBarIconType)type {
    NSString *key = [self keyFromType:type];
    
    return [Storage loadIntegerForKey:key];
}


- (NSString *)keyFromType:(InventaryBarIconType)type {
    return [NSString stringWithFormat:@"inventary%ld", (long)type];
}


- (void)markItemWithType:(InventaryBarIconType)type withFormat:(InventaryIconShowing)format {
    self.items = nil;
    [Storage saveInteger:format forKey:[self keyFromType:type]];
}


- (NSArray *)items {
    if (_items) return _items;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (InventaryBarIconType type = InventaryBarIconTypeIslandMap; type <= InventaryBarIconTypeSnail; type++) {
        InventaryIconShowing format = [self formatItemForType:type];
        if (format == InventaryIconShowingHidden) continue;
        InventaryItemOption *option = [[InventaryItemOption alloc] init];
        option.type = type;
        option.format = format;
        [array addObject:option];
    }
    
    _items = [NSArray arrayWithArray:array];
    
    return _items;
}


- (InventaryIconShowing)formatForItemType:(InventaryBarIconType)type {
    return [Storage loadIntegerForKey:[self keyFromType:type]];
}


- (NSInteger)numberOfBallOfMagic {
    return [self formatItemForType:InventaryBarIconTypeMagicBallCat] + [self formatItemForType:InventaryBarIconTypeMagicBallSheep] + [self formatItemForType:InventaryBarIconTypeMagicBallNinja];
}


- (void)deleteAll {
    for (InventaryBarIconType type = InventaryBarIconTypeUnknown; type <= InventaryBarIconTypeMagicBallNinja; type++) {
        [self markItemWithType:type withFormat:InventaryIconShowingEmpty];
    }
}

@end
