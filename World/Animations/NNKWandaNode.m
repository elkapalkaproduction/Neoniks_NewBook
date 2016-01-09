//
//  NNKWandaNode.m
//  TexturePacker-SpriteKit
//
//  Created by Andrei Vidrasco on 5/30/15.
//  Copyright (c) 2015 Neoniks. All rights reserved.
//

#import "NNKWandaNode.h"
#import "wanda_anim.h"

@interface NNKWandaNode ()

@property (strong, nonatomic) SKTextureAtlas *atlass;
@property (strong, nonatomic) SKAction *sequence;
@property (strong, nonatomic) SKSpriteNode *spriteNode;

@end

@implementation NNKWandaNode

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        [self addChild:[self backgroundNodeWithSize:size]];
        _atlass = [SKTextureAtlas atlasNamed:WANDA_ANIM_ATLAS_NAME];
        _spriteNode = [self mainNodeWithSize:size];
        [self addChild:_spriteNode];
    }
    
    return self;
}


- (void)removeFromParent {
    [super removeFromParent];
    [self.spriteNode removeAllActions];
}


- (SKAction *)sequence {
    if (!_sequence) {
        _sequence = [SKAction actionWithSoundName:@"wanda.mp3" textures:WANDA_ANIM_ANIM_WANDA_ANIM];
    }
    
    return _sequence;
}


- (SKSpriteNode *)mainNodeWithSize:(CGSize)size {
    SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:WANDA_ANIM_TEX_WANDA_ANIM_01];
    spriteNode.size = size;
    spriteNode.position = CGPointMake(size.width / 2, size.height / 2);
    
    return spriteNode;
}


- (void)runAction {
    [self.sequence runActionOnNode:self.spriteNode];
}


- (SKSpriteNode *)backgroundNodeWithSize:(CGSize)size {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:WANDA_ANIM_TEX_WANDA_FULL_PORTRAIT];
    background.size = size;
    background.position = CGPointMake(size.width / 2, size.height / 2);
    
    return background;
}

@end
