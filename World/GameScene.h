//
//  GameScene.h
//  HomeScreen
//

//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <PIOSpriteKit.h>
#import "SettingsBarIconViewController.h"
#import "NNKGetableObject.h"

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
- (void)didPressGetableObjectWithType:(GetableObjectType)type;
- (void)didPressLampInGameScene;

- (BOOL)canTapAnything;

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

- (void)showWrench;
- (void)showBook;
- (void)showSword;
- (void)showDandelion;
- (void)showSnail;
- (void)showExtinguisher;

- (void)closeDoor;
- (void)changeLanguage;

- (void)createObjectWithImage:(UIImage *)image
                       ofType:(InventaryBarIconType)type
                   hiddenType:(InventaryBarIconType)hiddenType
                     position:(CGPoint)position;
- (void)removeDragableObject;

- (void)showGetableObjectOfType:(GetableObjectType)type;
- (void)hideObjectOfType:(GetableObjectType)type;

@end
