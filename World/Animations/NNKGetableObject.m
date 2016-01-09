//
//  NNKGetableObject.m
//  World
//
//  Created by Andrei Vidrasco on 1/9/16.
//  Copyright © 2016 Andrei Vidrasco. All rights reserved.
//

#import "NNKGetableObject.h"

@interface NNKGetableObject ()

@property (assign, nonatomic) CGSize nodeSize;
@property (strong, nonatomic) SKEmitterNode *emitter;

@end

@implementation NNKGetableObject

- (instancetype)initWithSize:(CGSize)nodeSize
                        type:(GetableObjectType)type {
    self = [super initWithSize:nodeSize];
    if (self) {
        self.type = type;
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:[self imageNameForType:type]];
        _nodeSize = nodeSize;
        sprite.position = CGPointMake(nodeSize.width / 2, nodeSize.height / 2);
        sprite.size = nodeSize;
        [self addChild:sprite];
        [self runAction];
        SKSpriteNode *takeMe = [SKSpriteNode spriteNodeWithImageNamed:[self takeMeImageNameForType:type]];
        CGSize takeMeSize = takeMe.size;
        takeMe.size = CGSizeMake(sprite.size.width, (takeMeSize.height * sprite.size.width) / takeMeSize.width);
        takeMe.position = CGPointMake(nodeSize.width / 2, 10 + takeMe.size.height / 2);
        [self addChild:takeMe];
    }
    
    return self;
}


- (NSString *)imageNameForType:(GetableObjectType)type {
    switch (type) {
        case GetableObjectTypeBottleOfMagic:
            return @"inventary_full_bottle_icon";
        case GetableObjectTypeMagicBook:
            return @"inventary_full_book_icon";
        case GetableObjectTypeWrench:
            return @"inventary_full_wrench_icon";
        case GetableObjectTypeMagicBallCat:
        case GetableObjectTypeMagicBallNinja:
        case GetableObjectTypeMagicBallSheep:
            return @"inventary_full_ball_of_magic_icon";
        default:
            return @"";
    }
}


- (NSString *)takeMeImageNameForType:(GetableObjectType)type {
    switch (type) {
        case GetableObjectTypeBottleOfMagic:
        case GetableObjectTypeMagicBook:
        case GetableObjectTypeWrench:
        case GetableObjectTypeMagicBallNinja:
        case GetableObjectTypeMagicBallSheep:
        case GetableObjectTypeMagicBallCat:
            return NSLocalizedString(@"take_me_white", nil);
//            return NSLocalizedString(@"take_me_black", nil);
        default:
            return @"";
    }
}


- (SKEmitterNode *)emitter {
    if (!_emitter) {
        SKEmitterNode *trail = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MystieParticles" ofType:@"sks"]];
        trail.targetNode = self;
        trail.particleScale = 1;
        CGSize nodeSize = self.nodeSize;
        trail.position = CGPointMake(nodeSize.width / 2, nodeSize.height / 2);
        trail.particlePositionRange = CGVectorMake(nodeSize.width, nodeSize.height);
        trail.particleSize = CGSizeMake(22, 22);
        _emitter = trail;
    }
    
    return _emitter;
}


- (void)runAction {
    [self addChild:self.emitter];
}

@end
