//
//  NNKCatNode.h
//  cat
//
//  Created by Andrei Vidrasco on 8/28/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class NNKCatNode;

typedef void (^CatCompletionBlock)();

@interface NNKCatNode : NNKSpriteNode

- (void)runBackgrounAction;
@property (copy, nonatomic) CatCompletionBlock completionBlock;

@end
