//
//  NNKFlowerNode.m
//  World
//
//  Created by Andrei Vidrasco on 24/01/16.
//  Copyright © 2016 Andrei Vidrasco. All rights reserved.
//

#import "NNKFlowerNode.h"

@interface NNKFlowerNode ()
@property (assign, nonatomic) BOOL isClosed;
@property (strong, nonatomic) SKNode *node;

@end

@implementation NNKFlowerNode

- (void)setType:(NSInteger)type {
    [self.node removeFromParent];
    self.node = [self mainNodeWithSize:self.size flowerNumber:type];
    [self addChild:self.node];

}


- (SKSpriteNode *)mainNodeWithSize:(CGSize)size flowerNumber:(long)number {
    SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"flower_%ld", number]]];
    spriteNode.size = size;
    spriteNode.position = CGPointMake(spriteNode.size.width / 2, spriteNode.size.height / 2);
    
    return spriteNode;
}



- (void)runAction {
    SKAction *action = [SKAction scaleTo:self.isClosed ? 1.0 : 0.1 duration:0.3];
    self.isClosed = !self.isClosed;
    [action runActionOnNode:self.node];
    [[SKAction playSoundFileNamed:@"flower" waitForCompletion:NO] runActionOnNode:self.node];
}

@end
