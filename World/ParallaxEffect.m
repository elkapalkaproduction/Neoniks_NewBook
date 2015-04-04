//
//  ParallaxEffectController.m
//  Jabba
//
//  Created by Andrei Vidrasco on 3/30/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import "ParallaxEffect.h"

@implementation ParallaxEffect

+ (void)applyMotionEffectsOnView:(UIView *)view {
    if (!NSClassFromString(@"UIInterpolatingMotionEffect")) return;
    CGFloat motionEffectExtent = 10.0;
    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-motionEffectExtent);
    horizontalEffect.maximumRelativeValue = @( motionEffectExtent);
    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-motionEffectExtent);
    verticalEffect.maximumRelativeValue = @( motionEffectExtent);
    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];
    [view addMotionEffect:motionEffectGroup];
}

@end
