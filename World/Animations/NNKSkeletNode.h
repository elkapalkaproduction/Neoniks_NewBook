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

typedef void (^Block)(NNKSkeletNode *node);

@interface NNKSkeletNode : SKNode <CustomNodeProtocol>

- (instancetype)initWithSize:(CGSize)size showLastFrameOnLoad:(BOOL)showLastFrameOnLoad;

@property (copy, nonatomic) Block completionBlock;
@property (assign, nonatomic) BOOL disableAnimation;

@end
