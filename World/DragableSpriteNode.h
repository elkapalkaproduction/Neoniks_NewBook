//
//  DragableSpriteNode.h
//  World
//
//  Created by Andrei Vidrasco on 9/16/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SettingsBarIconViewController.h"

@class DragableSpriteNode;

@protocol DragableSpriteDelegate <NSObject>

- (BOOL)correctTargetPositionForButton:(DragableSpriteNode *)button;
@optional
- (void)putButtonOnRightPosition:(DragableSpriteNode *)button;
- (void)didStartDragButton:(DragableSpriteNode *)button;

@end

@interface DragableSpriteNode : SKSpriteNode

@property (assign, nonatomic) CGRect correctRect;
@property (weak, nonatomic) id <DragableSpriteDelegate> delegate;
@property (assign, nonatomic) InventaryBarIconType hiddenType;
@property (assign, nonatomic) InventaryBarIconType fullType;

- (void)move:(UIPanGestureRecognizer *)sender;

@end
