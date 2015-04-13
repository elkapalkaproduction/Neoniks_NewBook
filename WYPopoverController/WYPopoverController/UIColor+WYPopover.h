//
//  UIColor+WYPopover.h
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface UIColor (WYPopover)

- (BOOL)wy_getValueOfRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)apha;
- (NSString *)wy_hexString;
- (UIColor *)wy_colorByLighten:(float)d;
- (UIColor *)wy_colorByDarken:(float)d;

@end
