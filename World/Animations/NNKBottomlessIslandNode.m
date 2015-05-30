//
//  NNKBottomlessIslandNode.m
//  TexturePacker-SpriteKit
//
//  Created by Andrei Vidrasco on 5/30/15.
//  Copyright (c) 2015 Neoniks. All rights reserved.
//

#import "NNKBottomlessIslandNode.h"
#import "bottom_island.h"

@interface NNKBottomlessIslandNode ()

@property (strong, nonatomic) SKTextureAtlas *atlass;
@property (strong, nonatomic) SKAction *sequence;
@property (strong, nonatomic) SKSpriteNode *spriteNode;

@end

@implementation NNKBottomlessIslandNode


- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        [self addChild:[self backgroundNodeWithSize:size imageName:@"pop_up_image_6"]];
        _atlass = [SKTextureAtlas atlasNamed:BOTTOM_ISLAND_ATLAS_NAME];
        _spriteNode = [self mainNodeWithSize:size];
        [self addChild:_spriteNode];
        [self addChild:[self backgroundNodeWithSize:size imageName:@"bottom_island_front"]];
    }
    
    return self;
}


- (SKAction *)sequence {
    if (!_sequence) {
        _sequence = [SKAction repeatActionForever:[SKAction animateWithTextures:BOTTOM_ISLAND_ANIM_BOTTOM_ISLAND
                                                                   timePerFrame:1.f / 15.f]];
    }
    
    return _sequence;
}


- (SKSpriteNode *)mainNodeWithSize:(CGSize)size {
    SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:BOTTOM_ISLAND_TEX_BOTTOM_ISLAND_01];
    spriteNode.size = size;
    spriteNode.position = CGPointMake(size.width / 2, size.height / 2);
    
    return spriteNode;
}


- (void)runAction {
    [self.spriteNode runAction:self.sequence];
}


- (SKSpriteNode *)backgroundNodeWithSize:(CGSize)size imageName:(NSString *)imageName {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:imageName]];
    background.size = size;
    background.position = CGPointMake(size.width / 2, size.height / 2);
    
    return background;
}

@end
