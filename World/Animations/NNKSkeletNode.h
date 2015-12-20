//
//  NNKSkeletNode.h
//  World
//
//  Created by Andrei Vidrasco on 6/29/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CustomNodeProtocol.h"

@class NNKSkeletNode;

typedef void (^SkeletCompletionBlock)(NNKSkeletNode *node);

@interface NNKSkeletNode : SKSpriteNode <CustomNodeProtocol>

- (instancetype)initWithSize:(CGSize)size showLastFrameOnLoad:(BOOL)showLastFrameOnLoad;

- (void)showLastFrame;
@property (copy, nonatomic) SkeletCompletionBlock completionBlock;
@property (assign, nonatomic) BOOL disableAnimation;

@end
