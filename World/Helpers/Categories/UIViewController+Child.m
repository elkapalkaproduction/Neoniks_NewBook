//
//  UIViewController+Child.m
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "UIViewController+Child.h"

@implementation UIViewController (Child)

- (void)addChildViewController:(UIViewController *)child withSuperview:(UIView *)superview {
    UIViewController *parent = self;
    [child willMoveToParentViewController:parent];
    [parent addChildViewController:child];
    [child didMoveToParentViewController:parent];
    [superview addSubview:child.view];
}

@end
