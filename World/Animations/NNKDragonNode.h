//
//  NNKDragonNode.h
//  cat
//
//  Created by Andrei Vidrasco on 9/13/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class NNKDragonNode;

typedef void (^DragonCompletionBlock)(NNKDragonNode *node);

@interface NNKDragonNode : NNKSpriteNode

- (instancetype)initWithSize:(CGSize)size shouldHideBook:(BOOL)shouldHideBook;
- (void)removeBook;
- (void)showBook;
@property (copy, nonatomic) DragonCompletionBlock completionBlock;

@end
