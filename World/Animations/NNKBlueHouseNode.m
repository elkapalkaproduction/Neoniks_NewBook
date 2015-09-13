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

@property (assign, nonatomic) CGSize size;
@property (strong, nonatomic) SKTextureAtlas *atlass;
@property (strong, nonatomic) SKNode *witch;
@property (strong, nonatomic) SKAction *sequence;
@property (strong, nonatomic) SKNode *language;

@end

@implementation NNKBlueHouseNode

- (instancetype)initWithSize:(CGSize)size showExtinguisher:(BOOL)showExtinguisher {
    self = [super init];
    if (self) {
        _size = size;
        _atlass = [SKTextureAtlas atlasNamed:BLUE_HOUSE_ANIM_ATLAS_NAME];
        [self addChild:[self nodeWithSize:size sprite:BLUE_HOUSE_ANIM_TEX_BLUE_HOUSE_YELLOW_WALL]];
        if (showExtinguisher) {
            _extinguisher = [self nodeWithSize:size sprite:BLUE_HOUSE_ANIM_TEX_BLUE_HOUSE_EXTINGUISHER];
            [self addChild:_extinguisher];
        }
        [self addChild:self.witch];
        _door = [self nodeWithSize:size sprite:BLUE_HOUSE_ANIM_TEX_BLUE_HOUSE_DOOR];
        [self addChild:_door];
        [self addChild:[self nodeWithSize:size sprite:BLUE_HOUSE_ANIM_TEX_BLUE_HOUSE_BOTTOM_PART]];
        _player = [self nodeWithSize:size sprite:BLUE_HOUSE_ANIM_TEX_BLUE_HOUSE_PLAYER];
        [self addChild:_player];
        [self addChild:[self nodeWithSize:size sprite:BLUE_HOUSE_ANIM_TEX_BLUE_HOUSE_TOP_PART]];
    }
    
    return self;
}


- (SKSpriteNode *)nodeWithSize:(CGSize)size sprite:(SKTexture *)sprite {
    SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:sprite];
    spriteNode.size = size;
    spriteNode.position = CGPointMake(size.width / 2, size.height / 2);
    
    return spriteNode;
}


- (SKNode *)witch {
    if (!_witch) {
        _witch = [self nodeWithSize:self.size sprite:BLUE_HOUSE_ANIM_TEX_BLUE_HOUSE_WITCH_00];
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
    SKAction *action = [SKAction moveToY:self.size.height * 0.65 duration:0.2];
    [self.door runAction:action completion:^{
        [self.witch runAction:self.sequence];
    }];
}


- (void)closeDoor {
    [self.door runAction:[SKAction moveToY:self.size.height / 2 duration:0.2]];
}


- (void)changeLanguage:(BlueHouseLanguage)language {
    [self.language removeFromParent];
    switch (language) {
        case BlueHouseLanguageEnglish:
            self.language = [self nodeWithSize:self.size sprite:BLUE_HOUSE_ANIM_TEX_BLUE_HOUSE_BANNER_ENG];
            break;
        case BlueHouseLanguageRussian:
            self.language = [self nodeWithSize:self.size sprite:BLUE_HOUSE_ANIM_TEX_BLUE_HOUSE_BANNER_RUS];
            break;
        default:
            break;
    }
    [self addChild:self.language];
}


- (void)hideExtinguisher {
    [self.extinguisher removeFromParent];
}

@end
