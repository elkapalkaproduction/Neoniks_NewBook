//
//  NNKSPriteNode.h
//  World
//
//  Created by Andrei Vidrasco on 1/9/16.
//  Copyright © 2016 Andrei Vidrasco. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface NNKSpriteNode : SKSpriteNode

- (instancetype)initWithSize:(CGSize)size;

- (void)runAction;
- (void)stopAction;

@end
