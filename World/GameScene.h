//
//  GameScene.h
//  HomeScreen
//

//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <PIOSpriteKit.h>
#import "SettingsBarIconViewController.h"

@protocol GameSceneDelegate <NSObject>

- (void)didPressIslandInGameScene;
- (void)didPressShadowInGameScene;
- (void)didPressSchoolInGameScene;
- (void)didPressDandelionInGameScene;
- (void)didPressSnailInGameScene;
- (void)didPressSheepInGameScene;
- (void)didPressNinjaInGameScene;
- (void)didPressSkeletInGameScene;
- (void)didPressDragonInGameScene;
- (void)didPressGoblinInGameScene;
- (void)didPressPlayerInGameScene;
- (void)didPressExtinguisherInGameScene;
- (void)didPressBlueHouseInGameScene;
- (void)didPressCatInGameScene;
- (void)putButtonOnRightPositionWithType:(InventaryBarIconType)fullType
                              hiddenType:(InventaryBarIconType)hiddenType;
- (void)didStartMoveDragableNode;

@end

@interface GameScene : PIOScrollScene


@property (weak, nonatomic) UIView *contentView;
@property (weak, nonatomic) id<GameSceneDelegate> gameSceneDelegate;

- (void)hideWrench;
- (void)hideBook;
- (void)hideSword;
- (void)hideDandelion;
- (void)hideSnail;
- (void)hideExtinguisher;
- (void)closeDoor;
- (void)changeLanguage;

- (void)createObjectWithImage:(UIImage *)image
                       ofType:(InventaryBarIconType)type
                   hiddenType:(InventaryBarIconType)hiddenType
                     position:(CGPoint)position;
- (void)removeDragableObject;

@end
