//
//  NNKLampNode.m
//  World
//
//  Created by Andrei Vidrasco on 1/10/16.
//  Copyright © 2016 Andrei Vidrasco. All rights reserved.
//

#import "NNKLampNode.h"

@interface NNKLampNode ()

@property (strong, nonatomic) SKSpriteNode *mainNode;
@property (assign, nonatomic) CGSize nodeSize;

@end

@implementation NNKLampNode

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        _nodeSize = size;
        _selected = NO;
        [self addChild:self.mainNode];
        self.mainNode.size = size;
        self.mainNode.position = CGPointMake(size.width / 2, size.height / 2);
    }
    
    return self;
}


- (SKSpriteNode *)mainNode {
    if (_mainNode) return _mainNode;
    if (self.selected) {
        _mainNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"lamp_on"]];
    } else {
        _mainNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"lamp_off"]];
    }
    
    return _mainNode;
}


- (void)runAction {
    [self.mainNode removeFromParent];
    self.selected = !self.selected;
    self.mainNode = nil;
    [self addChild:self.mainNode];
    self.mainNode.size = self.nodeSize;
    self.mainNode.position = CGPointMake(self.nodeSize.width / 2, self.nodeSize.height / 2);
    if (SoundStatus.isEnabled) {
        [[SKAction playSoundFileNamed:@"lamp.mp3" waitForCompletion:NO] runActionOnNode:self];
    }
}

@end
