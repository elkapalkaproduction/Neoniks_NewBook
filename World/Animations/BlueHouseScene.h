//
//  GameScene.h
//  cat
//

//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "NNKBlueHouseNode.h"

@protocol BlueHouseProtocol <NSObject>

- (void)didTouchExtinguisher;
- (void)didTouchPlayer;

@end

@interface BlueHouseScene : SKScene

@property (assign, nonatomic) BOOL hideExtinguisher;
@property (assign, nonatomic) BlueHouseLanguage language;
- (void)closeDoor;
@property (weak, nonatomic) id<BlueHouseProtocol> blueHouseDelegate;
@property (copy, nonatomic) BlueHouseCompletion completion;

@end
