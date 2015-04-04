//
//  AlertViewController.h
//  World
//
//  Created by Andrei Vidrasco on 4/5/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^AlertButtonAction)();
@interface AlertViewController : BaseViewController

+ (instancetype)initWithTitle:(NSString *)title
             firstButtonTitle:(NSString *)firstButtonTitle
            firstButtonAction:(AlertButtonAction)firstAction
            secondButtonTitle:(NSString *)secondButtonTitle
            secondButtonAction:(AlertButtonAction)secondAction;

- (void)showInViewController:(UIViewController *)viewController;

@end
