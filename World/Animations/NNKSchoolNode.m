//
//  NNKSchoolNode.m
//  TexturePacker-SpriteKit
//
//  Created by Andrei Vidrasco on 6/1/15.
//  Copyright (c) 2015 Neoniks. All rights reserved.
//

#import "NNKSchoolNode.h"
#import "school_frames.h"

@interface NNKSchoolNode ()

@property (strong, nonatomic) SKTextureAtlas *atlass;

@property (strong, nonatomic) SKSpriteNode *tree;
@property (strong, nonatomic) SKSpriteNode *house;
@property (strong, nonatomic) SKSpriteNode *leaves;
@property (strong, nonatomic) SKAction *houseAction;

@end

@implementation NNKSchoolNode

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        _atlass = [SKTextureAtlas atlasNamed:SCHOOL_FRAMES_ATLAS_NAME];
        _tree = [SKSpriteNode spriteNodeWithTexture:SCHOOL_FRAMES_TEX_SCHOOL_TREE];
        _house = [SKSpriteNode spriteNodeWithTexture:SCHOOL_FRAMES_TEX_SCHOOL_HOUSE];
        _leaves = [SKSpriteNode spriteNodeWithTexture:SCHOOL_FRAMES_TEX_SCHOOL_LEAVES];
        [self addChild:_tree];
        [self addChild:_house];
        [self addChild:_leaves];
        _tree.size = size;
        _house.size = size;
        _leaves.size = size;
        _tree.position = CGPointMake(size.width / 2, size.height / 2);
        _house.position = CGPointMake(size.width / 2, size.height / 2);
        _leaves.position = CGPointMake(size.width / 2, size.height / 2);
        
    }
    
    return self;
}


- (SKAction *)houseAction {
    if (!_houseAction) {
        _houseAction = [self generateHouseAction];
    }
    
    return _houseAction;
}


- (SKAction *)generateHouseAction {
    NSArray *values = @[@{@"duration" : @6, @"x" : @(-23)},
                        @{@"duration" : @6, @"x" : @(51)},
                        @{@"duration" : @6, @"x" : @(-52)},
                        @{@"duration" : @5, @"x" : @(16)},
                        @{@"duration" : @4, @"x" : @(8), @"y" : @18},
                        @{@"duration" : @4, @"x" : @(0), @"y" : @(-7)},
                        @{@"duration" : @9, @"x" : @(10), @"y" : @(-429)},
                        @{@"duration" : @15, @"x" : @(-10), @"y" : @(429)}];
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in values) {
        SKAction *action = [SKAction moveByX:[dict[@"x"] floatValue] * self.house.size.width / 1525
                                           y:[dict[@"y"] floatValue] * self.house.size.height / 1127
                                    duration:[dict[@"duration"] floatValue] / 30.f];
        [actions addObject:action];
    }
    [actions insertObject:[SKAction playSoundFileNamed:@"school.mp3" waitForCompletion:NO] atIndex:actions.count - 2];
    [actions insertObject:[SKAction waitForDuration:1] atIndex:actions.count - 1];
    
    return [SKAction sequence:actions];
}


- (void)runAction {
    [self.house removeAllActions];
    self.house.position = CGPointMake(self.house.size.width / 2, self.house.size.height / 2);
    [self.house runAction:self.houseAction];
}

@end
