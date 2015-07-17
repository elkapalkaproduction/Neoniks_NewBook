//
//  NNKPhoebeNode.m
//  TexturePacker-SpriteKit
//
//  Created by Andrei Vidrasco on 6/1/15.
//  Copyright (c) 2015 Neoniks. All rights reserved.
//

#import "NNKPhoebeNode.h"
#import "phoebe_frames.h"

@interface NNKPhoebeNode ()

@property (strong, nonatomic) SKTextureAtlas *atlass;
@property (strong, nonatomic) SKSpriteNode *phoebeNode;
@property (strong, nonatomic) SKSpriteNode *wingsNode;
@property (assign, nonatomic) CGSize nodeSize;
@property (assign, nonatomic) BOOL wingsShown;

@end

@implementation NNKPhoebeNode


- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        _atlass = [SKTextureAtlas atlasNamed:PHOEBE_FRAMES_ATLAS_NAME];
        _nodeSize = size;
        [self addChild:self.phoebeNode];
        self.phoebeNode.size = size;
        self.phoebeNode.position = CGPointMake(self.nodeSize.width / 2, self.nodeSize.height / 2);
    }
    
    return self;
}


- (SKSpriteNode *)phoebeNode {
    if (!_phoebeNode) {
        _phoebeNode = [SKSpriteNode spriteNodeWithTexture:PHOEBE_FRAMES_TEX_PHOEBE_PORTRAIT];
    }
    
    return _phoebeNode;
}


- (SKSpriteNode *)wingsNode {
    if (!_wingsNode) {
        _wingsNode = [SKSpriteNode spriteNodeWithTexture:PHOEBE_FRAMES_TEX_PHOEBE_WINGS];
    }
    
    return _wingsNode;
}


- (void)runAction {
    if (self.wingsShown) {
        [self.wingsNode removeFromParent];
        self.wingsShown = NO;
        return;
    }
    [self removeAllChildren];
    [self addChild:self.wingsNode];
    [self addChild:self.phoebeNode];
    self.wingsNode.size = self.nodeSize;
    self.wingsNode.position = CGPointMake(self.nodeSize.width / 2, self.nodeSize.height / 2);
    self.wingsShown = YES;
    [self runAction:[SKAction playSoundFileNamed:@"phoebe.mp3" waitForCompletion:NO]];
}

@end
