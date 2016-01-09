//
//  NNKHaroldNode.m
//  TexturePacker-SpriteKit
//
//  Created by Andrei Vidrasco on 5/30/15.
//  Copyright (c) 2015 Neoniks. All rights reserved.
//

#import "NNKHaroldNode.h"
#import "harold_anim.h"

#define AtlasName HAROLD_ANIM_ATLAS_NAME
#define AnimName HAROLD_ANIM_ANIM_HAROLD_ANIM
#define FirstFrameName HAROLD_ANIM_TEX_HAROLD_ANIM_01

@interface NNKHaroldNode ()

@property (strong, nonatomic) SKTextureAtlas *atlass;
@property (strong, nonatomic) SKAction *sequence;
@property (strong, nonatomic) SKSpriteNode *spriteNode;
@property (assign, nonatomic) BOOL unablePlayAnimation;

@end

@implementation NNKHaroldNode

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        _atlass = [SKTextureAtlas atlasNamed:AtlasName];
        _spriteNode = [self mainNodeWithSize:size];
        [self addChild:_spriteNode];
    }
    
    return self;
}


- (SKAction *)sequence {
    if (!_sequence) {
        
        _sequence = [SKAction actionWithSoundName:@"harold.mp3" textures:AnimName];
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
    if (self.unablePlayAnimation) return;
    self.unablePlayAnimation = YES;
    [self performSelector:@selector(allowAnimationPlay) withObject:nil afterDelay:1.f];
    [self.sequence runActionOnNode:self.spriteNode];
}


- (void)allowAnimationPlay {
    self.unablePlayAnimation = NO;
}

@end
