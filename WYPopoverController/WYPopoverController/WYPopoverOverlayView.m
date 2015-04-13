//
//  WYPopoverOverlayView.m
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WYPopoverOverlayView.h"

@implementation WYPopoverOverlayView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (_testHits) {
        return nil;
    }
    
    UIView *view = [super hitTest:point withEvent:event];
    
    if (view == self) {
        _testHits = YES;
        UIView *superHitView = [self.superview hitTest:point withEvent:event];
        _testHits = NO;
        
        if ([self isPassthroughView:superHitView]) {
            if ([self.delegate dismissOnPassthroughViewTap]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self.delegate respondsToSelector:@selector(popoverOverlayViewDidTouch:)]) {
                        [self.delegate popoverOverlayViewDidTouch:self];
                    }
                });
            }
            
            return superHitView;
        }
    }
    
    return view;
}


- (BOOL)isPassthroughView:(UIView *)view {
    if (view == nil) {
        return NO;
    }
    if ([self.passthroughViews containsObject:view]) {
        return YES;
    }
    
    return [self isPassthroughView:view.superview];
}


- (void)drawRect:(CGRect)rect {
}


- (void)accessibilityElementDidBecomeFocused {
    self.accessibilityLabel = NSLocalizedString(@"Double-tap to dismiss pop-up window.", nil);
}

@end
