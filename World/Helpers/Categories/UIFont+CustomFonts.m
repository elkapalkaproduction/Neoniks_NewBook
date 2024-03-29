//
//  UIFont+CustomFonts.m
//  World
//
//  Created by Andrei Vidrasco on 2/6/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "UIFont+CustomFonts.h"

@implementation UIFont (CustomFonts)

+ (instancetype)baseFontOfSize:(CGFloat)size {
    CGFloat ratio = [UIDevice isIpad] ? (5.f / 3.f) : 1;

    return [UIFont fontWithName:@"Doux-Medium" size:size * ratio];
}


+ (instancetype)georgiaFontOfSize:(CGFloat)size {
    CGFloat ratio = [UIDevice isIpad] ? (5.f / 3.f) : 1;
    
    return [UIFont fontWithName:@"Georgia" size:size * ratio];
}

@end
