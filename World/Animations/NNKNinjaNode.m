//
//  NNKNinjaNode.m
//  cat
//
//  Created by Andrei Vidrasco on 9/13/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import "NNKNinjaNode.h"
#import "ninja_anim.h"

@interface NNKNinjaNode ()

@property (strong, nonatomic) SKTextureAtlas *atlass;
@property (strong, nonatomic) SKSpriteNode *ninjaNode;
@property (strong, nonatomic) SKSpriteNode *wingsNode;

@end

@implementation NNKNinjaNode

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        self.size = size;
        _atlass = [SKTextureAtlas atlasNamed:NINJA_ANIM_ATLAS_NAME];
        [self addChild:self.ninjaNode];
        [self addChild:[self woodNodeWithSize:CGSizeMake(size.width, size.width * 339. / 203.)
                                       sprite:NINJA_ANIM_TEX_A_PIECE_OF_WOOD]];
    }
    
    return self;
}


- (SKSpriteNode *)ninjaNode {
    if (!_ninjaNode) {
        CGFloat width = self.size.width * 192 / 203;
        _ninjaNode = [self woodNodeWithSize:CGSizeMake(width, width * 409 / 192.)
                                     sprite:NINJA_ANIM_TEX_NINJA_IMAGE];
    }
    
    return _ninjaNode;
}


- (SKSpriteNode *)woodNodeWithSize:(CGSize)size sprite:(SKTexture *)sprite {
    SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:sprite];
    spriteNode.size = size;
    spriteNode.position = CGPointMake(self.size.width - size.width / 2, self.size.height - size.height / 2);
    
    return spriteNode;
}


- (void)runAction {
    if (self.completionBlock) self.completionBlock();
    [self.ninjaNode removeAllActions];
    [[SKAction sequence:@[[SKAction moveToY:self.ninjaNode.size.height / 2 duration:0.5],
                          [SKAction waitForDuration:3],
                          [SKAction moveToY:self.size.height - self.ninjaNode.size.height / 2 duration:0.5]]] runActionOnNode:self.ninjaNode];
}

@end
