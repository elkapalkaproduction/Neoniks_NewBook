//
//  ViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "LogoViewController.h"
#import "Storage.h"
#import "NNWVideoViewController.h"
#import "ViewController.h"

NSString *const VideoAlreadyPlayedKey = @"VideoAlreadyPlayedKey";

@interface LogoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@end

@implementation LogoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateImages];
    [self shortAnimation];
}


- (void)updateImages {
    [self.logoImage setImage:[UIImage imageLocalizableNamed:@"start_logo"]];
}


- (void)shortAnimation {
    float timeInterval = 1.f;
    self.logoImage.alpha = 0.f;
    UIViewController *viewController = [ViewController instantiate];
    [viewController view];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [UIView animateWithDuration:timeInterval delay:timeInterval options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.logoImage.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:timeInterval delay:timeInterval options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.logoImage.alpha = 0.f;
        } completion:^(BOOL finished) {
            window.rootViewController = viewController;
            if (![Storage loadIntegerForKey:VideoAlreadyPlayedKey]) {
                [Storage saveInteger:1 forKey:VideoAlreadyPlayedKey];
                [viewController presentViewController:[NNWVideoViewController instantiate] animated:YES completion:nil];
            }
        }];
    }];
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

@end
