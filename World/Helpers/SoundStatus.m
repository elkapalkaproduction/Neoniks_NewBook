//
//  SoundStatus.m
//  World
//
//  Created by Andrei Vidrasco on 1/10/16.
//  Copyright © 2016 Andrei Vidrasco. All rights reserved.
//

#import "SoundStatus.h"
#import "Storage.h"

NSString *const SoundsKey = @"SoundsKey";

@implementation SoundStatus

+ (CGFloat)volume {
    if (self.isEnabled) {
        return 1.f;
    } else {
        return 0.f;
    }
}


+ (void)setEnabled:(BOOL)enabled {
    [Storage saveInteger:enabled forKey:SoundsKey];
}


+ (BOOL)isEnabled {
    if (![Storage existsValueForKey:SoundsKey]) {
        [self setEnabled:YES];
    }
    
    return [Storage loadIntegerForKey:SoundsKey];
}

@end
