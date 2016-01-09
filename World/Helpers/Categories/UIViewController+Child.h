//
//  UIViewController+Child.h
//  World
//
//  Created by Andrei Vidrasco on 4/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Child)

- (void)addChildViewController:(UIViewController *)child withSuperview:(UIView *)view;
- (void)removeFromParent;

@end
