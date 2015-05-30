//
//  MyScene.m
//  TexturePacker-SpriteKit
//
//  Created by joachim on 23.09.13.
//  Copyright (c) 2013 CodeAndWeb. All rights reserved.
//

#import "MyScene.h"
#import "museum.h"
#import "foam_castle.h"
#import "lantern_house.h"
#import "bottom_island.h"
#import "wanda_anim.h"
#import "jay_anim.h"
#import "harold_anim.h"
#import "furcoat_anim.h"
#import "miner_anim.h"
#import "NNKMinerNode.h"

@interface MyScene ()


@end

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
