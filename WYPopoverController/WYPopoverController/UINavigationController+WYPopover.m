//
//  UINavigationController+WYPopover.m
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "UINavigationController+WYPopover.h"
#import <objc/runtime.h>

@implementation UINavigationController (WYPopover)

static char const *const UINavigationControllerEmbedInPopoverTagKey = "UINavigationControllerEmbedInPopoverTagKey";

@dynamic wy_embedInPopover;

+ (void)load {
    Method original, swizzle;
    
    original = class_getInstanceMethod(self, @selector(pushViewController:animated:));
    swizzle = class_getInstanceMethod(self, @selector(sizzled_pushViewController:animated:));
    
    method_exchangeImplementations(original, swizzle);
    
    original = class_getInstanceMethod(self, @selector(setViewControllers:animated:));
    swizzle = class_getInstanceMethod(self, @selector(sizzled_setViewControllers:animated:));
    
    method_exchangeImplementations(original, swizzle);
}


- (BOOL)wy_isEmbedInPopover {
    BOOL result = NO;
    
    NSNumber *value = objc_getAssociatedObject(self, UINavigationControllerEmbedInPopoverTagKey);
    
    if (value) {
        result = [value boolValue];
    }
    
    return result;
}


- (void)setWy_embedInPopover:(BOOL)value {
    objc_setAssociatedObject(self, UINavigationControllerEmbedInPopoverTagKey, [NSNumber numberWithBool:value], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (CGSize)contentSize:(UIViewController *)aViewController {
    CGSize result = CGSizeZero;
    
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
    if ([aViewController respondsToSelector:@selector(contentSizeForViewInPopover)]) {
        result = aViewController.contentSizeForViewInPopover;
    }
#pragma clang diagnostic pop
    
    if ([aViewController respondsToSelector:@selector(preferredContentSize)]) {
        result = aViewController.preferredContentSize;
    }
    
    return result;
}


- (void)setContentSize:(CGSize)aContentSize {
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
    [self setContentSizeForViewInPopover:aContentSize];
#pragma clang diagnostic pop
    
    if ([self respondsToSelector:@selector(setPreferredContentSize:)]) {
        [self setPreferredContentSize:aContentSize];
    }
}


- (void)sizzled_pushViewController:(UIViewController *)aViewController animated:(BOOL)aAnimated {
    if (self.wy_isEmbedInPopover) {
        if ([aViewController respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            aViewController.edgesForExtendedLayout = UIRectEdgeNone;
        }
        CGSize contentSize = [self contentSize:aViewController];
        [self setContentSize:contentSize];
    }
    
    [self sizzled_pushViewController:aViewController animated:aAnimated];
    
    if (self.wy_isEmbedInPopover) {
        CGSize contentSize = [self contentSize:aViewController];
        [self setContentSize:contentSize];
    }
}


- (void)sizzled_setViewControllers:(NSArray *)aViewControllers animated:(BOOL)aAnimated {
    NSUInteger count = [aViewControllers count];
    
    if (self.wy_isEmbedInPopover && count > 0) {
        for (UIViewController *viewController in aViewControllers) {
            if ([viewController respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
                viewController.edgesForExtendedLayout = UIRectEdgeNone;
            }
        }
    }
    
    [self sizzled_setViewControllers:aViewControllers animated:aAnimated];
    
    if (self.wy_isEmbedInPopover && count > 0) {
        UIViewController *topViewController = [aViewControllers objectAtIndex:(count - 1)];
        CGSize contentSize = [self contentSize:topViewController];
        [self setContentSize:contentSize];
    }
}

@end
