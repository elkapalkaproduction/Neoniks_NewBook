//
//  Animator.h
//  Jabba
//
//  Created by Andrei Vidrasco on 3/26/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animator : NSObject <UIViewControllerTransitioningDelegate>

+ (instancetype)fromUpToDownAnimator;
+ (instancetype)fromDownToUpAnimator;
+ (instancetype)disolveAnimator;

@end
