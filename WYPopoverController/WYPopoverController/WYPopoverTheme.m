//
//  WYPopoverTheme.m
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WYPopoverTheme.h"
#import "UIColor+WYPopover.h"

@interface WYPopoverTheme ()

@end

@implementation WYPopoverTheme

+ (id)theme {    
    return [WYPopoverTheme themeForIOS7];
}


+ (id)themeForIOS6 {
    WYPopoverTheme *result = [[WYPopoverTheme alloc] init];
    
    result.usesRoundedArrow = NO;
    result.dimsBackgroundViewsTintColor = YES;
    result.tintColor = [UIColor colorWithRed:55. / 255. green:63. / 255. blue:71. / 255. alpha:1.0];
    result.outerStrokeColor = nil;
    result.innerStrokeColor = nil;
    result.fillTopColor = result.tintColor;
    result.fillBottomColor = [result.tintColor wy_colorByDarken:0.4];
    result.glossShadowColor = nil;
    result.glossShadowOffset = CGSizeMake(0, 1.5);
    result.glossShadowBlurRadius = 0;
    result.borderWidth = 6;
    result.arrowBase = 42;
    result.arrowHeight = 18;
    result.outerShadowColor = [UIColor colorWithWhite:0 alpha:0.75];
    result.outerShadowBlurRadius = 8;
    result.outerShadowOffset = CGSizeMake(0, 2);
    result.outerCornerRadius = 8;
    result.minOuterCornerRadius = 0;
    result.innerShadowColor = [UIColor colorWithWhite:0 alpha:0.75];
    result.innerShadowBlurRadius = 2;
    result.innerShadowOffset = CGSizeMake(0, 1);
    result.innerCornerRadius = 6;
    result.viewContentInsets = UIEdgeInsetsMake(3, 0, 0, 0);
    result.overlayColor = [UIColor clearColor];
    result.preferredAlpha = 1.0f;
    
    return result;
}


+ (id)themeForIOS7 {
    WYPopoverTheme *result = [[WYPopoverTheme alloc] init];
    
    result.usesRoundedArrow = YES;
    result.dimsBackgroundViewsTintColor = YES;
    result.tintColor = [UIColor colorWithRed:244. / 255. green:244. / 255. blue:244. / 255. alpha:1.0];
    result.outerStrokeColor = [UIColor clearColor];
    result.innerStrokeColor = [UIColor clearColor];
    result.fillTopColor = nil;
    result.fillBottomColor = nil;
    result.glossShadowColor = nil;
    result.glossShadowOffset = CGSizeZero;
    result.glossShadowBlurRadius = 0;
    result.borderWidth = 0;
    result.arrowBase = 25;
    result.arrowHeight = 13;
    result.outerShadowColor = [UIColor clearColor];
    result.outerShadowBlurRadius = 0;
    result.outerShadowOffset = CGSizeZero;
    result.outerCornerRadius = 5;
    result.minOuterCornerRadius = 0;
    result.innerShadowColor = [UIColor clearColor];
    result.innerShadowBlurRadius = 0;
    result.innerShadowOffset = CGSizeZero;
    result.innerCornerRadius = 0;
    result.viewContentInsets = UIEdgeInsetsZero;
    result.overlayColor = [UIColor colorWithWhite:0 alpha:0.15];
    result.preferredAlpha = 1.0f;
    
    return result;
}


- (NSUInteger)innerCornerRadius {
    float result = _innerCornerRadius;
    
    if (_borderWidth == 0) {
        result = 0;
        
        if (_outerCornerRadius > 0) {
            result = _outerCornerRadius;
        }
    }
    
    return result;
}


- (CGSize)outerShadowOffset {
    CGSize result = _outerShadowOffset;
    
    result.width = MIN(result.width, _outerShadowBlurRadius);
    result.height = MIN(result.height, _outerShadowBlurRadius);
    
    return result;
}


- (UIColor *)innerStrokeColor {
    return _innerStrokeColor ? : [self.fillTopColor wy_colorByDarken:0.6];
}


- (UIColor *)outerStrokeColor {
    return _outerStrokeColor ? : [self.fillTopColor wy_colorByDarken:0.6];
}


- (UIColor *)glossShadowColor {
    return _glossShadowColor ? : [self.fillTopColor wy_colorByLighten:0.2];
}


- (UIColor *)fillTopColor {
    return _fillTopColor ? : _tintColor;
}


- (UIColor *)fillBottomColor {
    return _fillBottomColor ? : self.fillTopColor;
}


- (NSArray *)observableKeypaths {
    return [NSArray arrayWithObjects:@"tintColor", @"outerStrokeColor", @"innerStrokeColor", @"fillTopColor", @"fillBottomColor", @"glossShadowColor", @"glossShadowOffset", @"glossShadowBlurRadius", @"borderWidth", @"arrowBase", @"arrowHeight", @"outerShadowColor", @"outerShadowBlurRadius", @"outerShadowOffset", @"outerCornerRadius", @"innerShadowColor", @"innerShadowBlurRadius", @"innerShadowOffset", @"innerCornerRadius", @"viewContentInsets", @"overlayColor", nil];
}

@end
