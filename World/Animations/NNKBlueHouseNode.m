//
//  NNKBlueHouseNode.m
//  cat
//
//  Created by Andrei Vidrasco on 9/13/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import "NNKBlueHouseNode.h"
#import "blue_house_anim.h"

@interface NNKBlueHouseNode ()

@property (strong, nonatomic) SKTextureAtlas *atlass;
@property (strong, nonatomic) SKNode *witch;
@property (strong, nonatomic) SKAction *sequence;
@property (strong, nonatomic) SKSpriteNode *language;
@property (assign, nonatomic) CGPoint originalDoorPosition;

@end

@implementation NNKBlueHouseNode

- (instancetype)initWithSize:(CGSize)size {
    NNKBlueHouseNode *node = [self initWithSize:size showExtinguisher:YES];
    [node changeLanguage:BlueHouseLanguageEnglish];
    
    return node;
}


- (instancetype)initWithSize:(CGSize)size showExtinguisher:(BOOL)showExtinguisher {
    self = [super init];
    if (self) {
        self.size = size;
        _atlass = [SKTextureAtlas atlasNamed:BLUE_HOUSE_ANIM_ATLAS_NAME];
        [self addChild:[self nodeWithRect:CGRectMake(218, 620, 180, 253) sprite:BLUE_HOUSE_ANIM_TEX_BLUE_HOUSE_YELLOW_WALL]];
        if (showExtinguisher) {
            _extinguisher = [self nodeWithRect:CGRectMake(1, 671, 198, 180) sprite:BLUE_HOUSE_ANIM_TEX_BLUE_HOUSE_EXTINGUISHER];
            [self addChild:_extinguisher];
        }
        [self addChild:self.witch];
        _door = [self nodeWithRect:CGRectMake(218, 612, 216, 271) sprite:BLUE_HOUSE_ANIM_TEX_BLUE_HOUSE_DOOR];
        [self addChild:_door];
        _originalDoorPosition = _door.position;
        [self addChild:[self nodeWithRect:CGRectMake(67, 526, 543, 577) sprite:BLUE_HOUSE_ANIM_TEX_BLUE_HOUSE_BOTTOM_PART]];
        _player = [self nodeWithRect:CGRectMake(476, 553, 169, 195) sprite:BLUE_HOUSE_ANIM_TEX_BLUE_HOUSE_PLAYER];
        [self addChild:_player];
        [self addChild:[self nodeWithRect:CGRectMake(1, 266, 675, 405) sprite:BLUE_HOUSE_ANIM_TEX_BLUE_HOUSE_TOP_PART]];
        _language = [self nodeWithRect:CGRectMake(46, 0, 584, 410) sprite:BLUE_HOUSE_ANIM_TEX_BLUE_HOUSE_BANNER_ENG];
        [self addChild:_language];
    }
    
    return self;
}


- (void)rectFromSize:(CGSize)size
              origin:(CGPoint)origin
              inNode:(SKSpriteNode *)node {
    node.size = CGSizeMake((size.width / 676) * self.size.width, (size.height / 1105) * self.size.height);
    node.position = CGPointMake(origin.x - node.size.width / 2, origin.y - node.size.height / 2);
}


- (SKSpriteNode *)nodeWithRect:(CGRect)rect sprite:(SKTexture *)sprite {
    SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:sprite];
    spriteNode.size = CGSizeMake((rect.size.width / 676) * self.size.width, (rect.size.height / 1105) * self.size.height);
    spriteNode.position = CGPointMake((rect.origin.x + rect.size.width / 2) * (self.size.width / 676),
                                      self.size.height - (rect.origin.y + rect.size.height / 2) * (self.size.height / 1105));

    return spriteNode;
}


- (SKNode *)witch {
    if (!_witch) {
        _witch = [self nodeWithRect:CGRectMake(218, 620, 214, 263) sprite:BLUE_HOUSE_ANIM_TEX_BLUE_HOUSE_WITCH_00];
    }
    
    
    return _witch;
}


- (SKAction *)sequence {
    if (!_sequence) {
        _sequence = [SKAction animateWithTextures:BLUE_HOUSE_ANIM_ANIM_BLUE_HOUSE_WITCH
                                     timePerFrame:1.f / 15.f];
    }
    
    return _sequence;
}


- (void)runAction {

    if (self.completion) self.completion();
    SKAction *action = [SKAction moveToY:self.size.height / 2 duration:0.2];
    [self.door runAction:action completion:^{
        [self.witch runAction:self.sequence];
    }];
}


- (void)closeDoor {
    [self.door runAction:[SKAction moveToY:self.originalDoorPosition.y duration:0.2]];
}


- (void)changeLanguage:(BlueHouseLanguage)language {
    switch (language) {
        case BlueHouseLanguageEnglish:
            self.language.texture = BLUE_HOUSE_ANIM_TEX_BLUE_HOUSE_BANNER_ENG;
            break;
        case BlueHouseLanguageRussian:
            self.language.texture = BLUE_HOUSE_ANIM_TEX_BLUE_HOUSE_BANNER_RUS;
            break;
        default:
            break;
    }
}


- (void)hideExtinguisher {
    [self.extinguisher removeFromParent];
}

@end
