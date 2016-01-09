//
//  NNKSkeletNode.h
//  World
//
//  Created by Andrei Vidrasco on 6/29/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class NNKSkeletNode;

typedef void (^SkeletCompletionBlock)(NNKSkeletNode *node);

@interface NNKSkeletNode : NNKSpriteNode

- (void)showLastFrame;

@end
