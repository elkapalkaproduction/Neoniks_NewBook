//
//  NNKLighthouseNode.m
//  TexturePacker-SpriteKit
//
//  Created by Andrei Vidrasco on 6/2/15.
//  Copyright (c) 2015 Neoniks. All rights reserved.
//

#import "NNKLighthouseNode.h"
#import "lighthouse_frames.h"

@interface NNKLighthouseNode ()

@property (strong, nonatomic) SKTextureAtlas *atlass;
@property (assign, nonatomic) BOOL selected;
@property (strong, nonatomic) SKSpriteNode *mainNode;
@property (assign, nonatomic) CGSize nodeSize;

@end

@implementation NNKLighthouseNode

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        _atlass = [SKTextureAtlas atlasNamed:LIGHTHOUSE_FRAMES_ATLAS_NAME];
        _nodeSize = size;
        self.selected = YES;
        [self runActionWithoutSound];
    }
    
    return self;
}


- (SKSpriteNode *)mainNode {
    if (_mainNode) return _mainNode;
    if (self.selected) {
        _mainNode = [SKSpriteNode spriteNodeWithTexture:LIGHTHOUSE_FRAMES_TEX_LIGHTHOUSE_ON];
    } else {
        _mainNode = [SKSpriteNode spriteNodeWithTexture:LIGHTHOUSE_FRAMES_TEX_LIGHTHOUSE_OFF];
    }
    
    return _mainNode;
}


- (void)runActionWithoutSound {
    [self.mainNode removeFromParent];
    self.selected = !self.selected;
    self.mainNode = nil;
    [self addChild:self.mainNode];
    self.mainNode.size = self.nodeSize;
    self.mainNode.position = CGPointMake(self.nodeSize.width / 2, self.nodeSize.height / 2);
}


- (void)runAction {
    [self runActionWithoutSound];
    [[SKAction playSoundFileNamed:@"lamp.mp3" waitForCompletion:NO] runActionOnNode:self];
}

@end
