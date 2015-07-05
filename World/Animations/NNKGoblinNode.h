//
//  NNKGoblinNode.h
//  World
//
//  Created by Andrei Vidrasco on 7/5/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CustomNodeProtocol.h"

@class NNKGoblinNode;

typedef void (^GoblinCompletionBlock)(NNKGoblinNode *node);

@interface NNKGoblinNode : SKNode <CustomNodeProtocol>

- (instancetype)initWithSize:(CGSize)size shouldHideWrench:(BOOL)shouldHideWrench;
- (void)removeWrench;
@property (copy, nonatomic) GoblinCompletionBlock completionBlock;

@end
