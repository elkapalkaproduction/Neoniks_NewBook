//
//  NNKNinjaNode.h
//  cat
//
//  Created by Andrei Vidrasco on 9/13/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CustomNodeProtocol.h"

typedef void (^NinjaCompletionBlock)();

@interface NNKNinjaNode : SKNode <CustomNodeProtocol>

@property (copy, nonatomic) NinjaCompletionBlock completionBlock;

@end
