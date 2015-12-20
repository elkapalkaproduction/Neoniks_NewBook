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
@property (assign, nonatomic) CGSize catSize;
@property (assign, nonatomic) CGSize initialSize;
@property (assign, nonatomic) BOOL disableNewAction;

@end

@implementation NNKCatNode

- (CGSize)newSizeFromSize:(CGSize)size {
    CGSize newSize = size;

    newSize.height /= 1.6;
    newSize.width = newSize.height * 425 / 760;

    return newSize;
}


- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        self.size = size;
        _initialSize = size;
        _catSize = [self newSizeFromSize:_initialSize];
        [self addChild:[SKSpriteNode nodeWithSize:_catSize texture:CAT_ANIM_TEX_CAT_ANIM_LIVE]];
        _atlass = [SKTextureAtlas atlasNamed:CAT_ANIM_ATLAS_NAME];
        _spriteNode = [SKSpriteNode nodeWithSize:_catSize texture:CAT_ANIM_TEX_CAT_ANIM_PROPELLER_1];
        [self addChild:_spriteNode];
    }

    return self;
}


- (void)adjustScene {
    SKScene *scene = self.scene;
    scene.physicsWorld.contactDelegate = self;
    scene.physicsWorld.gravity = CGVectorMake(0, 0);
    scene.backgroundColor = [SKColor clearColor];
    self.parent.physicsBody = [VelocityCreation createBackgroundPhysicsBodyForWithFrame:self.physicBorderFrame];
}


- (CGRect)physicBorderFrame {
    CGFloat width = self.size.width * self.parent.frame.size.width / 3000;
    CGFloat height = width * self.size.height / self.size.width;
    
    return  CGRectMake(self.parent.frame.size.width - width, self.parent.frame.size.height - height, width, height);
}


- (CGRect)physicsBodyFrame {
    return CGRectMake(self.catSize.width / 2,
                      self.catSize.height / 2,
                      self.catSize.width,
                      self.catSize.height);
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


- (void)runAction {
    if (self.disableNewAction) return;
    if (self.completionBlock) self.completionBlock();
    self.disableNewAction = YES;
    CGRect frame = self.physicBorderFrame;
    frame.size.height += (self.catSize.height * 1.1) * self.parent.frame.size.height / 3600;
    self.parent.physicsBody = [VelocityCreation createBackgroundPhysicsBodyForWithFrame:frame];
    self.physicsBody.velocity = CGVectorMake(0, velocityOnAnimation);
}


- (void)didBeginContact:(SKPhysicsContact *)contact {
    if (!self.disableNewAction) return;
    if (contact.contactNormal.dy < 0) {
        self.physicsBody.velocity = CGVectorMake(0, 0);
        [self performSelector:@selector(enableAnimationVelocity)
                   withObject:nil
                   afterDelay:shouldWaitBeforeNewAnimation];
    } else if (contact.contactNormal.dy > 0) {
        [self initialize];
    }
}


- (void)enableAnimationVelocity {
    self.physicsBody.velocity = CGVectorMake(0, -velocityOnAnimation);
}

@end
