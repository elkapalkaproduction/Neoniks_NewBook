//
//  SKAction+SKAction_Groups.h
//  World
//
//  Created by Andrei Vidrasco on 7/17/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AVAudioPlayer+Creation.h"

@interface SKAction (Groups)

+ (SKAction *)actionWithSoundName:(NSString *)soundName action:(SKAction *)action;
+ (SKAction *)actionWithSoundName:(NSString *)soundName textures:(NSArray *)textures;

@property (nonatomic, strong) AVAudioPlayer *player;
- (void)runActionOnNode:(SKNode *)node;
- (void)runActionOnNode:(SKNode *)node
             completion:(void (^)())completionBlock;
- (void)stopActionFromNode:(SKNode *)node;

@end
