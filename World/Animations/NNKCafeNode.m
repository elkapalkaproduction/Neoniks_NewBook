//
//  NNKCafeNode.m
//  TexturePacker-SpriteKit
//
//  Created by Andrei Vidrasco on 6/2/15.
//  Copyright (c) 2015 Neoniks. All rights reserved.
//

#import "NNKCafeNode.h"
#import "cafe_frames.h"
#import "AVAudioPlayer+Creation.h"

@interface NNKCafeNode ()

@property (strong, nonatomic) SKTextureAtlas *atlass;
@property (assign, nonatomic) BOOL selected;
@property (strong, nonatomic) SKSpriteNode *mainNode;
@property (assign, nonatomic) CGSize nodeSize;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) AVAudioPlayer *player;

@end

@implementation NNKCafeNode

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        _atlass = [SKTextureAtlas atlasNamed:CAFE_FRAMES_ATLAS_NAME];
        _nodeSize = size;
        self.selected = YES;
        [self runActionWithoutSound];
    }
    
    return self;
}


- (SKSpriteNode *)mainNode {
    if (_mainNode) return _mainNode;
    if (self.selected) {
        _mainNode = [SKSpriteNode spriteNodeWithTexture:CAFE_FRAMES_TEX_CAFE_TURNED_ON];
    } else {
        _mainNode = [SKSpriteNode spriteNodeWithTexture:CAFE_FRAMES_TEX_CAFE_TURNED_OFF];
    }
    
    return _mainNode;
}


- (AVAudioPlayer *)player {
    if (!_player) {
        _player = [AVAudioPlayer audioPlayerWithSoundName:@"cafe.mp3"];
    }
    
    return _player;
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
    if (self.selected) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.player.duration
                                                      target:self
                                                    selector:@selector(runActionWithoutSound)
                                                    userInfo:nil
                                                     repeats:NO];
        self.player.currentTime = 0.f;
        [self.player play];
    } else {
        [self.player stop];
        [self.timer invalidate];
    }
}


- (void)stopAction {
    [super stopAction];
    [self.player stop];
    [self.timer invalidate];
}

@end
