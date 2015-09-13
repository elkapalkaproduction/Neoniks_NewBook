//
//  GameScene.m
//  cat
//
//  Created by Andrei Vidrasco on 8/28/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import "BlueHouseScene.h"
#import "NNKJayNode.h"
#import "NNKCatNode.h"
#import "NNKNinjaNode.h"
#import "NNKBlueHouseNode.h"

@interface BlueHouseScene ()

@property (strong, nonatomic) NNKBlueHouseNode *houseNode;

@end

@implementation BlueHouseScene

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [UIColor clearColor];
    self.houseNode = [[NNKBlueHouseNode alloc] initWithSize:self.size showExtinguisher:!self.hideExtinguisher];
    [self addChild:self.houseNode];
    [self.houseNode changeLanguage:self.language];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    NSArray *nodes = [self nodesAtPoint:positionInScene];
    if ([nodes containsObject:self.houseNode.door]) {
        [self.houseNode runAction];
    } else if ([nodes containsObject:self.houseNode.extinguisher]){
        [self.blueHouseDelegate didTouchExtinguisher];
    } else if ([nodes containsObject:self.houseNode.player]) {
        [self.blueHouseDelegate didTouchPlayer];
    }
}


- (void)closeDoor {
    [self.houseNode closeDoor];
}


- (void)setHideExtinguisher:(BOOL)hideExtinguisher {
    _hideExtinguisher = hideExtinguisher;
    [self.houseNode hideExtinguisher];
}


- (void)setLanguage:(BlueHouseLanguage)language {
    _language = language;
    [self.houseNode changeLanguage:language];
}

@end
