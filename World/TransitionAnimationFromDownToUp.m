//
//  AnimationFromDownToUpForPreseting.m
//  Jabba
//
//  Created by Andrei Vidrasco on 3/26/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import "TransitionAnimationFromDownToUp.h"

@implementation TransitionAnimationFromDownToUp

- (void)handleDismissWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    CGRect endFrame = [[transitionContext containerView] bounds];
    [transitionContext.containerView addSubview:toViewController.view];
    [transitionContext.containerView addSubview:fromViewController.view];
    
    endFrame.origin.y += CGRectGetHeight([[transitionContext containerView] bounds]);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.frame = endFrame;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication].keyWindow addSubview:toViewController.view];
        [transitionContext completeTransition:YES];
    }];
}


- (void)handlePresentWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    CGRect endFrame = [[transitionContext containerView] bounds];
    [transitionContext.containerView addSubview:fromViewController.view];
    [transitionContext.containerView addSubview:toViewController.view];
    
    CGRect startFrame = endFrame;
    startFrame.origin.y += CGRectGetHeight([[transitionContext containerView] bounds]) - [fromViewController.topLayoutGuide length];
    
    toViewController.view.frame = startFrame;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toViewController.view.frame = endFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
