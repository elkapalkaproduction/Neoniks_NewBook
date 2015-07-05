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
@property (assign, nonatomic) BOOL showLastFrameOnLoad;

@end

@implementation NNKSkeletNode

- (instancetype)initWithSize:(CGSize)size showLastFrameOnLoad:(BOOL)showLastFrameOnLoad {
    self = [self initWithSize:size];
    if (self) {
        _showLastFrameOnLoad = showLastFrameOnLoad;
        _atlass = [SKTextureAtlas atlasNamed:AtlasName];
        _spriteNode = [self mainNodeWithSize:size];
        [self addChild:_spriteNode];
    }
    
    return self;
}


- (instancetype)initWithSize:(CGSize)size {
    return [super init];
}


- (SKAction *)sequence {
    if (!_sequence) {
        _sequence = [SKAction animateWithTextures:AnimName
                                     timePerFrame:1.f / 15.f];
    }
    
    return _sequence;
}


- (SKSpriteNode *)mainNodeWithSize:(CGSize)size {
    SKTexture *texture = self.showLastFrameOnLoad ? LastFrameName : FirstFrameName;
    SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:texture];
    spriteNode.size = size;
    spriteNode.position = CGPointMake(size.width / 2, size.height / 2);
    
    return spriteNode;
}


- (void)setShowLastFrameOnLoad:(BOOL)showLastFrameOnLoad {
    _showLastFrameOnLoad = showLastFrameOnLoad;
    if (showLastFrameOnLoad) {
        _spriteNode = [self mainNodeWithSize:_spriteNode.size];
    }
    
}


- (void)runAction {
    if (self.disableAnimation) return;
    __weak typeof(self) weakSelf = self;
    [self.spriteNode runAction:self.sequence completion:^{
        if (weakSelf.completionBlock) weakSelf.completionBlock(weakSelf);
    }];
}

@end
