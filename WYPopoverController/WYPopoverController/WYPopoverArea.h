//
//  WYPopoverArea.h
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYPopoverEnums.h"
@import CoreGraphics;

@interface WYPopoverArea : NSObject

@property (nonatomic, assign) WYPopoverArrowDirection arrowDirection;
@property (nonatomic, assign) CGSize areaSize;
@property (nonatomic, assign, readonly) float value;

@end
