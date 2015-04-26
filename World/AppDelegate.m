//
//  AppDelegate.m
//  World
//
//  Created by Andrei Vidrasco on 1/25/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "AppDelegate.h"
#import "ShadowPlayOpenedHandler.h"
#import "InventaryContentHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[ShadowPlayOpenedHandler sharedHandler] markAsOpenedCharacter:ShadowCharacterWanda];
    [[ShadowPlayOpenedHandler sharedHandler] markAsOpenedCharacter:ShadowCharacterJustacreep];
    [[ShadowPlayOpenedHandler sharedHandler] markAsOpenedCharacter:3];
    [[ShadowPlayOpenedHandler sharedHandler] markAsOpenedCharacter:5];
    [[ShadowPlayOpenedHandler sharedHandler] markAsOpenedCharacter:6];
    [[ShadowPlayOpenedHandler sharedHandler] markAsOpenedCharacter:7];
    [[ShadowPlayOpenedHandler sharedHandler] markAsOpenedCharacter:8];
    [[ShadowPlayOpenedHandler sharedHandler] markAsOpenedCharacter:1];
    
    return YES;
}

@end
