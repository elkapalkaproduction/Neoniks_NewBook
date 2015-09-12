//
//  VelocityCreation.m
//  cat
//
//  Created by Andrei Vidrasco on 8/29/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import "VelocityCreation.h"

static const uint32_t ballCategory  = 0x1 << 0;
static const uint32_t cornerCategory = 0x1 << 1;

@implementation VelocityCreation

+ (SKPhysicsBody *)createPhysicsBodyWithFrame:(CGRect)physicsBodyFrame
                                     velocity:(CGVector)velocity {
    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:physicsBodyFrame.size
                                                                 center:physicsBodyFrame.origin];
    physicsBody.categoryBitMask = ballCategory;
    physicsBody.contactTestBitMask = cornerCategory;
    physicsBody.linearDamping = 0.0;
    physicsBody.angularDamping = 0.0;
    physicsBody.restitution = 1.0;
    physicsBody.dynamic = YES;
    physicsBody.friction = 0.0;
    physicsBody.allowsRotation = NO;
    physicsBody.velocity = velocity;
    
    return physicsBody;
}


+ (SKPhysicsBody *)createBackgroundPhysicsBodyForWithFrame:(CGRect)frame {
    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:frame];
    physicsBody.categoryBitMask = cornerCategory;
    physicsBody.dynamic = NO;
    physicsBody.friction = 0.0;
    physicsBody.restitution = 1.0;
    
    return physicsBody;
}

@end
