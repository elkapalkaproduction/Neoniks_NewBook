//
//  UIImage+WYPopover.m
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "UIImage+WYPopover.h"

@implementation UIImage (WYPopover)

static float edgeSizeFromCornerRadius(float cornerRadius) {
    return cornerRadius * 2 + 1;
}


+ (UIImage *)wy_imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(8, 8) cornerRadius:0];
}


+ (UIImage *)imageWithColor:(UIColor *)color
               cornerRadius:(float)cornerRadius {
    float min = edgeSizeFromCornerRadius(cornerRadius);
    
    CGSize minSize = CGSizeMake(min, min);
    
    return [self imageWithColor:color size:minSize cornerRadius:cornerRadius];
}


+ (UIImage *)imageWithColor:(UIColor *)color
                       size:(CGSize)aSize
               cornerRadius:(float)cornerRadius {
    CGRect rect = CGRectMake(0, 0, aSize.width, aSize.height);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

@end
