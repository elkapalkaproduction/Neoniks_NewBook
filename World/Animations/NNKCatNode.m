//
//  NNKCatNode.m
//  cat
//
//  Created by Andrei Vidrasco on 8/28/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import "NNKCatNode.h"
#import "cat_anim.h"
#import "VelocityCreation.h"
#import "SKSpriteNode+TextureCreation.h"

static const CGFloat velocityOnAnimation = 100;
static const CGFloat shouldWaitBeforeNewAnimation = 1.f;

@interface NNKCatNode () <SKPhysicsContactDelegate>

@property (strong, nonatomic) SKTextureAtlas *atlass;
@property (strong, nonatomic) SKAction *sequence;
@property (strong, nonatomic) SKSpriteNode *spriteNode;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGSize initialSize;
@property (assign, nonatomic) BOOL disableNewAction;

@end

@implementation NNKCatNode

- (CGSize)newSizeFromSize:(CGSize)size {
    CGSize newSize = size;
    newSize.width /= 1.5;
    newSize.height /= 1.5;
    CGFloat imageWidth = 425;
    CGFloat imageHeigth = 760;
    CGFloat widthHeigth = imageWidth / imageHeigth;
    CGFloat heigthWidth = imageHeigth / imageWidth;
    
    if (newSize.height * widthHeigth < newSize.width) {
        newSize.width = newSize.height * widthHeigth;
    } else if (newSize.width * heigthWidth < newSize.height) {
        newSize.height = newSize.width * heigthWidth;
    } else {
        return [self newSizeFromSize:newSize];
    }

    return newSize;
}


- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        _initialSize = size;
        _size = [self newSizeFromSize:_initialSize];
        [self addChild:[SKSpriteNode nodeWithSize:_size texture:CAT_ANIM_TEX_CAT_ANIM_LIVE]];
        _atlass = [SKTextureAtlas atlasNamed:CAT_ANIM_ATLAS_NAME];
        _spriteNode = [SKSpriteNode nodeWithSize:_size texture:CAT_ANIM_TEX_CAT_ANIM_PROPELLER_1];
        [self addChild:_spriteNode];
    }

    return self;
}


- (void)adjustScene {
    SKScene *scene = self.scene;
    scene.physicsWorld.contactDelegate = self;
    scene.physicsWorld.gravity = CGVectorMake(0, 0);
    scene.backgroundColor = [SKColor clearColor];

    scene.physicsBody = [VelocityCreation createBackgroundPhysicsBodyForWithFrame:scene.frame];
}


- (CGRect)physicsBodyFrame {
    return CGRectMake(self.size.width / 2,
                      self.size.height / 2,
                      self.size.width,
                      self.size.height);
}


- (CGVector)variableVector {
    CGFloat minimumVelocity = 25;
    NSInteger variableVelocity = 25;

    return CGVectorMake(rand() % variableVelocity + minimumVelocity,
                        -(rand() % variableVelocity + minimumVelocity));
}


- (void)initialize {
    self.disableNewAction = NO;
    [self adjustScene];
    self.physicsBody = [VelocityCreation createPhysicsBodyWithFrame:self.physicsBodyFrame
                                                           velocity:self.variableVector];
}


- (SKAction *)sequence {
    if (!_sequence) {
        _sequence = [SKAction repeatActionForever:[SKAction animateWithTextures:CAT_ANIM_ANIM_CAT_ANIM_PROPELLER
                                                                   timePerFrame:1.f / 15.f]];
    }

    return _sequence;
}


- (void)runBackgrounAction {
    [self removeAllActions];
    [self initialize];
    [self.spriteNode runAction:self.sequence];
}


- (void)removeTopBorderAndChangeVelocity {
    CGRect frame = self.scene.frame;
    frame.size.height += self.size.height;
    self.scene.physicsBody = [VelocityCreation createBackgroundPhysicsBodyForWithFrame:frame];
    self.physicsBody.velocity = CGVectorMake(0, velocityOnAnimation);
}


- (void)runAction {
    if (self.disableNewAction) return;
    if (self.completionBlock) self.completionBlock();
    self.disableNewAction = YES;
    CGRect frame = self.scene.frame;
    frame.size.height += self.size.height * 1.1;
    self.scene.physicsBody = [VelocityCreation createBackgroundPhysicsBodyForWithFrame:frame];
    self.physicsBody.velocity = CGVectorMake(0, velocityOnAnimation);
}


- (void)didBeginContact:(SKPhysicsContact *)contact {
    if (!self.disableNewAction) return;
    if (self.position.y >= self.size.height / 2) {
        self.physicsBody.velocity = CGVectorMake(0, 0);
        [self performSelector:@selector(enableAnimationVelocity)
                   withObject:nil
                   afterDelay:shouldWaitBeforeNewAnimation];
    } else if (self.position.y <= self.size.height / 2) {
        [self initialize];
    }
}


- (void)enableAnimationVelocity {
    self.physicsBody.velocity = CGVectorMake(0, -velocityOnAnimation);
}

@end
