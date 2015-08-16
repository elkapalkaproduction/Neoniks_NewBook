//
//  NNKMystieNode.m
//  TexturePacker-SpriteKit
//
//  Created by Andrei Vidrasco on 6/6/15.
//  Copyright (c) 2015 Neoniks. All rights reserved.
//

#import "NNKMystieNode.h"
#import "AVAudioPlayer+Creation.h"

@interface NNKMystieNode ()

@property (assign, nonatomic) CGSize nodeSize;
@property (strong, nonatomic) SKEmitterNode *emitter;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) AVAudioPlayer *player;

@end

@implementation NNKMystieNode

- (instancetype)initWithSize:(CGSize)nodeSize {
    self = [super init];
    if (self) {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"full_portret_color_3"];
        _nodeSize = nodeSize;
        sprite.position = CGPointMake(nodeSize.width / 2, nodeSize.height / 2);
        sprite.size = nodeSize;
        [self addChild:sprite];
    }
    
    return self;
}


- (SKEmitterNode *)emitter {
    if (!_emitter) {
        SKEmitterNode *trail = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MystieParticles" ofType:@"sks"]];
        trail.targetNode = self;
        trail.particleScale = 1;
        CGSize nodeSize = self.nodeSize;
        trail.position = CGPointMake(nodeSize.width / 2, nodeSize.height / 2);
        trail.particlePositionRange = CGVectorMake(nodeSize.width, nodeSize.height);
        trail.particleSize = CGSizeMake(22, 22);
        _emitter = trail;
    }
    
    return _emitter;
}


- (AVAudioPlayer *)player {
    if (!_player) {
        _player = [AVAudioPlayer audioPlayerWithSoundName:@"mystie.mp3"];
    }
    
    return _player;
}


- (void)runAction {
    if (self.emitter.parent) {
        [self.timer invalidate];
        [self removeAllActions];
        [self.emitter removeFromParent];
        [self.player stop];
    } else {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.player.duration
                                                      target:self.emitter
                                                    selector:@selector(removeFromParent)
                                                    userInfo:nil
                                                     repeats:NO];
        self.player.currentTime = 0.f;
        [self.player play];
        [self addChild:self.emitter];
    }
}

@end
