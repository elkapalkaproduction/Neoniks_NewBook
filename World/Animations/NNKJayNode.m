//
//  NNKJayNode.m
//  TexturePacker-SpriteKit
//
//  Created by Andrei Vidrasco on 5/30/15.
//  Copyright (c) 2015 Neoniks. All rights reserved.
//

#import "NNKJayNode.h"
#import "jay_anim.h"

@interface NNKJayNode ()

@property (strong, nonatomic) SKTextureAtlas *atlass;
@property (strong, nonatomic) SKAction *pendantSequence;
@property (strong, nonatomic) SKAction *blickSequence;
@property (strong, nonatomic) SKSpriteNode *pendant;
@property (strong, nonatomic) SKSpriteNode *blick;

@end

@implementation NNKJayNode

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        [self addChild:[self backgroundNodeWithSize:size]];
        _atlass = [SKTextureAtlas atlasNamed:JAY_ANIM_ATLAS_NAME];
        _blick = [self mainNodeWithSize:size texture:JAY_ANIM_TEX_JAY_BLICK_00];
        [self addChild:_blick];
        _pendant = [self mainNodeWithSize:size texture:JAY_ANIM_TEX_JAY_PENDANT_00];
        [self addChild:_pendant];
    }
    
    return self;
}


- (SKAction *)pendantSequence {
    if (!_pendantSequence) {
        _pendantSequence = [SKAction repeatActionForever:[SKAction animateWithTextures:JAY_ANIM_ANIM_JAY_PENDANT
                                                                   timePerFrame:1.f / 15.f]];
    }
    
    return _pendantSequence;
}


- (SKAction *)blickSequence {
    if (!_blickSequence) {
        _blickSequence = [SKAction repeatActionForever:[SKAction animateWithTextures:JAY_ANIM_ANIM_JAY_BLICK
                                                                   timePerFrame:1.f / 15.f]];
    }
    
    return _blickSequence;
}


- (SKSpriteNode *)mainNodeWithSize:(CGSize)size texture:(SKTexture *)texure {
    SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:texure];
    spriteNode.size = size;
    spriteNode.position = CGPointMake(size.width / 2, size.height / 2);
    
    return spriteNode;
}


- (void)runAction {
    [self.blick runAction:self.blickSequence];
    [self.pendant runAction:self.pendantSequence];
}


- (SKSpriteNode *)backgroundNodeWithSize:(CGSize)size {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:JAY_ANIM_TEX_JAY_FULL_PORTRAIT];
    background.size = size;
    background.position = CGPointMake(size.width / 2, size.height / 2);
    
    return background;
}

@end
