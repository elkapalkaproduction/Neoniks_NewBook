//
//  AlertViewController.m
//  World
//
//  Created by Andrei Vidrasco on 4/5/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "AlertViewController.h"
#import "Animator.h"

@interface AlertViewController ()
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *firstButtonText;
@property (strong, nonatomic) NSString *secondButtonText;

@property (copy, nonatomic) AlertButtonAction firstAction;
@property (copy, nonatomic) AlertButtonAction secondAction;

@end

@implementation AlertViewController

+ (instancetype)initWithTitle:(NSString *)title
             firstButtonTitle:(NSString *)firstButtonTitle
            firstButtonAction:(AlertButtonAction)firstAction
            secondButtonTitle:(NSString *)secondButtonTitle
           secondButtonAction:(AlertButtonAction)secondAction {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AlertViewController *alertView = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    alertView.titleText = NSLocalizedString(title, nil);
    alertView.firstButtonText = NSLocalizedString(firstButtonTitle, nil);
    alertView.secondButtonText = NSLocalizedString(secondButtonTitle, nil);
    alertView.firstAction = firstAction;
    alertView.secondAction = secondAction;

    return alertView;
}


- (void)showInViewController:(UIViewController *)viewController {
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = [Animator disolveAnimator];
    [viewController presentViewController:self animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeButton:self.firstButton];
    [self customizeButton:self.secondButton];
    self.titleLabel.font = [UIFont baseFontOfSize:20];
    
    [self.firstButton setTitle:self.firstButtonText forState:UIControlStateNormal];
    [self.secondButton setTitle:self.secondButtonText forState:UIControlStateNormal];
    self.titleLabel.text = self.titleText;
}


- (void)customizeButton:(UIButton *)button {
    button.titleLabel.font = [UIFont baseFontOfSize:18];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(-10.0f, -10.0f, 0.0f, 0.0f)];
    [button setTitleColor:[UIColor baseYellowColor] forState:UIControlStateNormal];
}


- (IBAction)firstButtonPressed:(id)sender {
    if (self.firstAction) self.firstAction();
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)secondButtonPressed:(id)sender {
    if (self.secondAction) self.secondAction();
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
