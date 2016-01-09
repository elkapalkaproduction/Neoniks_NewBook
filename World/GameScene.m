//
//  GameScene.m
//  HomeScreen
//
//  Created by Andrei Vidrasco on 9/15/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import "GameScene.h"
#import "ExampleTiledNode.h"
#import "NNKSheepNode.h"
#import "NNKNinjaNode.h"
#import "NNKSkeletNode.h"
#import "NNKDragonNode.h"
#import "NNKGoblinNode.h"
#import "NNKBlueHouseNode.h"
#import "NNKCatNode.h"
#import "DragableSpriteNode.h"
#import "NNKGetableObject.h"

@interface GameScene () <DragableSpriteDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) SKSpriteNode *backgroundNode;

@property (strong, nonatomic) SKSpriteNode *islandNode;
@property (strong, nonatomic) SKSpriteNode *shadowPlay;
@property (strong, nonatomic) SKSpriteNode *schoolOfMagic;
@property (strong, nonatomic) SKSpriteNode *leftTree;
@property (strong, nonatomic) SKSpriteNode *rightTree;
@property (strong, nonatomic) SKSpriteNode *dandelion;
@property (strong, nonatomic) SKSpriteNode *snail;
@property (strong, nonatomic) NNKSheepNode *sheepNode;
@property (strong, nonatomic) NNKNinjaNode *ninjaNode;
@property (strong, nonatomic) NNKSkeletNode *skeletNode;
@property (strong, nonatomic) NNKDragonNode *dragonNode;
@property (strong, nonatomic) NNKGoblinNode *goblinNode;
@property (strong, nonatomic) NNKBlueHouseNode *blueHouseNode;
@property (strong, nonatomic) NNKCatNode *catNode;
@property (strong, nonatomic) UITapGestureRecognizer *touch;
@property (nonatomic, strong) DragableSpriteNode *selectedNode;
@property (nonatomic, strong) NSMutableArray *getableObjects;

@end

@implementation GameScene

#pragma mark -
#pragma mark Initialization

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    [view addGestureRecognizer:self.touch];
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    gestureRecognizer.delegate = self;
    [[self view] addGestureRecognizer:gestureRecognizer];
}


- (instancetype)initWithSize:(CGSize)size {
    if ([super initWithSize:size] != nil) {
        [self initializeAllNodes];
        [self.rootNode addChild:self.backgroundNode];
        [self.rootNode addChild:self.islandNode];
        [self.rootNode addChild:self.shadowPlay];
        [self.rootNode addChild:self.schoolOfMagic];
        [self.rootNode addChild:self.leftTree];
        [self.rootNode addChild:self.rightTree];
        [self.rootNode addChild:self.sheepNode];
        [self.rootNode addChild:self.ninjaNode];
        [self.rootNode addChild:self.skeletNode];
        [self.rootNode addChild:self.dragonNode];
        [self.rootNode addChild:self.goblinNode];
        [self.rootNode addChild:self.dandelion];
        [self.rootNode addChild:self.snail];
        [self.rootNode addChild:self.blueHouseNode];
        [self.rootNode addChild:self.catNode];
        [self.catNode runBackgrounAction];
    }

    return self;
}


- (void)handleTouch:(UITapGestureRecognizer *)tapGestureRecognizer {
    UIScrollView *scrollView;
    for (UIScrollView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            scrollView = view;
        }
    }
    UIView *view =  [scrollView.subviews firstObject];
    CGPoint gesturePoint = [tapGestureRecognizer locationInView:view];
    CGPoint point = CGPointMake(gesturePoint.x, 3600 - gesturePoint.y);
    NSArray *nodes = [self.rootNode nodesAtPoint:point];
    NSMutableSet *set1 = [NSMutableSet setWithArray:nodes];
    NSSet *set2 = [NSSet setWithArray:self.getableObjects];
    [set1 intersectSet: set2];
    NSArray *resultArray = [set1 allObjects];
    if ([resultArray count] > 0) {
        NNKGetableObject *obj = resultArray.firstObject;
        [self.gameSceneDelegate didPressGetableObjectWithType:obj.type];
    } else if ([nodes containsObject:self.islandNode]) {
        [self.gameSceneDelegate didPressIslandInGameScene];
    } else if ([nodes containsObject:self.shadowPlay]) {
        [self.gameSceneDelegate didPressShadowInGameScene];
    } else if ([nodes containsObject:self.schoolOfMagic]) {
        [self.gameSceneDelegate didPressSchoolInGameScene];
    } else if ([nodes containsObject:self.dandelion]) {
        [self.gameSceneDelegate didPressDandelionInGameScene];
    } else if ([nodes containsObject:self.snail]) {
        [self.gameSceneDelegate didPressSnailInGameScene];
    } else if ([nodes containsObject:self.sheepNode]) {
        [self.sheepNode runAction];
        [self.gameSceneDelegate didPressSheepInGameScene];
    } else if ([nodes containsObject:self.ninjaNode]) {
        [self.ninjaNode runAction];
        [self.gameSceneDelegate didPressNinjaInGameScene];
    } else if ([nodes containsObject:self.skeletNode]) {
        [self.skeletNode runAction];
        [self.gameSceneDelegate didPressSkeletInGameScene];
    } else if ([nodes containsObject:self.dragonNode]) {
        [self.dragonNode runAction];
        [self.gameSceneDelegate didPressDragonInGameScene];
    } else if ([nodes containsObject:self.goblinNode]) {
        [self.goblinNode runAction];
        [self.gameSceneDelegate didPressGoblinInGameScene];
    } else if ([nodes containsObject:self.catNode]) {
        [self.catNode runAction];
        [self.gameSceneDelegate didPressCatInGameScene];
    } else if ([nodes containsObject:self.blueHouseNode]) {
        if ([nodes containsObject:self.blueHouseNode.player]) {
            [self.gameSceneDelegate didPressPlayerInGameScene];
        } else if ([nodes containsObject:self.blueHouseNode.extinguisher]) {
            [self.gameSceneDelegate didPressExtinguisherInGameScene];
        } else if ([nodes containsObject:self.blueHouseNode.door]) {
            [self.blueHouseNode runAction];
            [self.gameSceneDelegate didPressBlueHouseInGameScene];
        }
    }

}


- (void)initializeAllNodes {
    self.backgroundNode = [[[ExampleTiledNode alloc] init] load];
    self.backgroundNode.anchorPoint = CGPointZero;
    self.backgroundNode.position = CGPointZero;
    self.rootNode.size = self.backgroundNode.size;
    self.islandNode = [self nodeWithImageName:@"island" position:CGPointMake(835, 544)];
    self.shadowPlay = [self nodeWithImageName:NSLocalizedString(@"shadow_play_image", nil) position:CGPointMake(2155, 719)];
    self.schoolOfMagic = [self nodeWithImageName:NSLocalizedString(@"school_of_magic_image", nil) position:CGPointMake(0, 789)];
    self.leftTree = [self nodeWithImageName:@"tree_left" position:CGPointMake(0, 1473)];
    self.rightTree = [self nodeWithImageName:@"tree_right" position:CGPointMake(2295, 335)];
    self.dandelion = [self nodeWithImageName:@"dandelion" position:CGPointMake(415, 2546)];
    self.snail = [self nodeWithImageName:@"snail" position:CGPointMake(1115, 2237)];
    self.sheepNode = [self nodeWithClass:[NNKSheepNode class] rect:CGRectMake(718, 1116, 300, 300)];
    self.ninjaNode = [self nodeWithClass:[NNKNinjaNode class] rect:CGRectMake(307, 580, 203, 678)];
    self.skeletNode = [self nodeWithClass:[NNKSkeletNode class] rect:CGRectMake(1075, 2691, 400, 330)];
    self.dragonNode = [self nodeWithClass:[NNKDragonNode class] rect:CGRectMake(-784, 3333, 1640, 556)];
    self.goblinNode = [self nodeWithClass:[NNKGoblinNode class] rect:CGRectMake(2160, 3150, 212, 412)];
    self.blueHouseNode = [self nodeWithClass:[NNKBlueHouseNode class] rect:CGRectMake(912, 666, 676, 1105)];
    self.catNode = [self nodeWithClass:[NNKCatNode class] rect:CGRectMake(2000, 0, 1000, 600)];
}


- (SKSpriteNode *)nodeWithImageName:(NSString *)imageName position:(CGPoint)position {
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    node.position = [self positionFromPositon:position nodeSize:[self updatedSizeFromSize:node.size] rootNodeSize:self.rootNode.size];

    return node;
}


- (CGPoint)positionFromPositon:(CGPoint)position
                      nodeSize:(CGSize)nodeSize
                  rootNodeSize:(CGSize)rootNodeSize {
    return CGPointMake(position.x * rootNodeSize.width / 3000 + nodeSize.width / 2,
                       rootNodeSize.height * (1 - position.y * (rootNodeSize.height / 3600) / rootNodeSize.height) - nodeSize.height / 2);
}


- (CGSize)updatedSizeFromSize:(CGSize)size {
    CGFloat width = size.width * self.rootNode.frame.size.width / 3000;
    CGFloat height = width * size.height / size.width;

    return CGSizeMake(width, height);
}


- (id)nodeWithClass:(Class)className
               rect:(CGRect)rect {
    SKSpriteNode *sheepNode = [[className alloc] initWithSize:rect.size];
    sheepNode.position = [self positionFromPositon:rect.origin
                                          nodeSize:sheepNode.size
                                      rootNodeSize:self.rootNode.size];

    return sheepNode;
}


- (CGFloat)minimumZoomScale {
    return self.size.width / self.rootNode.size.width;
}


- (CGFloat)initialZoomScale {
    return [self minimumZoomScale];
}


- (CGFloat)maximumZoomScale {
    return [self minimumZoomScale];
}


- (UITapGestureRecognizer *)touch {
    if (!_touch) {
        _touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouch:)];
        _touch.numberOfTouchesRequired = 1;
    }

    return _touch;
}


- (void)hideBook {
    [self.dragonNode removeBook];
}


- (void)hideSnail {
    [self.snail removeFromParent];
}


- (void)hideSword {
    [self.skeletNode showLastFrame];
}


- (void)hideWrench {
    [self.goblinNode removeWrench];
}


- (void)hideDandelion {
    [self.dandelion removeFromParent];
}


- (void)hideExtinguisher {
    [self.blueHouseNode hideExtinguisher];
}


- (void)closeDoor {
    [self.blueHouseNode closeDoor];
}


- (void)changeLanguage {
    [self.blueHouseNode changeLanguage:[NSBundle isRussian]];
    self.shadowPlay.texture = [SKTexture textureWithImageNamed:NSLocalizedString(@"shadow_play_image", nil)];
    self.schoolOfMagic.texture = [SKTexture textureWithImageNamed:NSLocalizedString(@"school_of_magic_image", nil)];
}


- (void)selectNodeForTouch:(CGPoint)touchLocation {
    NSArray *touchedNode = [self nodesAtPoint:touchLocation];
    [touchedNode enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DragableSpriteNode class]]) {
            _selectedNode = obj;
            *stop = YES;
        }
    }];
}


- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [self convertPointFromView:touchLocation];
        [self selectNodeForTouch:touchLocation];
    }
    if ([self.selectedNode isKindOfClass:[DragableSpriteNode class]]) {
        [self.selectedNode move:recognizer];
    }
}


- (void)removeDragableObject {
    [self.selectedNode removeFromParent];
}


- (BOOL)correctTargetPositionForButton:(DragableSpriteNode *)button {
    NSArray *nodes = [self.rootNode nodesAtPoint:button.position];

    switch (button.fullType) {
        case InventaryBarIconTypeMagicBallNinja:
            return [nodes containsObject:self.ninjaNode];
        case InventaryBarIconTypeMagicBallCat:
            return [nodes containsObject:self.catNode];
        case InventaryBarIconTypeWrench:
            return [nodes containsObject:self.goblinNode];
        case InventaryBarIconTypeMagicBallSheep:
            return [nodes containsObject:self.sheepNode];
        case InventaryBarIconTypeMagicBook:
            return [nodes containsObject:self.dragonNode];
        default:
            break;
    }

    return YES;
}


- (void)putButtonOnRightPosition:(DragableSpriteNode *)button {
    [self.gameSceneDelegate putButtonOnRightPositionWithType:button.fullType
                                                  hiddenType:button.hiddenType];
}


- (void)didStartDragButton:(DragableSpriteNode *)button {
    [self.gameSceneDelegate didStartMoveDragableNode];
}


- (void)createObjectWithImage:(UIImage *)image
                       ofType:(InventaryBarIconType)type
                   hiddenType:(InventaryBarIconType)hiddenType
                     position:(CGPoint)position {
    [self removeDragableObject];
    DragableSpriteNode *dragable = [DragableSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:image]];
    dragable.fullType = type;
    dragable.hiddenType = hiddenType;
    dragable.delegate = self;
    dragable.size = CGSizeMake(image.size.width * 3000 / self.rootNode.size.width, image.size.height * 3600 / self.rootNode.size.height);
    dragable.position = CGPointMake(position.x, 3600 - position.y);
    self.selectedNode = dragable;
    [self.rootNode addChild:self.selectedNode];
}


- (void)showGetableObjectOfType:(GetableObjectType)type {
    SKSpriteNode *node = [[NNKGetableObject alloc] initWithSize:CGSizeMake(274, 274)
                                                           type:type];
    [self hideObjectOfType:type];
    SKSpriteNode *nearObject;
    CGFloat factorX = 1;
    CGFloat factorY = 0;
    switch (type) {
        case GetableObjectTypeBottleOfMagic:
            break;
        case GetableObjectTypeMagicBook:
            nearObject = self.dragonNode;
            factorX = 0;
            factorY = 1;
            break;
        case GetableObjectTypeMagicBallCat:
            nearObject = self.catNode;
            factorX = -1;
            factorY = -0.85;
            break;
        case GetableObjectTypeMagicBallNinja:
            nearObject = self.ninjaNode;
            break;
        case GetableObjectTypeMagicBallSheep:
            nearObject = self.sheepNode;
            break;
        case GetableObjectTypeWrench:
            nearObject = self.goblinNode;
            factorX = -1;
            break;
        default: break;
    }
    node.position = CGPointMake(nearObject.position.x + factorX * (nearObject.size.width + node.size.width) / 2,
                                nearObject.position.y + factorY * (nearObject.size.height + node.size.height) / 2);
    [self.rootNode addChild:node];
    [self.getableObjects addObject:node];
}


- (void)hideObjectOfType:(GetableObjectType)type {
    NSIndexSet *indexSet = [self.getableObjects indexesOfObjectsPassingTest:^BOOL(NNKGetableObject *obj, NSUInteger idx, BOOL *stop) {
        return obj.type == type;
    }];
    for (NNKGetableObject *obj in [self.getableObjects objectsAtIndexes:indexSet]) {
        [obj removeFromParent];
    }
    [self.getableObjects removeObjectsAtIndexes:indexSet];
}


- (NSMutableArray *)getableObjects {
    if (!_getableObjects) {
        _getableObjects = [[NSMutableArray alloc] init];
    }
    
    return _getableObjects;
}

@end
