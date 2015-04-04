//
//  TransitionAnimation.h
//  Jabba
//
//  Created by Andrei Vidrasco on 3/26/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning>

- (void)handleDismissWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)handlePresentWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
