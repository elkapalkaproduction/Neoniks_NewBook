//
//  NNKBatNode.m
//  World
//
//  Created by Andrei Vidrasco on 1/10/16.
//  Copyright © 2016 Andrei Vidrasco. All rights reserved.
//

#import "NNKBatNode.h"
#import "bat_anim.h"

#define AtlasName BAT_ANIM_ATLAS_NAME
#define AnimName BAT_ANIM_ANIM_BAT
#define FirstFrameName BAT_ANIM_TEX_BAT_1

@interface NNKBatNode ()

@property (strong, nonatomic) SKTextureAtlas *atlass;
@property (strong, nonatomic) SKAction *sequence;
@property (strong, nonatomic) SKSpriteNode *spriteNode;
@property (strong, nonatomic) SKAction *secondAction;

@end

@implementation NNKBatNode

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
        _sequence = [SKAction repeatActionForever:[SKAction animateWithTextures:AnimName
                                                                   timePerFrame:1.f / 15.f]];
    }
    
    return _sequence;
}


- (SKAction *)secondAction {
    if (!_secondAction) {
        NSTimeInterval duration = 0.3;
        SKAction *scale = [SKAction scaleTo:0.05 duration:duration];
        SKAction *rotation = [SKAction rotateToAngle:-M_PI duration:duration];
        _secondAction = [SKAction actionWithSoundName:@"bat" action:[SKAction group:@[scale, rotation]]];
    }
    
    return _secondAction;
}


- (SKSpriteNode *)mainNodeWithSize:(CGSize)size {
    SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:FirstFrameName];
    spriteNode.size = size;
    spriteNode.position = CGPointMake(size.width / 2, size.height / 2);
    
    return spriteNode;
}


- (void)runAction {
    [self.sequence runActionOnNode:self.spriteNode];
}


- (void)squeeze:(BOOL)squeeze {
    [self.spriteNode removeAllActions];
    if (squeeze) {
        [self.secondAction runActionOnNode:self.spriteNode];
    } else {
        NSTimeInterval duration = 0.3;
        SKAction *scale = [SKAction scaleTo:1 duration:duration];
        SKAction *rotation = [SKAction rotateToAngle:0 duration:duration];
        [[SKAction group:@[scale, rotation]] runActionOnNode:self.spriteNode completion:^{
            [self runAction];
        }];
    }
}

@end
