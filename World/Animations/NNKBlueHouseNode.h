//
//  NNKBlueHouseNode.h
//  cat
//
//  Created by Andrei Vidrasco on 9/13/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger, BlueHouseLanguage) {
    BlueHouseLanguageEnglish,
    BlueHouseLanguageRussian,
};

typedef void (^BlueHouseCompletion)();

@interface NNKBlueHouseNode : SKNode

- (instancetype)initWithSize:(CGSize)size showExtinguisher:(BOOL)showExtinguisher;
- (void)runAction;
@property (copy, nonatomic) BlueHouseCompletion completion;
- (void)hideExtinguisher;
- (void)changeLanguage:(BlueHouseLanguage)language;
- (void)closeDoor;

@property (strong, nonatomic) SKNode *player;
@property (strong, nonatomic) SKNode *extinguisher;
@property (strong, nonatomic) SKNode *door;

@end
