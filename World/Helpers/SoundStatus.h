//
//  SoundStatus.h
//  World
//
//  Created by Andrei Vidrasco on 1/10/16.
//  Copyright © 2016 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundStatus : NSObject

+ (CGFloat)volume;
+ (BOOL)isEnabled;
+ (void)setEnabled:(BOOL)enabled;

@end
