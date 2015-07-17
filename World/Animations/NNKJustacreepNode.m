//
//  NNKJustacreepNode.m
//  TexturePacker-SpriteKit
//
//  Created by Andrei Vidrasco on 6/3/15.
//  Copyright (c) 2015 Neoniks. All rights reserved.
//

#import "NNKJustacreepNode.h"
#import "justacreep_anim.h"

@interface NNKJustacreepNode ()

@property (strong, nonatomic) SKTextureAtlas *atlass;
@property (strong, nonatomic) SKSpriteNode *mainNode;
@property (strong, nonatomic) SKSpriteNode *hatNode;
@property (assign, nonatomic) CGSize nodeSize;

@end

@implementation NNKJustacreepNode

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        _nodeSize = size;
        _atlass = [SKTextureAtlas atlasNamed:JUSTACREEP_ANIM_ATLAS_NAME];
        _mainNode = [SKSpriteNode spriteNodeWithTexture:JUSTACREEP_ANIM_TEX_JUSTACREEP_FULL_PORTRAIT];
        _hatNode = [SKSpriteNode spriteNodeWithTexture:JUSTACREEP_ANIM_TEX_JUSTACREEP_HAT];
        _mainNode.position = CGPointMake(self.nodeSize.width / 2, self.nodeSize.height / 2);
        _mainNode.size = self.nodeSize;
        CGFloat x = (302.5f / 814.f) * self.nodeSize.width;;
        CGFloat y = (1007.5f / 1126.f) * self.nodeSize.height;
        CGFloat width = (147.f / 814.f) * self.nodeSize.width;
        CGFloat height = (129.f / 1126.f) * self.nodeSize.height;
        CGRect rect = CGRectMake(x, y, width, height);
        _hatNode.position = rect.origin;
        _hatNode.size = rect.size;
        [self addChild:_mainNode];
        [self addChild:_hatNode];
        [self addGround];
    }
    
    return self;
}


- (void)addGround {
    SKSpriteNode *rampa2 = [SKSpriteNode spriteNodeWithTexture:JUSTACREEP_ANIM_TEX_JUSTACREEP_BOTTOM];
    rampa2.position = CGPointMake(self.nodeSize.width / 2, 12);
    rampa2.size = CGSizeMake(self.nodeSize.width, (10.f / 814.f) * self.nodeSize.width);
    rampa2.physicsBody = [SKPhysicsBody bodyWithTexture:JUSTACREEP_ANIM_TEX_JUSTACREEP_BOTTOM_TEXTURE size:rampa2.size];
    rampa2.physicsBody.dynamic = false;
    [self addChild:rampa2];
    
}


- (void)runAction {
    self.hatNode.physicsBody = [SKPhysicsBody bodyWithTexture:JUSTACREEP_ANIM_TEX_JUSTACREEP_HAT size:self.hatNode.size];
    self.hatNode.physicsBody.dynamic = YES;
    [self runAction:[SKAction playSoundFileNamed:@"justacreep.mp3" waitForCompletion:NO]];
}

@end
