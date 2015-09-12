//
//  NNKDragonNode.m
//  cat
//
//  Created by Andrei Vidrasco on 9/13/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import "NNKDragonNode.h"
#import "dragon_anim.h"

@interface NNKDragonNode ()

@property (strong, nonatomic) SKTextureAtlas *atlass;
@property (strong, nonatomic) SKAction *sequence;
@property (strong, nonatomic) SKSpriteNode *spriteNode;
@property (strong, nonatomic) SKSpriteNode *bookNode;

@end

@implementation NNKDragonNode

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        [self addChild:[self backgroundNodeWithSize:size texture:DRAGON_ANIM_TEX_DRAGON_BACKGROUND]];
        _atlass = [SKTextureAtlas atlasNamed:DRAGON_ANIM_ATLAS_NAME];
        _spriteNode = [self mainNodeWithSize:size];
        [self addChild:_spriteNode];
    }
    
    return self;
}


- (instancetype)initWithSize:(CGSize)size shouldHideBook:(BOOL)shouldHideBook {
    self = [self initWithSize:size];
    if (shouldHideBook) return self;
    
    _bookNode = [self backgroundNodeWithSize:size texture:DRAGON_ANIM_TEX_DRAGON_BOOK];
    [self addChild:_bookNode];
    
    return self;
}


- (SKAction *)sequence {
    if (!_sequence) {
        _sequence = [SKAction animateWithTextures:DRAGON_ANIM_ANIM_FIRE
                                     timePerFrame:1.f / 15.f];
    }
    
    return _sequence;
}


- (SKSpriteNode *)mainNodeWithSize:(CGSize)size {
    SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:DRAGON_ANIM_TEX_FIRE_0];
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


- (void)removeBook {
    if (self.bookNode) {
        [self.bookNode removeFromParent];
    }
}

@end
