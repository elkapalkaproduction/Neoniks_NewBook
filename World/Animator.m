//
//  Animator.m
//  Jabba
//
//  Created by Andrei Vidrasco on 3/26/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import "Animator.h"
#import "TransitionAnimation.h"
#import "TransitionAnimationFromUpToDown.h"
#import "TransitionAnimationFromDownToUp.h"
#import "TransitionAnimationDisolve.h"

@interface Animator ()

@property (strong, nonatomic) TransitionAnimation *presenting;

@end

@implementation Animator

+ (instancetype)defaultAnimator {
    static id sharedAnimator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAnimator = [[self alloc] init];
    });
    
    return sharedAnimator;
}


+ (instancetype)fromDownToUpAnimator {
    Animator *animator = [Animator defaultAnimator];
    animator.presenting = [[TransitionAnimationFromDownToUp alloc] init];
    
    return animator;
}


+ (instancetype)fromUpToDownAnimator {
    Animator *animator = [Animator defaultAnimator];
    animator.presenting = [[TransitionAnimationFromUpToDown alloc] init];
    
    return animator;
}


+ (instancetype)disolveAnimator {
    Animator *animator = [Animator defaultAnimator];
    animator.presenting = [[TransitionAnimationDisolve alloc] init];
    
    return animator;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.presenting;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.presenting;
}

@end
