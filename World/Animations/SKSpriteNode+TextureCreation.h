//
//  SKSpriteNode+TextureCreation.h
//  cat
//
//  Created by Andrei Vidrasco on 8/29/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKSpriteNode (TextureCreation)

+ (SKSpriteNode *)nodeWithSize:(CGSize)size
                       texture:(SKTexture *)texture;

@end
