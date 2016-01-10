//
//  NNKSkeletNode.m
//  World
//
//  Created by Andrei Vidrasco on 6/29/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "NNKSkeletNode.h"
#import "skelet_anim.h"

#define AtlasName SKELET_ANIM_ATLAS_NAME
#define AnimName SKELET_ANIM_ANIM_SKELET
#define FirstFrameName [AnimName firstObject]
#define LastFrameName [AnimName lastObject]

@interface NNKSkeletNode ()

@property (strong, nonatomic) SKTextureAtlas *atlass;
@property (strong, nonatomic) SKAction *sequence;
@property (strong, nonatomic) SKSpriteNode *spriteNode;
@property (assign, nonatomic) BOOL disableAnimation;

@end

@implementation NNKSkeletNode

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        _atlass = [SKTextureAtlas atlasNamed:AtlasName];
        _spriteNode = [self mainNodeWithSize:size last:NO];
        [self addChild:_spriteNode];
    }
    
    return self;
}


- (SKAction *)sequence {
    if (!_sequence) {
        _sequence =  [SKAction actionWithSoundName:@"skeleton" textures:AnimName];
    }
    
    return _sequence;
}


- (SKSpriteNode *)mainNodeWithSize:(CGSize)size last:(BOOL)last {
    SKTexture *texture = last ? LastFrameName : FirstFrameName;
    SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:texture];
    spriteNode.size = size;
    spriteNode.position = CGPointMake(size.width / 2, size.height / 2);
    
    return spriteNode;
}


- (void)showLastFrame {
    [self.spriteNode removeFromParent];
    self.spriteNode = [self mainNodeWithSize:self.spriteNode.size last:YES];
    [self addChild:self.spriteNode];
    self.disableAnimation = YES;
}


- (void)showFirstFrame {
    [self.spriteNode removeFromParent];
    self.spriteNode = [self mainNodeWithSize:self.spriteNode.size last:NO];
    [self addChild:self.spriteNode];
    self.disableAnimation = NO;
}


- (void)runAction {
    if (self.disableAnimation) return;
    self.disableAnimation = YES;
    [self.sequence runActionOnNode:self.spriteNode];
}

@end
