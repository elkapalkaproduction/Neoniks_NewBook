//
//  SKAction+SKAction_Groups.h
//  World
//
//  Created by Andrei Vidrasco on 7/17/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKAction (Groups)

+ (SKAction *)actionWithSoundName:(NSString *)soundName action:(SKAction *)action;
+ (SKAction *)actionWithSoundName:(NSString *)soundName textures:(NSArray *)textures;

@end
