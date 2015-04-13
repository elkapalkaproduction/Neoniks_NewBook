//
//  WYPopoverArea.m
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WYPopoverArea.h"

@implementation WYPopoverArea

- (NSString *)description {
    const NSDictionary *directionMap = @{@(WYPopoverArrowDirectionUp)    : @"UP",
                                         @(WYPopoverArrowDirectionDown)  : @"DOWN",
                                         @(WYPopoverArrowDirectionLeft)  : @"LEFT",
                                         @(WYPopoverArrowDirectionRight) : @"RIGHT",
                                         @(WYPopoverArrowDirectionNone)  : @"NONE"};
    NSString *direction = directionMap[@(_arrowDirection)];
    
    return [NSString stringWithFormat:@"%@ [ %f x %f ]", direction, _areaSize.width, _areaSize.height];
}


- (float)value {
    float result = 0;
    
    if (_areaSize.width > 0 && _areaSize.height > 0) {
        float w1 = ceilf(_areaSize.width / 10.0);
        float h1 = ceilf(_areaSize.height / 10.0);
        
        result = (w1 * h1);
    }
    
    return result;
}

@end
