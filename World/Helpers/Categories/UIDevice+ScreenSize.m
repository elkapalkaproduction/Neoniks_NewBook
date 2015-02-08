//
//  UIDevice+ScreenSize.m
//  World
//
//  Created by Andrei Vidrasco on 2/8/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "UIDevice+ScreenSize.h"

@implementation UIDevice (ScreenSize)

+ (CGSize)screenSize {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return CGSizeMake(screenSize.height, screenSize.width);
    } else {
        return screenSize;
    }
}


+ (BOOL)isIpad {
    return [[self currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

@end
