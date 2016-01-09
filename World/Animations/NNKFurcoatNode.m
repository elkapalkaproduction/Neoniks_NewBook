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
@property (assign, nonatomic) BOOL unablePlayAnimation;

@end

@implementation NNKFurcoatNode

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        _atlass = [SKTextureAtlas atlasNamed:AtlasName];
        _spriteNode = [self mainNodeWithSize:size];
        [self addChild:_spriteNode];
    }
    
    return self;
}


- (void)removeFromParent {
    [super removeFromParent];
    [self.sequence stopActionFromNode:self.spriteNode];
}


- (SKAction *)sequence {
    if (!_sequence) {
        SKAction *action = [SKAction animateWithTextures:AnimName timePerFrame:1.f / 15.f];
        _sequence = [SKAction actionWithSoundName:@"furcoat.mp3" action:[SKAction repeatAction:action count:5]];
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
    [self performSelector:@selector(allowAnimationPlay) withObject:nil afterDelay:3.f];
    [self.sequence runActionOnNode:self.spriteNode];
}


- (void)allowAnimationPlay {
    self.unablePlayAnimation = NO;
}

@end
