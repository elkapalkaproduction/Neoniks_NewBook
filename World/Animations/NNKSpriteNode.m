//
//  NNKSPriteNode.m
//  World
//
//  Created by Andrei Vidrasco on 1/9/16.
//  Copyright © 2016 Andrei Vidrasco. All rights reserved.
//

#import "NNKSPriteNode.h"

@implementation NNKSpriteNode

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        self.size = size;
//        SKSpriteNode *noddd = [SKSpriteNode spriteNodeWithColor:[[SKColor redColor] colorWithAlphaComponent:0.5] size:size];
//        [self addChild:noddd];
//        noddd.position = CGPointMake(noddd.size.width / 2, noddd.size.height / 2);
    }
    
    return self;
}


- (void)removeFromParent {
    [self removeAllActions];
    [super removeFromParent];
}


- (void)runAction {
}


- (void)stopAction {
    [self removeAllActions];
}

@end
