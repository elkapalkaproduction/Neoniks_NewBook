//
//  NNKGoblinNode.m
//  World
//
//  Created by Andrei Vidrasco on 7/5/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "NNKGoblinNode.h"
#import "goblin_anim.h"

@interface NNKGoblinNode ()

@property (strong, nonatomic) SKTextureAtlas *atlass;
@property (strong, nonatomic) SKAction *sequence;
@property (strong, nonatomic) SKSpriteNode *spriteNode;
@property (strong, nonatomic) SKSpriteNode *wrenchNode;

@end

@implementation NNKGoblinNode

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        [self addChild:[self backgroundNodeWithSize:size texture:GOBLIN_ANIM_TEX_GOBLIN_BACKGROUND]];
        _atlass = [SKTextureAtlas atlasNamed:GOBLIN_ANIM_ATLAS_NAME];
        _spriteNode = [self mainNodeWithSize:size];
        [self addChild:_spriteNode];
    }
    
    return self;
}


- (instancetype)initWithSize:(CGSize)size shouldHideWrench:(BOOL)shouldHideWrench {
    self = [self initWithSize:size];
    if (shouldHideWrench) return self;
    
    _wrenchNode = [self backgroundNodeWithSize:size texture:GOBLIN_ANIM_TEX_GOBLIN_WRENCH];
    [self addChild:_wrenchNode];
    
    return self;
}


- (SKAction *)sequence {
    if (!_sequence) {
        _sequence = [SKAction animateWithTextures:GOBLIN_ANIM_ANIM_GOBLIN_FRAME
                                     timePerFrame:1.f / 15.f];
    }
    
    return _sequence;
}


- (SKSpriteNode *)mainNodeWithSize:(CGSize)size {
    SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:GOBLIN_ANIM_TEX_GOBLIN_FRAME_01];
    spriteNode.size = size;
    spriteNode.position = CGPointMake(size.width / 2, size.height / 2);
    
    return spriteNode;
}


- (void)runAction {
    if (self.completionBlock) self.completionBlock(self);

    [self.spriteNode runAction:self.sequence completion:^{
    }];
}


- (SKSpriteNode *)backgroundNodeWithSize:(CGSize)size texture:(SKTexture *)texture {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:texture];
    background.size = size;
    background.position = CGPointMake(size.width / 2, size.height / 2);
    
    return background;
}


- (void)removeWrench {
    if (self.wrenchNode) {
        [self.wrenchNode removeFromParent];
    }
}

@end
