//
//  WYPopoverEnums.h
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, WYPopoverArrowDirection) {
    WYPopoverArrowDirectionUp = 1UL << 0,
    WYPopoverArrowDirectionDown = 1UL << 1,
    WYPopoverArrowDirectionLeft = 1UL << 2,
    WYPopoverArrowDirectionRight = 1UL << 3,
    WYPopoverArrowDirectionNone = 1UL << 4,
    WYPopoverArrowDirectionAny = WYPopoverArrowDirectionUp | WYPopoverArrowDirectionDown | WYPopoverArrowDirectionLeft | WYPopoverArrowDirectionRight,
    WYPopoverArrowDirectionUnknown = NSUIntegerMax
};

typedef NS_OPTIONS(NSUInteger, WYPopoverAnimationOptions) {
    WYPopoverAnimationOptionFade = 1UL << 0,            // default
    WYPopoverAnimationOptionScale = 1UL << 1,
    WYPopoverAnimationOptionFadeWithScale = WYPopoverAnimationOptionFade | WYPopoverAnimationOptionScale
};
