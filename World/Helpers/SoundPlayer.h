//
//  SoundPlayer.h
//  halloween
//
//  Created by Andrei Vidrasco on 9/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundPlayer : NSObject

+ (instancetype)sharedPlayer;
- (void)playClick;
- (void)playWrongAnswer;
- (void)playCorrectAnswer;

@end
