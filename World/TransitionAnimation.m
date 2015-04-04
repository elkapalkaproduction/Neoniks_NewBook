//
//  TransitionAnimation.m
//  Jabba
//
//  Created by Andrei Vidrasco on 3/26/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import "TransitionAnimation.h"

@implementation TransitionAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    BOOL isPresenting = [self isPresentingViewControllerFromTransitionContext:transitionContext];
    if (isPresenting) {
        [self handlePresentWithTransitionContext:transitionContext];
    } else {
        [self handleDismissWithTransitionContext:transitionContext];
    }
}


- (void)handleDismissWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
}


- (void)handlePresentWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
}


- (BOOL)isPresentingViewControllerFromTransitionContext:(id)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    return [toViewController presentedViewController] != fromViewController;
}

@end
