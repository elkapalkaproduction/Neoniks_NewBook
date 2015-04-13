//
//  WYPopoverBackgroundInnerView.m
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WYPopoverBackgroundInnerView.h"

@implementation WYPopoverBackgroundInnerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Gradient Declarations
    NSArray *fillGradientColors = [NSArray arrayWithObjects:
                                   (id)_gradientTopColor.CGColor,
                                   (id)_gradientBottomColor.CGColor, nil];
    
    CGFloat fillGradientLocations[2] = {0, 1};
    
    CGGradientRef fillGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)fillGradientColors, fillGradientLocations);
    
    //// innerRect Drawing
    float barHeight = (_wantsDefaultContentAppearance == NO) ? _navigationBarHeight : 0;
    float cornerRadius = (_wantsDefaultContentAppearance == NO) ? _innerCornerRadius : 0;
    
    CGRect innerRect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + barHeight, CGRectGetWidth(rect), CGRectGetHeight(rect) - barHeight);
    
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:innerRect];
    
    UIBezierPath *roundedRectPath = [UIBezierPath bezierPathWithRoundedRect:innerRect cornerRadius:cornerRadius + 1];
    
    if (_wantsDefaultContentAppearance == NO && _borderWidth > 0) {
        CGContextSaveGState(context);
        {
            [rectPath appendPath:roundedRectPath];
            rectPath.usesEvenOddFillRule = YES;
            [rectPath addClip];
            
            CGContextDrawLinearGradient(context, fillGradient,
                                        CGPointMake(0, -_gradientTopPosition),
                                        CGPointMake(0, -_gradientTopPosition + _gradientHeight),
                                        0);
        }
        CGContextRestoreGState(context);
    }
    
    CGContextSaveGState(context);
    {
        if (_wantsDefaultContentAppearance == NO && _borderWidth > 0) {
            [roundedRectPath addClip];
            CGContextSetShadowWithColor(context, _innerShadowOffset, _innerShadowBlurRadius, _innerShadowColor.CGColor);
        }
        
        UIBezierPath *inRoundedRectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(innerRect, 0.5, 0.5) cornerRadius:cornerRadius];
        
        if (_borderWidth == 0) {
            inRoundedRectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(innerRect, 0.5, 0.5) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
        
        [self.innerStrokeColor setStroke];
        inRoundedRectPath.lineWidth = 1;
        [inRoundedRectPath stroke];
    }
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(fillGradient);
    CGColorSpaceRelease(colorSpace);
}


- (void)dealloc {
    _innerShadowColor = nil;
    _innerStrokeColor = nil;
    _gradientTopColor = nil;
    _gradientBottomColor = nil;
}

@end

