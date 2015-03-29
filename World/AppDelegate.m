//
//  AppDelegate.m
//  World
//
//  Created by Andrei Vidrasco on 1/25/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "AppDelegate.h"
#import "ShadowPlayOpenedHandler.h"
@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[ShadowPlayOpenedHandler sharedHandler] markAsOpenedCharacter:ShadowCharacterWanda];
    [[ShadowPlayOpenedHandler sharedHandler] markAsOpenedCharacter:ShadowCharacterJustacreep];
    
    return YES;
}
@end
