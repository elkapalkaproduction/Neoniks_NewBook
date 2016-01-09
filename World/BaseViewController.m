//
//  BaseViewController.m
//  World
//
//  Created by Andrei Vidrasco on 2/1/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "BaseViewController.h"

const NSInteger storyboardScreenWidth = 600;

@interface BaseViewController ()

@property (strong, nonatomic) NSMutableArray *constants;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.constants = [[NSMutableArray alloc] init];
    [self.constraintsToUpdate enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
         self.constants[idx] = @(obj.constant);
     }];
}


- (void)viewDidLayoutSubviews {
    [self.constraintsToUpdate enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
         obj.constant = [self.constants[idx] integerValue] * [self scaleFactor];
     }];
    [super viewDidLayoutSubviews];
}


- (CGFloat)scaleFactor {
    return [UIScreen mainScreen].bounds.size.width / storyboardScreenWidth;
}


- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dealloc {
    NSLog(@"%@", [[self class] storyboardID]);
}


+ (NSString *)storyboardID {
    return NSStringFromClass([self class]);
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

@end
