//
//  NNKSheepNode.h
//  World
//
//  Created by Andrei Vidrasco on 7/5/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class NNKSheepNode;

typedef void (^SheepCompletionBlock)(NNKSheepNode *node);

@interface NNKSheepNode : NNKSpriteNode

@property (copy, nonatomic) SheepCompletionBlock completionBlock;

@end
