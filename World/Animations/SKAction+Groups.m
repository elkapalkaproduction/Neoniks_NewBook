//
//  SKAction+SKAction_Groups.m
//  World
//
//  Created by Andrei Vidrasco on 7/17/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "SKAction+Groups.h"
#import <objc/runtime.h>

static char kAssociatedPlayerObjectKey;

@implementation SKAction (Groups)

+ (SKAction *)actionWithSoundName:(NSString *)soundName
                           action:(SKAction *)action {
    action.player = [AVAudioPlayer audioPlayerWithSoundName:soundName];
    
    return action;
}


+ (SKAction *)actionWithSoundName:(NSString *)soundName
                         textures:(NSArray *)textures {
    return [SKAction actionWithSoundName:soundName action:[SKAction animateWithTextures:textures
                                                                           timePerFrame:1.f / 15.f]];
}


- (AVAudioPlayer *)player {
    return objc_getAssociatedObject(self, &kAssociatedPlayerObjectKey);
}


- (void)setPlayer:(AVAudioPlayer *)player {
    objc_setAssociatedObject(self, &kAssociatedPlayerObjectKey, player, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)runActionOnNode:(SKNode *)node {
    [self runActionOnNode:node completion:nil];
}


- (void)runActionOnNode:(SKNode *)node
             completion:(void (^)())completionBlock {
    SKAction *completion = [SKAction runBlock:^{
        if (completionBlock) completionBlock();
    }];
    SKAction *sequence = [SKAction sequence:@[self, completion]];
    if (self.player) {
        self.player.volume = SoundStatus.volume;
        [self.player play];
    }

    [node runAction:sequence withKey:self.key];
}


- (NSString *)key {
    return [NSString stringWithFormat:@"%ld", self.hash];
}


- (void)stopActionFromNode:(SKNode *)node {
    [node removeActionForKey:self.key];
    if (self.player) {
        [self.player stop];
    }
}

@end
