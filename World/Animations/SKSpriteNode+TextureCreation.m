//
//  SKSpriteNode+TextureCreation.m
//  cat
//
//  Created by Andrei Vidrasco on 8/29/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import "SKSpriteNode+TextureCreation.h"

@implementation SKSpriteNode (TextureCreation)

+ (SKSpriteNode *)nodeWithSize:(CGSize)size
                       texture:(SKTexture *)texture {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:texture];
    background.size = size;
    background.position = CGPointMake(size.width / 2, size.height / 2);
    
    return background;
}

@end
