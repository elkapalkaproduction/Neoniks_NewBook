//
//  NNKGetableObject.h
//  World
//
//  Created by Andrei Vidrasco on 1/9/16.
//  Copyright © 2016 Andrei Vidrasco. All rights reserved.
//

#import "NNKSpriteNode.h"

typedef NS_ENUM(NSInteger, GetableObjectType) {
    GetableObjectTypeMagicBook,
    GetableObjectTypeBottleOfMagic,
    GetableObjectTypeWrench,
    GetableObjectTypeMagicBallCat,
    GetableObjectTypeMagicBallSheep,
    GetableObjectTypeMagicBallNinja,
};

@interface NNKGetableObject : NNKSpriteNode

- (instancetype)initWithSize:(CGSize)nodeSize
                        type:(GetableObjectType)type;
@property (assign, nonatomic) GetableObjectType type;

@end
