//
//  TransitionAnimationDisolve.m
//  World
//
//  Created by Andrei Vidrasco on 4/4/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "TransitionAnimationDisolve.h"

@implementation TransitionAnimationDisolve

- (void)handlePresentWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [transitionContext.containerView addSubview:fromViewController.view];
    [transitionContext.containerView addSubview:toViewController.view];
    toViewController.view.frame = [[transitionContext containerView] bounds];
    toViewController.view.alpha = 0.f;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toViewController.view.alpha = 1.f;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}


- (void)handleDismissWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [transitionContext.containerView addSubview:toViewController.view];
    [transitionContext.containerView addSubview:fromViewController.view];
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.alpha = 0.f;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication].keyWindow addSubview:toViewController.view];
        [transitionContext completeTransition:YES];
    }];
}

@end
