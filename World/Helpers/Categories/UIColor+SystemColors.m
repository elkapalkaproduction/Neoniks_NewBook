//
//  UIColor+SystemColors.m
//  World
//
//  Created by Andrei Vidrasco on 2/6/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "UIColor+SystemColors.h"

@implementation UIColor (SystemColors)

+ (instancetype)baseYellowColor {
    return [UIColor colorWithRed:244.f / 255.f green:233.f / 255.f blue:140.f / 255.f alpha:1.f];
}


+ (instancetype)questionTitleColor {
    return [UIColor colorWithRed:255.f / 255.f green:192.f / 255.f blue:0.f / 255.f alpha:1.f];
}


+ (instancetype)colorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    unsigned rgbValue = 0;
    [[NSScanner scannerWithString:colorString] scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0
                           green:((rgbValue & 0xFF00) >> 8) / 255.0
                            blue:(rgbValue & 0xFF) / 255.0
                           alpha:1.0];
}

@end
