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
    NSAssert(true, @"error");
    
    return nil;
}


- (void)removeFromParent {
    [super removeFromParent];
    [self removeAllActions];
}


- (void)runAction {
}


- (void)stopAction {
    [self removeAllActions];
}

@end
