//
//  UIViewController (WYPopover).m
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "UIViewController+WYPopover.h"
#import "UINavigationController+WYPopover.h"

#import <objc/runtime.h>

@implementation UIViewController (WYPopover)

+ (void)load {
    Method original, swizzle;
    
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
    original = class_getInstanceMethod(self, @selector(setContentSizeForViewInPopover:));
    swizzle = class_getInstanceMethod(self, @selector(sizzled_setContentSizeForViewInPopover:));
    method_exchangeImplementations(original, swizzle);
#pragma clang diagnostic pop
    
    original = class_getInstanceMethod(self, @selector(setPreferredContentSize:));
    swizzle = class_getInstanceMethod(self, @selector(sizzled_setPreferredContentSize:));
    
    if (original != NULL) {
        method_exchangeImplementations(original, swizzle);
    }
}


- (void)sizzled_setContentSizeForViewInPopover:(CGSize)aSize {
    [self sizzled_setContentSizeForViewInPopover:aSize];
    
    if ([self isKindOfClass:[UINavigationController class]] == NO && self.navigationController != nil) {
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
        [self.navigationController setContentSizeForViewInPopover:aSize];
#pragma clang diagnostic pop
    }
}


- (void)sizzled_setPreferredContentSize:(CGSize)aSize {
    [self sizzled_setPreferredContentSize:aSize];
    
    if ([self isKindOfClass:[UINavigationController class]] == NO && self.navigationController != nil) {
        if ([self.navigationController wy_isEmbedInPopover] == NO) {
            return;
        } else if ([self respondsToSelector:@selector(setPreferredContentSize:)]) {
            [self.navigationController sizzled_setPreferredContentSize:aSize];
        }
    }
}

@end
