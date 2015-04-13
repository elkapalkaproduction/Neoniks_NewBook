//
//  ShadowPlayOpenedHandler.h
//  World
//
//  Created by Andrei Vidrasco on 2/3/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CharacterShadowViewController.h"

@interface ShadowPlayOpenedHandler : NSObject

+ (instancetype)sharedHandler;
- (BOOL)isOpenedCharacter:(ShadowCharacter)character;
- (void)markAsOpenedCharacter:(ShadowCharacter)character;
- (NSIndexSet *)allOpenedCharacter;
- (void)resetOpenedCharacter;

@end
