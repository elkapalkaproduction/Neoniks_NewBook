//
//  NNKLanternHouseNode.m
//  TexturePacker-SpriteKit
//
//  Created by Andrei Vidrasco on 5/30/15.
//  Copyright (c) 2015 Neoniks. All rights reserved.
//

#import "NNKLanternHouseNode.h"
#import "lantern_house.h"

@interface NNKLanternHouseNode ()

@property (strong, nonatomic) SKTextureAtlas *atlass;
@property (strong, nonatomic) SKAction *sequence;
@property (strong, nonatomic) SKSpriteNode *spriteNode;

@end

@implementation NNKLanternHouseNode

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        [self addChild:[self backgroundNodeWithSize:size]];
        _atlass = [SKTextureAtlas atlasNamed:LANTERN_HOUSE_ATLAS_NAME];
        _spriteNode = [self mainNodeWithSize:size];
        [self addChild:_spriteNode];
    }
    
    return self;
}


- (SKAction *)sequence {
    if (!_sequence) {
        _sequence = [SKAction repeatActionForever:[SKAction animateWithTextures:LANTERN_HOUSE_ANIM_LANTERN_HOUSE
                                                                   timePerFrame:1.f / 15.f]];
    }
    
    return _sequence;
}


- (SKSpriteNode *)mainNodeWithSize:(CGSize)size {
    SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:LANTERN_HOUSE_TEX_LANTERN_HOUSE_01];
    spriteNode.size = size;
    spriteNode.position = CGPointMake(size.width / 2, size.height / 2);
    
    return spriteNode;
}


- (void)runAction {
    [self.spriteNode runAction:self.sequence];
}


- (SKSpriteNode *)backgroundNodeWithSize:(CGSize)size {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:LANTERN_HOUSE_TEX_LANTERN_HOUSE_FULL];
    background.size = size;
    background.position = CGPointMake(size.width / 2, size.height / 2);
    
    return background;
}

@end
