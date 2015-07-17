//
//  SKAction+SKAction_Groups.m
//  World
//
//  Created by Andrei Vidrasco on 7/17/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "SKAction+Groups.h"

@implementation SKAction (Groups)

+ (SKAction *)actionWithSoundName:(NSString *)soundName
                           action:(SKAction *)action {
    return [SKAction group:@[action, [SKAction playSoundFileNamed:soundName waitForCompletion:NO]]];
}


+ (SKAction *)actionWithSoundName:(NSString *)soundName
                         textures:(NSArray *)textures {
    return [SKAction actionWithSoundName:soundName action:[SKAction animateWithTextures:textures
                                                                           timePerFrame:1.f / 15.f]];
}

@end
