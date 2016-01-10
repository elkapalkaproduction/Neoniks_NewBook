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

@interface NNKBlueHouseNode : NNKSpriteNode

- (instancetype)initWithSize:(CGSize)size showExtinguisher:(BOOL)showExtinguisher;

@property (copy, nonatomic) BlueHouseCompletion completion;
- (void)hideExtinguisher;
- (void)showExtinguisher;
- (void)changeLanguage:(BlueHouseLanguage)language;
- (void)closeDoor;

@property (strong, nonatomic) SKSpriteNode *player;
@property (strong, nonatomic) SKSpriteNode *extinguisher;
@property (strong, nonatomic) SKSpriteNode *door;

@end
