//
//  InventaryContentHandler.h
//  World
//
//  Created by Andrei Vidrasco on 4/26/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InventaryItemOption.h"

@interface InventaryContentHandler : NSObject

+ (instancetype)sharedHandler;

- (NSInteger)numberOfItems;
- (InventaryItemOption *)inventaryOptionForType:(InventaryBarIconType)type;

- (void)markItemWithType:(InventaryBarIconType)type withFormat:(InventaryIconShowing)format;

- (InventaryIconShowing)formatForItemType:(InventaryBarIconType)type;

- (NSInteger)numberOfBallOfMagic;

- (void)deleteAll;

@end
