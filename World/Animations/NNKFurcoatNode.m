//
//  NNKFurcoatNode.m
//  TexturePacker-SpriteKit
//
//  Created by Andrei Vidrasco on 5/30/15.
//  Copyright (c) 2015 Neoniks. All rights reserved.
//

#import "NNKFurcoatNode.h"
#import "furcoat_anim.h"

#define AtlasName FURCOAT_ANIM_ATLAS_NAME
#define AnimName FURCOAT_ANIM_ANIM_FURCOAT_ANIM
#define FirstFrameName FURCOAT_ANIM_TEX_FURCOAT_ANIM_01

@interface NNKFurcoatNode ()

@property (strong, nonatomic) SKTextureAtlas *atlass;
@property (strong, nonatomic) SKAction *sequence;
@property (strong, nonatomic) SKSpriteNode *spriteNode;

@end

@implementation NNKFurcoatNode

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        _atlass = [SKTextureAtlas atlasNamed:AtlasName];
        _spriteNode = [self mainNodeWithSize:size];
        [self addChild:_spriteNode];
    }
    
    return self;
}


- (SKAction *)sequence {
    if (!_sequence) {
        _sequence = [SKAction repeatActionForever:[SKAction animateWithTextures:AnimName
                                                                   timePerFrame:1.f / 15.f]];
    }
    
    return _sequence;
}


- (SKSpriteNode *)mainNodeWithSize:(CGSize)size {
    SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:FirstFrameName];
    spriteNode.size = size;
    spriteNode.position = CGPointMake(size.width / 2, size.height / 2);
    
    return spriteNode;
}


- (void)runAction {
    [self.spriteNode runAction:self.sequence];
}

@end
