//
//  VelocityCreation.h
//  cat
//
//  Created by Andrei Vidrasco on 8/29/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface VelocityCreation : NSObject

+ (SKPhysicsBody *)createPhysicsBodyWithFrame:(CGRect)physicsBodyFrame
                                     velocity:(CGVector)velocity;

+ (SKPhysicsBody *)createBackgroundPhysicsBodyForWithFrame:(CGRect)frame;

@end
