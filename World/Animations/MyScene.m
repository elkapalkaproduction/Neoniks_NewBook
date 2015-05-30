//
//  MyScene.m
//  TexturePacker-SpriteKit
//
//  Created by joachim on 23.09.13.
//  Copyright (c) 2013 CodeAndWeb. All rights reserved.
//

#import "MyScene.h"
#import "CustomNodeProtocol.h"

@implementation MyScene

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.node runAction];
}


- (void)setNode:(SKNode<CustomNodeProtocol> *)node {
    if (_node) {
        [_node removeFromParent];
    }
    _node = node;
    if (_node) {
        [self addChild:_node];
    }
}

@end
