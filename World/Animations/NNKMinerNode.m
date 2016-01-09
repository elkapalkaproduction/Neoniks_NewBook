//
//  MinerSpriteNode.m
//  TexturePacker-SpriteKit
//
//  Created by Andrei Vidrasco on 5/30/15.
//  Copyright (c) 2015 CodeAndWeb. All rights reserved.
//

#import "NNKMinerNode.h"
#import "miner_anim.h"

@interface NNKMinerNode ()

@property (strong, nonatomic) SKTextureAtlas *atlass;
@property (strong, nonatomic) SKAction *sequence;
@property (strong, nonatomic) SKSpriteNode *spriteNode;
@property (assign, nonatomic) BOOL unablePlayAnimation;

@end

@implementation NNKMinerNode

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        [self addChild:[self backgroundNodeWithSize:size]];
        _atlass = [SKTextureAtlas atlasNamed:MINER_ANIM_ATLAS_NAME];
        _spriteNode = [self mainNodeWithSize:size];
        [self addChild:_spriteNode];
    }
    
    return self;
}


- (SKAction *)sequence {
    if (!_sequence) {
        _sequence = [SKAction actionWithSoundName:@"miner.mp3" textures:MINER_ANIM_ANIM_MINER_ANIM];
    }
    
    return _sequence;
}


- (SKSpriteNode *)mainNodeWithSize:(CGSize)size {
    SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:MINER_ANIM_TEX_MINER_ANIM_01];
    spriteNode.size = size;
    spriteNode.position = CGPointMake(size.width / 2, size.height / 2);
    
    return spriteNode;
}


- (void)runAction {
    if (self.unablePlayAnimation) return;
    self.unablePlayAnimation = YES;
    [self performSelector:@selector(allowAnimationPlay) withObject:nil afterDelay:1.f];
    [self.sequence runActionOnNode:self.spriteNode];
}


- (void)allowAnimationPlay {
    self.unablePlayAnimation = NO;
}


- (SKSpriteNode *)backgroundNodeWithSize:(CGSize)size {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:MINER_ANIM_TEX_MINER_FULL_PORTRAIT];
    background.size = size;
    background.position = CGPointMake(size.width / 2, size.height / 2);
    
    return background;
}

@end
